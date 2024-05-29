function plot_test_PO(run_in, label_in, save_figure)
  % Plot the solution g

  % Read da solution g
  sol = coll_read_solution('initial_PO', run_in, label_in);
  x_plot = sol.xbp;

  % Read da equilibrium points g
  sol1 = ep_read_solution('x0', run_in, label_in);

  x_ss = sol1.x;

  %-----------------------------------------------------------------------%
  %                     Plot Initial Periodic Orbits                      %
  %-----------------------------------------------------------------------%
  % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(1); fig.Name = 'Initial Periodic Orbits'; clf;
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;
  ax.FontSize = 14;

  %--------------%
  %     Plot     %
  %--------------%
  % Hold axes
  hold(ax, 'on');

  % Plot continuation solution
  plot(ax, x_plot(:, 1), x_plot(:, 2), LineStyle='-', Color=colours(3, :), ...
       LineWidth=4.0, DisplayName='$\Gamma$');

  % Plot equilibrium points
  plot(ax, x_ss(1), x_ss(2), LineStyle='none', Marker='*', MarkerSize=10, ...
       MarkerFaceColor='k', MarkerEdgeColor='k', ...
       DisplayName='$x^{*}$');

  legend(ax, Interpreter='latex');

  hold(ax, 'off');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax.XAxis.TickValues = -0.8 : 0.2 : 1.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -0.7 : 0.2 : 1.0;

  % Y-Axis
  ax.YAxis.TickValues = -0.2 : 0.2 : 1.6;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -0.1 : 0.2 : 1.6;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax.XAxis.Limits = [-0.8, 1.0];
  ax.YAxis.Limits = [-0.2, 1.6];

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
    figname = './images/initial_periodic_orbit_test.pdf';
    exportgraphics(fig, figname, ContentType='vector');
  end

end