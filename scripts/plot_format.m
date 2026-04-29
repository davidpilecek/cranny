function plot_format()
    % Global defaults for consistent report-quality plots

    set(groot, 'defaultTextInterpreter','latex');
    set(groot, 'defaultAxesTickLabelInterpreter','latex');
    set(groot, 'defaultLegendInterpreter','latex');

    % Font + size
    set(groot, 'defaultAxesFontName','Times New Roman');
    set(groot, 'defaultTextFontName','Times New Roman');
    set(groot, 'defaultLegendFontName','Times New Roman');
    
    set(groot, 'defaultAxesFontWeight','bold');
    set(groot, 'defaultTextFontWeight','bold');
    set(groot, 'defaultLegendFontWeight','bold');
    
    set(groot, 'defaultAxesFontSize',15);
    set(groot, 'defaultTextFontSize',15);


    % Line + grid
    set(groot, 'defaultLineLineWidth',1.5);
    set(groot, 'defaultAxesLineWidth',1);
    set(groot, 'defaultAxesGridAlpha',0.15);
    set(groot, 'defaultAxesXGrid','on');
    set(groot, 'defaultAxesYGrid','on');

    % Figure defaults (good for papers)
    set(groot, 'defaultFigureColor','w');
    set(groot, 'defaultFigureUnits','centimeters');
    set(groot, 'defaultFigurePosition',[5 5 14 9]); % ~single-column width

   
    % Legend (opaque box)
    set(groot, 'defaultLegendBox','on');
    set(groot, 'defaultLegendColor','white');
end