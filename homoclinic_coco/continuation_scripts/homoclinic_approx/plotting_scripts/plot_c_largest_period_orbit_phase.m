function plot_c_largest_period_orbit_phase(run_in, label_in, save_figure)
  %------------------------------------------------------%
  %     Plot: Panel (c) Largest Period Orbit (Phase)     %
  %------------------------------------------------------%
  fig = figure(3); clf;
  fig.Name = '(c) Largest Period Orbit (Phase)';
  ax = gca();

  hold(ax, 'on');
  % Plot COCO solution: 8
  coco_plot_sol(run_in, label_in, '', 'x', 2, 'x', 3)
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{2}$'];
  ax.YAxis.Label.String = ['$x_{3}$'];

  % Axis title
  ax.Title.String = ['(c) Largest Period Orbit (Phase)'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;

  if save_figure == true
    exportgraphics(fig, './images/(c) Largest Period Orbit (Phase).png', Resolution=800);
  end
end