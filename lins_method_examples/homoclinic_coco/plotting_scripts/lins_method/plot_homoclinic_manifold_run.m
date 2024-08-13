function plot_homoclinic_manifold_run(run_in, label_in, xbp_old_in, fig_num_in, save_figure)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of current run
  [sol1, ~] = coll_read_solution('unstable', run_in, label_in);
  [sol2, ~] = coll_read_solution('stable', run_in, label_in);
  [solx, ~] = ep_read_solution('x0', run_in, label_in);

  % x-solution
  x_sol1 = sol1.xbp;
  x_sol2 = sol2.xbp;

  % Equilibrium point
  x0 = solx.x;
  p0_in = solx.p;

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(fig_num_in); fig.Name = 'Homoclinic Manifolds (3D)'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 12, 8]; fig.PaperSize = [12, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;
  ax.FontSize = 14.0;

  % Hold axes
  hold(ax, 'on');

  % Plot COCO solution
  % coco_plot_sol(run_in, label_in, 'yamada', 1:2, 'x', 'x', 'x');

  plot3(ax, x_sol1(:, 1), x_sol1(:, 2), x_sol1(:, 3), LineStyle='-', ...
        Marker='.', MarkerSize=15, DisplayName='Unstable Manifold');
  plot3(ax, x_sol2(:, 1), x_sol2(:, 2), x_sol2(:, 3), LineStyle='-', ...
        Marker='.', MarkerSize=15, DisplayName='Stable Manifold');

  % plot3(ax, x_sol1(:, 1), x_sol1(:, 2), x_sol1(:, 3), '->', ...
  %       DisplayName='Unstable Manifold');
  % plot3(ax, x_sol2(:, 1), x_sol2(:, 2), x_sol2(:, 3), '->', ...
  %       DisplayName='Stable Manifold');

  % Plot base solution
  plot_homoclinic_hyperplane_base(ax, x0, p0_in, xbp_old_in)

  % Legend
  legend(ax, 'Interpreter', 'latex')

  hold(ax, 'off');

  % Axis limits
  ax.XAxis.Limits = [-0.4, 0.3];
  ax.YAxis.Limits = [-0.6, 0.25];
  ax.ZAxis.Limits = [-0.2, 0.75];

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}(t)$'];
  ax.YAxis.Label.String = ['$x_{2}(t)$'];
  ax.ZAxis.Label.String = ['$x_{3}(t)$'];

  % Axis title
  title_str = sprintf('COCO Solution (run: $\\verb!%s!$, label: %d)', run_in, label_in);
  ax.Title.String = title_str;

  % Tick params
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';
  ax.ZAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;
  view(45, 15.0);

  if save_figure == true
    % Filename
    figname = sprintf('homoclinic_trajectory_%s', run_in(1:5));
    % exportgraphics(fig, ['./images/', figname, '.png'], Resolution=800);
    exportgraphics(fig, ['./images/', figname, '.pdf'], ContentType='vector');
  end



end