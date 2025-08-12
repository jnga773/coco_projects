function plot_run_i(run_in, label_in, fig_num_in)
  % PLOT_RUN_I: Plots the solution calculating in run [run_in] for label
  % [label_in].

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of current run
  % Read solution of current run
  [sol1, ~] = coll_read_solution('unstable', run_in, label_in);
  [sol2, ~] = coll_read_solution('stable', run_in, label_in);

  % Parameters
  p0_in = sol1.p;

  % x-solution
  x_sol1 = sol1.xbp;
  x_sol2 = sol2.xbp;

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(fig_num_in); clf
  % fig.Name = fprintf('COCO Solution (run: %s)', runs_in{i_in}); clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 8, 6]; fig.PaperSize = [8, 6];
  ax = gca();

  % Hold axis
  hold(ax, 'on');

  % Plot COCO solutions
  plot(ax, x_sol1(:, 1), x_sol1(:, 2), LineStyle='-', ...
       Marker='.', MarkerSize=15, DisplayName='Unstable Manifold');
  plot(ax, x_sol2(:, 1), x_sol2(:, 2), LineStyle='-', ...
      Marker='.', MarkerSize=15, DisplayName='Stable Manifold');

  % Plot base solutions
  var_args = {'LineStyle', '-', 'LineWidth', 2, 'Color', [0.7, 0.7, 0.7]};
  plot_base_diagram(ax, p0_in, var_args{:});

  % Plot central periodic orbit
  plot(ax, 0.5, 0, LineStyle='-', LineWidth=sqrt(2), Color=[0.5, 0.5, 0.5], ...
      Marker='o', MarkerSize=8, MarkerFaceColor='white');

  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}$'];
  ax.YAxis.Label.String = ['$x_{2}$'];

  % Axis limits
  ax.XAxis.Limits = [-0.1, 1.1];
  ax.YAxis.Limits = [-0.2, 0.2];

  % Axis title
  title_str = sprintf('COCO Solution (run: $\\verb!%s!$, label: %d)', run_in, label_in);
  ax.Title.String = title_str;

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');

end