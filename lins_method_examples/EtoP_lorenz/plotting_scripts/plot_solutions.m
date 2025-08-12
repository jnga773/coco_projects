function plot_solutions(run_in, label_in, data_in, fig_num_in)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of unstable manifold
  sol_u = coll_read_solution('unstable', run_in, label_in);
  % Read solution of stable manifold
  sol_s = coll_read_solution('stable', run_in, label_in);
  % Read solution of periodic
  sol_p = po_read_solution('hopf_po', run_in, label_in);

  % x-solution
  x_u = sol_u.xbp;
  x_s = sol_s.xbp;
  x_p = sol_p.xbp;

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

  plot3(ax, x_u(:, 1), x_u(:, 2), x_u(:, 3), LineStyle='-', ...
        Marker='.', MarkerSize=15, DisplayName='Unstable Manifold');
  plot3(ax, x_s(:, 1), x_s(:, 2), x_s(:, 3), LineStyle='-', ...
        Marker='.', MarkerSize=15, DisplayName='Stable Manifold');
  plot3(ax, x_p(:, 1), x_p(:, 2), x_p(:, 3), LineStyle='-', ...
        DisplayName='Periodic Orbit');

  % Plot base solution
  plot_solutions_base(ax, data_in)

  % Legend
  legend(ax, 'Interpreter', 'latex')

  hold(ax, 'off');

  % Axis limits
  ax.XAxis.Limits = [-20, 40];
  ax.YAxis.Limits = [-20, 30];
  ax.ZAxis.Limits = [-10, 50];

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

end