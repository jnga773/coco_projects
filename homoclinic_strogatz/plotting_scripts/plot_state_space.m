function plot_state_space(p0_in)
  %--------------------------------%
  %     Calculate Vector Field     %
  %--------------------------------%
  % Vector field meshgrid
  N     = 20;
  x     = linspace(-2.1, 2.1, N);
  y     = linspace(-2.1, 2.1, N);
  [X, Y] = meshgrid(x,y);

  % Calculate vector field
  fxy   = func([X(:), Y(:)]', repmat(p0_in, [1. numel(X)]));
  fx    = reshape(fxy(1, :), size(X));
  fy    = reshape(fxy(2, :), size(X));

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(1); fig.Name = 'Vector Flow Diagram'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 8, 6]; fig.PaperSize = [8, 6];
  ax = gca();

  % Hold axis
  hold(ax, 'on');

  % Vector flow map
  quiver(ax, X, Y, fx, fy, 1, LineStyle='-', LineWidth=1, ...
      Color=[0.3, 0.3, 0.3], ShowArrowHead='on', MaxHeadSize=0.2);

  % Plot base solutions
  var_args = {'LineStyle', '-', 'LineWidth', 2, 'Color', 'black'};
  % plot_base_diagram(ax, p0_in, var_args{:});

  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}$'];
  ax.YAxis.Label.String = ['$x_{2}$'];

  % Axis limits
  ax.XAxis.Limits = [-2.1, 2.1];
  ax.YAxis.Limits = [-2.1, 2.1];

  % Axis title
  ax.Title.String = ['Vector Flow Diagram'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  % grid(ax, 'on');
  % ax.GridLineWidth = 0.5;
  % ax.GridColor = 'black';
  % ax.GridAlpha = 0.25;
end