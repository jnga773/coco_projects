function plot_bifurcation_diagram(run_in)
  % plot_bifurcation_diagram(run_in)
  %
  % Plots the bifurcation data from run_in.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read COCO data matrices
  bd_read = coco_bd_read(run_in);

  % Read parameters s and r
  s_data = coco_bd_col(bd_read, 's');
  r_data = coco_bd_col(bd_read,'r');

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(7);
  fig.Name = 'Bifurcation Diagram';
  clf;
  fig.Units = 'inches';
  fig.Position = [3, 3, 12, 8];
  fig.PaperSize = [12, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  % Fontsize
  ax.FontSize = 14;

  % Turn on axis hold
  hold(ax, 'on');

  % Plot data
  plot(ax, s_data, r_data, LineStyle='-', DisplayName='Heteroclinic');

  % Legend
  legend(ax, 'Interpreter', 'latex');

  % Turn off axis hold
  hold(ax, 'off');

  % Axis Labels
  ax.XAxis.Label.String = '$s$';
  ax.YAxis.Label.String = '$r$';

  % Axis title
  title_str = sprintf('Lorenz Model with $\\left( b = 10 \\right)$');
  ax.Title.String = title_str;

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  % ax.GridLineWidth = 0.5;
  % ax.GridColor = 'black';
  % ax.GridAlpha = 0.25;


end