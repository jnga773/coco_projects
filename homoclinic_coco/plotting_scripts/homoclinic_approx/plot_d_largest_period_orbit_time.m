function plot_d_largest_period_orbit_time(run_in, label_in, save_figure)

  %-----------------------------------------------------%
  %     Plot: Panel (d) Largest Period Orbit (Time)     %
  %-----------------------------------------------------%
  % Read data
  sol = po_read_solution(run_in, label_in);

  % Evaluate vector field at basepoints
  f = marsden(sol.xbp', repmat(sol.p, [1 size(sol.xbp, 1)]));

  % Extract the discretisation points corresponding to the minimum value of
  % the norm of the vector field along the longest-period periodic orbit.
  % Find basepoint closest to equilibrium
  [f_minima, idx] = min(sqrt(sum(f.*f, 1)));

  % Time and x solutions
  tbp = sol.tbp;
  xbp = sol.xbp;

  % tbp = [tbp(idx:end) - tbp(idx);
  %        tbp(1:idx) + (sol.T - tbp(idx))];
  % xbp = xbp([idx:end, 1:idx], :);

  % Plot
  fig = figure(4); clf;
  fig.Name = '(d) Largest Period Orbit (Time)';
  ax = gca();

  hold(ax, 'on');
  % plot(ax, tbp, xbp, LineStyle='-', LineWidth=2, Color='black', ...
  %      Marker='.', MarkerSize=12)
  plot(ax, tbp, xbp(:, 1), LineStyle='-', DisplayName='$x_{1}$')
  plot(ax, tbp, xbp(:, 2), LineStyle='--', DisplayName='$x_{2}$')
  plot(ax, tbp, xbp(:, 3), LineStyle='-.', DisplayName='$x_{3}$')

  % Plot vertical line for t(idx), where f(:, idx) is the point of minumum
  % value of the norm.
  xline(tbp(idx), LineStyle=':', Color='Black', LineWidth=1.5, ...
        DisplayName=sprintf('idx = %d', idx))

  % Legend
  legend(ax, Interpreter='latex', Location='northwest')

  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$t$'];
  ax.YAxis.Label.String = ['$x_{3}(t)$'];

  % Axis title
  ax.Title.String = ['(d) Largest Period Orbit (Time)'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;

  if save_figure == true
    exportgraphics(fig, './images/(d) Largest Period Orbit (Time).png', Resolution=800);
  end
end