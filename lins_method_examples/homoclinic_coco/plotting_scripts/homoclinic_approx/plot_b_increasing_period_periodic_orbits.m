function plot_b_increasing_period_periodic_orbits(run_in, label_in)
  %--------------------------------------------%
  %     Plot: Panel (b) Increasing Periods     %
  %--------------------------------------------%
  fig = figure(2); clf;
  fig.Name = '(b) Increasing Periods';
  ax = gca();

  hold(ax, 'on');
  % Plot COCO solutions 1-8
  coco_plot_sol(run_in, 1:label_in, '', 'x', 2, 'x', 3)
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{2}$'];
  ax.YAxis.Label.String = ['$x_{3}$'];

  % Axis title
  ax.Title.String = ['(b) Increasing Period Periodic Orbit'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;
end