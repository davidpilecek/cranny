function J_total = sledge_fitness_multi( ...
    p, ...
    data_all)

    J_total = 0;

    n_exp = length(data_all.ExperimentName);

    for k = 1:n_exp

        exp_data = getexp(data_all,k);

        t_data = exp_data.SamplingInstants(:);
        u_data = exp_data.InputData(:);
        x_measured = exp_data.OutputData(:);

        y0 = [0;0];

        try

            opts = odeset( ...
                'RelTol',1e-4, ...
                'AbsTol',1e-5);

            [~, y_sim] = ode45( ...
                @(t,y) sledge_ode( ...
                    t, y, p, ...
                    t_data, u_data), ...
                t_data, ...
                y0, ...
                opts);

            if size(y_sim,1) ~= length(x_measured)

                J_total = J_total + 1e12;
                continue;

            end

            if any(isnan(y_sim(:)))

                J_total = J_total + 1e12;
                continue;

            end

            %% Position Error

            x_sim = y_sim(:,1);

            Jx = mean((x_measured - x_sim).^2);

            %% Velocity Error

            v_sim = y_sim(:,2);

            v_measured = gradient(x_measured) ./ gradient(t_data);

            v_measured = movmean(v_measured,10);

            Jv = mean((v_measured - v_sim).^2);

            %% Total Cost

            wx = 1.0;
            wv = 0; % Try setting to 0

            J_total = J_total + wx*Jx + wv*Jv;

        catch

            J_total = J_total + 1e12;

        end

    end

end