function data_id = processDataset(inputFile, sledgeFile, pendulumFile)
    disp(inputFile)
    % Load
    u_data = load(inputFile).ans;
    s_data = load(sledgeFile).ans;
    p_data = load(pendulumFile).ans;

    assert(~isempty(u_data.Time), 'Input time is empty');
    assert(~isempty(s_data.Time), 'Sledge time is empty');
    assert(~isempty(p_data.Time), 'Pendulum time is empty');

    t_u = u_data.Time;
    u   = u_data.Data;

    t_s = s_data.Time;
    y_s = s_data.Data;

    t_p = p_data.Time;
    y_p = p_data.Data;

    % Define common time base
    Ts = 0.01;  % choose ONE sampling time for everything
    t_common = (max([t_u(1), t_s(1), t_p(1)]) : Ts : ...
                min([t_u(end), t_s(end), t_p(end)]) )';

    % Interpolation
    u_interp = interp1(t_u, u, t_common, 'linear');
    y_s_interp = interp1(t_s, y_s, t_common, 'linear');
    y_p_interp = interp1(t_p, y_p, t_common, 'linear');

    % Remove offsets (VERY important)
    %u_interp = u_interp - mean(u_interp);
    % y_s_interp = y_s_interp - mean(y_s_interp);
    y_p_interp = y_p_interp - mean(y_p_interp);

    % Filtering (low-pass)
    fc = 5; % cutoff frequency (tune this!)
    [b,a] = butter(2, fc * 2 * Ts);  % normalized frequency

    u_f = filtfilt(b,a,u_interp);
    y_s_f = filtfilt(b,a,y_s_interp);
    y_p_f = filtfilt(b,a,y_p_interp);

    % % Optional: deadband compensation (your system needs this)
    % deadband = 0.5; % voltage threshold
    % u_f(abs(u_f) < deadband) = 0;

    % Create iddata (MIMO: 1 input, 2 outputs)
    data_id = iddata([y_s_f y_p_f], u_f, Ts);


end