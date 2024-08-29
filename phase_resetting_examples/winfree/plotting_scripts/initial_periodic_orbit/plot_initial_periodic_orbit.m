function plot_initial_periodic_orbit(save_figure)
  % plot_initial_periodic_orbit()
  %
  % Plots the initial periodic orbit from the 'coll' toolbox run.
  % along with the three stationary points ('q', 'p', and 'o'),
  % and the one-dimensional stable manifold of point 'q'. The data
  % is read from the file './data/initial_PO.mat'.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Load data matrix
  load('./data_mat/initial_PO.mat');

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
        LineStyle='-', Color=colours(3, :), ...
        DisplayName='$\Gamma$');

  % Plot equilibrium points: x_{0}
  plot(ax, x_0(1), x_0(2), ...
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

  %----------------------%
  %      Save Figure     %
  %----------------------%
  if save_figure == true
    % Filename
    figname = './images/initial_periodic_orbit.pdf';
    exportgraphics(fig, figname, ContentType='vector');
  end

end