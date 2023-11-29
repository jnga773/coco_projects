function plot_h_family_periodic_orbits(run_in, save_figure)
  %---------------------------------------------------%
  %     Plot: Panel (h) Family of Periodic Orbits     %
  %---------------------------------------------------%
  fig = figure(8); clf;
  fig.Name = '(h) Family of Periodic Orbits';
  ax = gca();

  hold(ax, 'on');
  % Plot COCO solution
  coco_plot_sol(run_in, [1 4 6 9 12], '', 'x', 2, 'x', 3)
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{2}$'];
  ax.YAxis.Label.String = ['$x_{3}$'];

  % Axis title
  ax.Title.String = ['(h) Family of Periodic Orbits'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;

  if save_figure == true
    exportgraphics(fig, './images/(h) Family of Periodic Orbits.png', Resolution=800);
  end
end