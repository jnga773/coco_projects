function plot_a_initial_periodic_orbit(run_in)
  % PLOT_A_INITIAL_PERIODIC_ORBIT: Plots the initial periodic orbit from
  % solution [run_in].

  %------------------------------------------------%
  %     Plot: Panel (a) Initial Periodic Orbit     %
  %------------------------------------------------%
  fig = figure(1); clf;
  fig.Name = '(a) Initial Periodic Orbit';
  ax = gca();

  % Turn on axis hold
  hold(ax, 'on');

  % Calculate theoretical results
  t0 = (0:2*pi/100:2*pi)';
  x0 = 0.001 * (cos(t0) * [1, 0, -1] - sin(t0) * [0, 1, 0,]) / sqrt(2);

  % Plot theoretical results
  plot(x0(:, 2), x0(:, 3), 'ro')

  % Plot COCO solution
  coco_plot_sol(run_in, 1, '', 'x', 2, 'x', 3)

  % Turn off axis hold
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = '$x_{2}$';
  ax.YAxis.Label.String = '$x_{3}$';

  % Axis title
  ax.Title.String = '(a) Initial Periodic Orbit';

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;
end
