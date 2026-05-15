function J = sledge_fitness( ...
    p, ...
    t_data, ...
    u_data, ...
    x_measured)

    y0 = [0; 0];

    try

        opts = odeset( ...
            'RelTol',1e-4, ...
            'AbsTol',1e-5);

        [~, y_sim] = ode45( ...
            @(t,y) sledge_ode(t, y, p, t_data, u_data), ...
            t_data, ...
            y0, ...
            opts);

        if size(y_sim,1) ~= length(x_measured)

            J = 1e12;
            return;

        end

        if any(isnan(y_sim(:)))

            J = 1e12;
            return;

        end

        %% Position Error

        x_sim = y_sim(:,1);

        Jx = mean((x_measured - x_sim).^2);

        %% Velocity Error

        v_sim = y_sim(:,2);

        v_measured = gradient(x_measured) ./ gradient(t_data);

        % Smooth numerical derivative
        v_measured = movmean(v_measured, 10);

        Jv = mean((v_measured - v_sim).^2);

        %% Total Cost

        wx = 1.0;
        wv = 0.1;

        J = wx*Jx + wv*Jv;

    catch

        J = 1e12;

    end

end