function dydt = sledge_ode( ...
    t, y, p, ...
    t_data, u_data)

    %% Known Constants

    rm = 0.007;      % [m]
    Ra = 0.368;      % [Ohm]
    ms = 0.93;
    
    %% Estimated Parameters
    % p = [Kt, Jm, Dm, Ds]
    Kt = p(1);
    Jm = p(2);
    Dm = p(3);
    Ds = p(4);

    Ke = Kt;
    %% States

    x_dot = y(2);

    %% Input Voltage

    Va = interp1( ...
        t_data, ...
        u_data, ...
        t, ...
        'linear', ...
        'extrap');

    %% Equivalent Dynamics

    M_eq = ms + Jm/(rm^2);

    D_eq = ...
        (Kt*Ke)/(rm^2 * Ra) ...
        + Dm/(rm^2) ...
        + Ds;

    F_in = Va * (Kt/(rm * Ra));

    %% Dynamics

    x_ddot = ( ...
        F_in ...
        - D_eq*x_dot) / M_eq;

    %% State Derivative

    dydt = [
        x_dot;
        x_ddot
    ];

end