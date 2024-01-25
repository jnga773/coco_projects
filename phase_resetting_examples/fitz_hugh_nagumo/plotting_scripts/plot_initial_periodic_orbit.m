function plot_initial_periodic_orbit(run_in, label_in)
  % plot_initial_periodic_orbits(run_in, label_in)
  %
  % Plot test periodic orbits from 'coll' solutions

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution
  sol = coll_read_solution('initial_PO', run_in, label_in);

  % Time data
  t = sol.tbp;
  % State space data
  x = sol.xbp;


  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(3);
  fig.Name = 'ode45 Periodic Orbit Solutions';
  fig.Units = 'inches';
  fig.Position = [3, 3, 12, 8]; fig.PaperSize = [12, 8];

  % Axis
  tiles = tiledlayout(1, 2, Padding='compact', TileSpacing='compact');
  ax = [];

  % Colours
  C = colororder();

  %---------------------------%
  %     Plot: Time Series     %
  %---------------------------%
  ax1 = nexttile;
  ax = [ax, ax1];

  hold(ax1, 'on');

  % Plot first component
  plot(ax, t, x(:, 1), Color=C(1, :), LineStyle='-', ...
       DisplayName='$x_{1}(t)$');

  % Plot second component
  plot(ax, t, x(:, 2), Color=C(2, :), LineStyle='--', ...
       DisplayName='$x_{2}(t)$');

  legend(ax1, Interpreter='latex');

  hold(ax1, 'off');

  % Labels
  ax1.XAxis.Label.String = '$t$';
  ax1.YAxis.Label.String = '$\vec{x}(t)$';

  % Figure stuff
  grid(ax1, 'on');
  box(ax1, 'on');

  %---------------------------%
  %     Plot: Phase Space     %
  %---------------------------%
  ax2 = nexttile;

  hold(ax2, 'on');

  % Plot first component
  plot(ax2, x(:, 1), x(:, 2), Color=C(1, :), LineStyle='-', ...
       DisplayName='$x_{1}(t)$');

  hold(ax2, 'off');

  % Labels
  ax2.XAxis.Label.String = '$x_{1}(t)$';
  ax2.YAxis.Label.String = '$x_{2}(t)$';

  % Figure stuff
  grid(ax2, 'on');
  box(ax2, 'on');

end