function plot_isochrons(run_in, SP_labels_in, save_figure)
  % plot_isochrons(run_in, SP_labels_in)
  %
  % Plots the isochron figure from all of the continuation runs from this
  % script.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read base periodic orbit solution
  sol_PO = coll_read_solution('initial_PO', 'run05_initial_periodic_orbit', 1);

  % Periodic orbit solution
  xbp_PO = sol_PO.xbp;

  x1_data = {};
  x2_data = {};

  % Cycle through all solutions from 'SP_labels_in'
  for i = 1 : length(SP_labels_in)
    % Solution label
    solution = SP_labels_in(i);

    % Create run name identifier
    run_i = sprintf('SP_%d', solution);
    % Append to directory
    this_run   = {run_in, run_i};

    % Read bifurcation data
    bd = coco_bd_read(this_run);

    % Read isochron data
    x1 = coco_bd_col(bd, 'iso1');
    x2 = coco_bd_col(bd, 'iso2');

    % Save to cell thingie
    x1_data{i} = x1;
    x2_data{i} = x2;

  end
    

  %--------------%
  %     Plot     %
  %--------------%
  % Plot test periodic orbits from ode45 solutions
  fig = figure(4);
  fig.Name = 'Isochrons';
  fig.Units = 'inches';
  fig.Position = [1, 1, 12, 8]; fig.PaperSize = [12, 8];

  % Axis
  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  % Colours
  C = colororder();

  hold(ax, 'on');

  % Plot base solution
  plot(ax, xbp_PO(:, 1), xbp_PO(:, 2), Color='k', LineWidth=3.0, ...
        DisplayName='$\Gamma$');

  % Cycle through isochron data
  for i = 1 : length(SP_labels_in)
    % Plot data
    plot(ax, x1_data{i}, x2_data{i}, HandleVisibility='off');

  end

  legend(ax, Interpreter='latex', Location='northwest');
  
  hold(ax, 'off')

  % Labels
  ax.XAxis.Label.String = '$x_{1}(t)$';
  ax.YAxis.Label.String = '$x_{2}(t)$';

  % Axis Limits
  ax.XAxis.Limits = [-1.0, 1.5];
  ax.YAxis.Limits = [-0.5, 2.0];

  % Axis Ticks
  ax.XAxis.TickValues = -1.0 : 0.5 : 1.5;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -0.75 : 0.5 : 1.25;

  ax.YAxis.TickValues = -0.5 : 0.5 : 2.0;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -0.25 : 0.5 : 1.75;

  % Tick direction
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  % ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;

  %---------------------%
  %     Save Figure     %
  %---------------------%
  if save_figure == true
    % Create filename
    filename_out = sprintf('./images/isochron_%d_runs.pdf', length(SP_labels_in));
    % Save figure
    exportgraphics(fig, filename_out, ContentType='vector');

  end

end