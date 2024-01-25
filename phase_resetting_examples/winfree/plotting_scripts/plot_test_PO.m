function plot_test_PO(run_in, label_in)
  % Plot the solution g

  % Read da solution g
  sol = coll_read_solution('initial_PO', run_in, label_in);
  x_plot = sol.xbp;

  %--------------------------------------%
  %     Plot Initial Periodic Orbits     %
  %--------------------------------------%
  % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(1); fig.Name = 'Initial Periodic Orbits'; clf;
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  % Hold axes
  hold(ax, 'on');
  
  % Plot base solution
  plot_base_periodic_orbit(ax);

  % Plot continuation solution
  plot(ax, x_plot(:, 1), x_plot(:, 2), LineStyle='-', Color=colours(1, :), ...
       DisplayName='Solution');

  legend(ax, Interpreter='latex');

  hold(ax, 'off');

  % Axis Ticks
  ax.XAxis.TickValues = -1.0:0.5:1.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -0.75:0.5:0.75;

  ax.YAxis.TickValues = -1.0:0.5:1.0;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -0.75:0.5:0.75;

  % Axis limits
  ax.XAxis.Limits = [-1.05, 1.05];
  ax.YAxis.Limits = [-1.05, 1.05];

  % Axis Labels
  ax.XAxis.Label.String = '$x(t)$';
  ax.YAxis.Label.String = '$y(t)$';

  % Axis title
  ax.Title.String = 'Initial Periodic Orbit';

  % Tick params
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;

end