function plot_hopf_to_PO_solution(run_in, label_in)
  % Plot the solution g
  
  %---------------------------------%
  %     Read Data: Stable Orbit     %
  %---------------------------------%
  % Read da solution g
  sol_s = po_read_solution('', run_in, label_in);
  xbp_s = sol_s.xbp;

  %--------------------------------------%
  %     Read Data: Equilibrium Ponts     %
  %--------------------------------------%
  % Read da equilibrium points g
  sol_0 = ep_read_solution('x0', run_in, label_in);
  sol_pos = ep_read_solution('xpos', run_in, label_in);
  sol_neg = ep_read_solution('xneg', run_in, label_in);
  
  x0   = sol_0.x;
  xpos = sol_pos.x;
  xneg = sol_neg.x;

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

  % Plot stable periodic orbit
  plot3(ax, xbp_s(:, 1), xbp_s(:, 2), xbp_s(:, 3), LineStyle='-', Color=colours(3, :), ...
        DisplayName='Stable Orbit')

  % Plot equilibrium points
  plot3(ax, xpos(1), xpos(2), xpos(3), LineStyle='none', Marker='*', MarkerFaceColor='b', ...
        MarkerEdgeColor='b', DisplayName='$q$');
  plot3(ax, xneg(1), xneg(2), xneg(3), LineStyle='none', Marker='*', MarkerFaceColor='r', ...
        MarkerEdgeColor='r', DisplayName='$p$');
  plot3(ax, x0(1), x0(2), x0(3), LineStyle='none', Marker='o', MarkerFaceColor='g', ...
        MarkerEdgeColor='g', DisplayName='$o$');

  legend(ax, Interpreter='latex');

  hold(ax, 'off');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax.XAxis.TickDirection = 'in';
  % ax.XAxis.TickValues = -1.0:0.5:1.0;
  % ax.XAxis.MinorTick = 'on';
  % ax.XAxis.MinorTickValues = -0.75:0.5:0.75;

  % Y-Axis
  ax.YAxis.TickDirection = 'in';
  % ax.YAxis.TickValues = -1.0:0.5:1.0;
  % ax.YAxis.MinorTick = 'on';
  % ax.YAxis.MinorTickValues = -0.75:0.5:0.75;

  % Z-Axis
  ax.ZAxis.TickDirection = 'in';

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  % ax.XAxis.Limits = [-1.05, 1.05];
  % ax.YAxis.Limits = [-1.05, 1.05];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$G(t)$';
  ax.YAxis.Label.String = '$Q(t)$';
  ax.ZAxis.Label.String = '$I(t)$';

  %--------------------%
  %     Axis Title     %
  %--------------------%
  ax.Title.String = 'Initial Periodic Orbit';

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  box(ax, 'on');
  grid(ax, 'on');

  % 3D plot view
  view(45, 15.0);

end