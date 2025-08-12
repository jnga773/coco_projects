function plot_homoclinic_manifolds(run_approx_homoclinic_in, p0_in)
  %------------------------%
  %     Calculate Data     %
  %------------------------%
  % Vector field grid
  N     = 20;
  x     = linspace(-0.1, 1.1, 2*N);
  y     = linspace(-0.1, 1.1, N);
  [X, Y] = meshgrid(x,y);

  % Calculate vector field
  fxy   = fish([X(:) Y(:)]', repmat(p0_in, [1, numel(X)]));
  fx    = reshape(fxy(1, :), size(X));
  fy    = reshape(fxy(2, :), size(X));
  
  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(13); fig.Name = 'Homoclinic Manifolds (2D)'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 12, 8]; fig.PaperSize = [12, 8];
  ax = gca();
  % ax.FontSize = 14.0;

  % Hold axes
  hold(ax, 'on');

  % Plot vector flow map
  quiver(ax, X, Y, fx, fy, 1, LineStyle='-', LineWidth=1, ...
         Color=[0.3, 0.3, 0.3], ShowArrowHead='on', MaxHeadSize=0.2);

  % Plot base solution
  plot_homoclinic_hyperplane_base(ax, run_approx_homoclinic_in, p0_in);

  % Legend
  legend(ax, 'Interpreter', 'latex')

  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}(t)$'];
  ax.YAxis.Label.String = ['$x_{2}(t)$'];

  % Axis title
  ax.Title.String = ['Homoclinic Manifolds'];

  % Tick params
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;

end