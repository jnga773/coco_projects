function plot_f_new_solution(run_new, run_old, label_old)
  %--------------------------------------%
  %     Plot: Panel (f) New Solution     %
  %--------------------------------------%
  fig = figure(6); clf;
  fig.Name = '(f) New Solution';
  ax = gca();

  hold(ax, 'on');
  % Plot COCO solution: 8
  coco_plot_sol(run_old, label_old, '', 'x', 2, 'x', 3)
  coco_plot_sol(run_new, 1, '', 'x', 2, 'x', 3)
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{2}$'];
  ax.YAxis.Label.String = ['$x_{3}$'];

  % Axis title
  ax.Title.String = ['(f) New Solution'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;
end