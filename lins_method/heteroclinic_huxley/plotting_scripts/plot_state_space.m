function plot_state_space(p0_in)
  % Vector field
  N     = 20;
  x     = linspace(-0.1,1.1,2*N);
  y     = linspace(-0.25,0.25,N);
  [X, Y] = meshgrid(x,y);
  fxy   = huxley([X(:) Y(:)]', repmat([0.5;0], [1 numel(X)]));
  fx    = reshape(fxy(1,:), size(X));
  fy    = reshape(fxy(2,:), size(X));

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
  plot_base_diagram(ax, p0_in, var_args{:});

  % Plot central periodic orbit
  plot(ax, 0.5, 0, LineStyle='-', LineWidth=sqrt(2), Color='black', ...
      Marker='o', MarkerSize=8, MarkerFaceColor='white');

  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}$'];
  ax.YAxis.Label.String = ['$x_{2}$'];

  % Axis limits
  ax.XAxis.Limits = [-0.1, 1.1];
  ax.YAxis.Limits = [-0.2, 0.2];

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