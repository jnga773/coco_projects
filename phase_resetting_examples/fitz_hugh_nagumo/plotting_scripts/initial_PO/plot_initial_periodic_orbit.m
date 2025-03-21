function plot_initial_periodic_orbit()
  % Plot the solution g
  
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Load data matrix
  load('./data_mat/initial_PO.mat');

  %--------------%
  %     Plot     %
  %--------------%
  % Colour order
  colours = colororder();

  %--------------------------------------%
  %     Plot Initial Periodic Orbits     %
  %--------------------------------------%
  % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(1); fig.Name = 'Initial Periodic Orbits'; clf;
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  %--------------%
  %     Plot     %
  %--------------%
  % Hold axes
  hold(ax, 'on');

  % Plot periodic orbit
  plot(ax, xbp_PO(:, 1), xbp_PO(:, 2), LineStyle='-', Color=[0.0, 0.0, 0.0, 0.3], ...
       LineWidth=4.0, DisplayName='$\Gamma$');

  % Plot equilibrium points: x_{0}
  plot(ax, x0(1), x0(2), ...
        LineStyle='none', ...
        Marker='o', MarkerFaceColor='r', MarkerSize=10, ...
        MarkerEdgeColor='r', DisplayName='$\vec{x}_{\ast}$');

  hold(ax, 'off');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % % X-Axis
  % ax.XAxis.TickDirection = 'in';
  % ax.XAxis.TickValues = -1.0 :0.5: 1.0;
  % ax.XAxis.MinorTick = 'on';
  % ax.XAxis.MinorTickValues = -0.75: 0.5: 0.75;
  % 
  % % Y-Axis
  % ax.YAxis.TickDirection = 'in';
  % ax.YAxis.TickValues = -1.0 : 0.5 : 1.0;
  % ax.YAxis.MinorTick = 'on';
  % ax.YAxis.MinorTickValues = -0.75 : 0.5 : 0.75;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  % ax.XAxis.Limits = [-1.05, 1.05];
  % ax.YAxis.Limits = [-1.05, 1.05];

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