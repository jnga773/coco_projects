function plot_e_extended_time_profile(run_in, label_in, save_figure)
  %-----------------------------------------------%
  %     Plot: Panel (e) Extended Time Profile     %
  %-----------------------------------------------%
  % Read data
  sol1 = po_read_solution(run_in, label_in);

  % Evaluate vector field at basepoints
  f = marsden(sol1.xbp', repmat(sol1.p, [1 size(sol1.xbp, 1)]));

  % Find basepoint closest to equilibrium
  [~, idx] = min(sqrt(sum(f.*f, 1))); 

  % Reconstruct some time bidniz
  tbp = [sol1.tbp(idx:end) - sol1.tbp(idx); ...
        sol1.tbp(1:idx) + (sol1.T - sol1.tbp(idx))];

  xbp = sol1.xbp([idx:end, 1:idx], 3);

  % Plot
  fig = figure(5); clf;
  fig.Name = '(e) Extended Time Profile';
  ax = gca();

  hold(ax, 'on');
  % plot(tbp, xbp, 'LineStyle', '-', 'LineWidth', 2, ...
  %      'Color', 'black', 'Marker', '.', 'MarkerSize', 12)
  plot(ax, tbp, xbp, LineStyle='-', LineWidth=2, Color='black', ...
      Marker='.', MarkerSize=12)
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$t$'];
  ax.YAxis.Label.String = ['$x_{3}(t)$'];

  % Axis title
  ax.Title.String = ['(e) Extended Time Profile'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;

  if save_figure == true
    exportgraphics(fig, './images/(e) Extended Time Profile.png', Resolution=800);
  end
end