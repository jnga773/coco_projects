function plot_initial_PO(run_in, label_in)
  % plot_initial_PO(run_in, label_in)
  %
  % Plots the initial periodic orbit from the 'coll' toolbox run.
  % along with the three stationary points ('q', 'p', and 'o'),
  % and the one-dimensional stable manifold of point 'q'. The data
  % is read from the file './data/initial_PO.mat'.
  %
  % Parameters
  % ----------
  % run_in : character
  %    String identifier for the COCO run.
  % label_in : double
  %    Index label for the solution to plot

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read 'COLL' data
  [sol_PO, data_PO] = coll_read_solution('initial_PO', run_in, label_in);

  % State-space solution
  xbp_PO = sol_PO.xbp;

  % Read 'EP' data
  [sol_EP, data_EP] = ep_read_solution('x0', run_in, label_in);

  % Equilibrium point
  x0 = sol_EP.x;

  %--------------------------------------%
  %     Plot Initial Periodic Orbits     %
  %--------------------------------------%
  % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(2); fig.Name = 'Initial Periodic Orbits'; clf;
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  %--------------%
  %     Plot     %
  %--------------%
  % Hold axes
  hold(ax, 'on');

  % Plotting colours
  colours = colororder();

  % Plot initial periodic orbit
  plot(ax, xbp_PO(:, 1), xbp_PO(:, 2), ...
        LineStyle='-', Color=colours(3, :), LineWidth=2.5, ...
        DisplayName='$\Gamma$');

  % Plot equilibrium points: x_{0}
  plot(ax, x0(1), x0(2), ...
        LineStyle='none', ...
        Marker='o', MarkerFaceColor='r', MarkerSize=10, ...
        MarkerEdgeColor='r', DisplayName='$\vec{x}_{\ast}$');

  % Legend
  legend(ax, Interpreter='latex');

  % Turn of axis hold
  hold(ax, 'off');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax.XAxis.TickValues = -1.0 : 0.25 : 1.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -0.875 : 0.25 : 0.9;

  % Y-Axis
  ax.YAxis.TickValues = -1.0 : 0.25 : 1.0;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -0.875 : 0.25 : 0.9;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax.XAxis.Limits = [-1.05, 1.05];
  ax.YAxis.Limits = [-1.05, 1.05];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$x_{1}(t)$';
  ax.YAxis.Label.String = '$x_{2}(t)$';

  %--------------------%
  %     Axis Title     %
  %--------------------%
  ax.Title.String = 'Initial Periodic Orbit';

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  box(ax, 'on');
  grid(ax, 'on');

end