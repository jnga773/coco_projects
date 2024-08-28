function plot_orbit_and_Wq_solution(run_in, label_in)
  % plot_orbit_and_Wq_solution(run_in, label_in)
  %
  % Plots the trajectory segment of the stable manifold of q

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Stable periodic orbit
  [sol_s, ~] = coll_read_solution('PO_stable', run_in, label_in);
  xbp_PO_s = sol_s.xbp;

  % Equilibrium points
  sol_0 = ep_read_solution('x0', run_in, label_in);
  x_0   = sol_0.x;
  sol_pos = ep_read_solution('xpos', run_in, label_in);
  x_pos = sol_pos.x;
  sol_neg = ep_read_solution('xneg', run_in, label_in);
  x_neg = sol_neg.x;

  % Read solution of current run
  [sol1, ~] = coll_read_solution('W1', run_in, label_in);
  [sol2, ~] = coll_read_solution('W2', run_in, label_in);

  % x-solution
  x1 = sol1.xbp;
  x2 = sol2.xbp;


  %-------------------%
  %     Plot Data     %
  %-------------------%
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
  plot3(ax, xbp_PO_s(:, 1), xbp_PO_s(:, 2), xbp_PO_s(:, 3), ...
        LineStyle='-', Color=colours(3, :), ...
        DisplayName='$\Gamma$');

  % Plot equilibrium points: x_{+}
  plot3(ax, x_pos(1), x_pos(2), x_pos(3), ...
        LineStyle='none', ...
        Marker='*', MarkerFaceColor='b', MarkerSize=10,  ...
        MarkerEdgeColor='b', DisplayName='$q$');

  % Plot equilibrium points: x_{-}
  plot3(ax, x_neg(1), x_neg(2), x_neg(3), ...
        LineStyle='none', ...
        Marker='*', MarkerFaceColor='r', MarkerSize=10,  ...
        MarkerEdgeColor='r', DisplayName='$p$');

  % Plot equilibrium points: x_{0}
  plot3(ax, x_0(1), x_0(2), x_0(3), ...
        LineStyle='none', ...
        Marker='o', MarkerFaceColor='r', MarkerSize=10, ...
        MarkerEdgeColor='r', DisplayName='$o$');

  % Plot W1
  plot3(ax, x1(:, 1), x1(:, 2), x1(:, 3), Color=colours(1, :), ...
        DisplayName='$W^{s}(q)$');

  % Plot W2
  plot3(ax, x2(:, 1), x2(:, 2), x2(:, 3), Color=colours(1, :), ...
        HandleVisibility='off');

  legend(ax, Interpreter='latex');

  hold(ax, 'off');

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax.XAxis.Limits = [0.0, 10.0];
  ax.YAxis.Limits = [0.0, 8.0];
  ax.ZAxis.Limits = [0.0, ceil(max(xbp_PO_s(:, 3)))];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$G(t)$';
  ax.YAxis.Label.String = '$Q(t)$';
  ax.ZAxis.Label.String = '$I(t)$';

  %--------------------%
  %     Axis Title     %
  %--------------------%
  % ax.Title.String = 'Initial Periodic Orbit';

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  box(ax, 'on');
  grid(ax, 'on');

  % 3D plot view
  view(45, 15.0);


end