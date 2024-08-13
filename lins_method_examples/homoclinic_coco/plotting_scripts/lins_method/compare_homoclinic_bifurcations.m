function compare_homoclinic_bifurcations(run_names_in, save_figure)
  % Run names
  run_approx = run_names_in.continue_approx_homoclinics;
  run_lins   = run_names_in.lins_method.continue_homoclinics;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read COCO data matrices
  bd_approx = coco_bd_read(run_approx);
  bd_lins   = coco_bd_read(run_lins);
  % Approximate homoclinic data
  p1_approx     = coco_bd_col(bd_approx, 'p1');
  p2_approx = coco_bd_col(bd_approx, 'p2');

  % Lin's method data
  p1_lins       = coco_bd_col(bd_lins, 'p1');
  p2_lins   = coco_bd_col(bd_lins, 'p2');

  %---------------------------%
  %     Plot: Big Picture     %
  %---------------------------%
  fig = figure(1); fig.Name = 'Yamada-Bifurcations'; clf;
  fig.Units = 'inches'; fig.Position = [3, 3, 12, 8]; fig.PaperSize = [12, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  % Fontsize
  ax.FontSize = 14;

  % Turn on axis hold
  hold(ax, 'on');

  % Plot approximate homoclinic from run8
  plot(ax, p1_approx, p2_approx, LineStyle='-', DisplayName='Homoclinic (Approximate)');
  plot(ax, p1_lins, p2_lins, LineStyle='--', DisplayName="Homoclinc (Lin's)");

  % Legend
  legend(ax, 'Interpreter', 'latex');

  % Turn off axis hold
  hold(ax, 'off');

  % Axis Ticks
  % ax.XAxis.TickValues = 6.0:0.1:6.9;
  % ax.XAxis.MinorTick = 'on';
  % ax.XAxis.MinorTickValues = 6.05:0.1:6.85;
  % 
  % ax.YAxis.TickValues = 0.0:0.05:0.30;
  % ax.YAxis.MinorTick = 'on';
  % ax.YAxis.MinorTickValues = 0.00:0.01:0.30;

  % Axis Labels
  ax.XAxis.Label.String = '$p_{1}$';
  ax.YAxis.Label.String = '$p_{2}$';

  % Axis title
  title_str = sprintf('Comparing Homoclinic Methods');
  ax.Title.String = title_str;

  % Axis limits
  % ax.XAxis.Limits = [6.0, 6.9];
  % ax.YAxis.Limits = [0.0, 0.25];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  % ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;

  % Save figure
  if save_figure == true
    % exportgraphics(fig, './images/Region_II_bifurcations.png', Resolution=800);
    exportgraphics(fig, './images/compared_approx_and_lins.pdf', ContentType='vector');
  end
end