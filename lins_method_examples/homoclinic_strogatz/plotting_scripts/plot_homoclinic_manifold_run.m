function plot_homoclinic_manifold_run(run_in, label_in, fig_num_in)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of current run
  [sol1, ~] = coll_read_solution('unstable', run_in, label_in);
  [sol2, ~] = coll_read_solution('stable', run_in, label_in);

  p0_in = sol1.p;

  % x-solution
  x_sol1 = sol1.xbp;
  x_sol2 = sol2.xbp;  

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(fig_num_in); fig.Name = 'Homoclinic Manifolds (2D)'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 8, 6]; fig.PaperSize = [8, 6];
  ax = gca();
  % ax.FontSize = 14.0;

  % Hold axes
  hold(ax, 'on');

  % Plot COCO solution
  % coco_plot_sol(run_in, label_in, 'yamada', 1:2, 'x', 'x', 'x');
  plot(ax, x_sol1(:, 1), x_sol1(:, 2), LineStyle='-', ...
       Marker='.', MarkerSize=15, DisplayName='Unstable Manifold');
  plot(ax, x_sol2(:, 1), x_sol2(:, 2), LineStyle='-', ...
       Marker='.', MarkerSize=15, DisplayName='Stable Manifold');

  % Plot base solution
  plot_homoclinic_hyperplane_base(ax, p0_in);

  % Legend
  legend(ax, 'Interpreter', 'latex')

  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}(t)$'];
  ax.YAxis.Label.String = ['$x_{2}(t)$'];

  % Axis limits
  ax.XAxis.Limits = [-0.1, 2.1];
  ax.YAxis.Limits = [-0.8, 0.8];

  % Axis title
  title_str = sprintf('COCO Solution (run: $\\verb!%s!$, label: %d)', run_in, label_in);
  ax.Title.String = title_str;

  % Tick params
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;

end