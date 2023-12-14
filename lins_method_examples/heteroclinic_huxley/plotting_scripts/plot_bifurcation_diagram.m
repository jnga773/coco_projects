function plot_bifurcation_diagram(run_in, save_figure)
  % PLOT_BIFURCATION_DIAGRAM: Plots the two-parameter continuation bifurcation
  % diagram with data from run "run_in".
  %-------------------%
  %     Read Data     %
  %-------------------%
  % COCO data matrix for heteroclinic parametrisation run
  bd_read = coco_bd_read(run_in);

  % Read data
  p1_plot = coco_bd_col(bd_read, 'p1');
  p2_plot = coco_bd_col(bd_read, 'p2');

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(8); fig.Name = 'Bifurcation Diagram'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 8, 6]; fig.PaperSize = [8, 6];
  ax = gca();

  % Hold axes
  hold(ax, 'on');

  % Plot exact solution
  plot(ax, p1_plot, (1 - 2 * p1_plot) / sqrt(2), LineStyle='-', LineWidth=2, DisplayName='Exact Solution');

  % Plot COCO bifurcation data
  plot(ax, p1_plot, p2_plot, LineStyle='--', LineWidth=1, DisplayName='COCO Solution');

  hold(ax, 'off');

  % Legend
  legend(ax, 'Interpreter', 'latex');

  % Axis Labels
  ax.XAxis.Label.String = ['$p_{1}$'];
  ax.YAxis.Label.String = ['$p_{2}$'];

  % Axis limits
  % ax.XAxis.Limits = [-0.1, 1.1];
  % ax.YAxis.Limits = [-0.2, 0.2];

  % Axis title
  ax.Title.String = ['Bifurcation Diagram'];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;

  % Save figure
  if save_figure == true
    % exportgraphics(fig, './images/bifurcation_diagram.png', Resolution=800);
    exportgraphics(fig, './images/bifurcation_diagram.pdf', ContentType='vector');
  end
end