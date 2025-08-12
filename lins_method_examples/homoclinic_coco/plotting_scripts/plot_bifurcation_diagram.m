 function plot_bifurcation_diagram(run_names_in)
  % PLOT_BIFURCATION_DIAGRAM: Plots the bifurcation data from all the runs

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read COCO data matrices
  % bd_hopf        = coco_bd_read(run_names_in.hopf_bifurcations);
  % bd_saddle      = coco_bd_read(run_names_in.saddle_nodes);
  bd_homo_approx = coco_bd_read(run_names_in.continue_approx_homoclinics);
  bd_homo        = coco_bd_read(run_names_in.lins_method.continue_homoclinics);

  % % Hopf bifurcation line (H)
  % p1_hopf        = coco_bd_col(bd_hopf, 'p1');
  % p2_hopf        = coco_bd_col(bd_hopf, 'p2');
  % % Saddle-Node bifurcation line (A_S)
  % p1_saddle      = coco_bd_col(bd_saddle, 'p1');
  % p2_saddle      = coco_bd_col(bd_saddle, 'p2');
  % Approximate homoclinic line
  p1_homo_approx = coco_bd_col(bd_homo_approx, 'p1');
  p2_homo_approx = coco_bd_col(bd_homo_approx, 'p2');
  % Lin's method homoclinic line
  p1_homo        = coco_bd_col(bd_homo, 'p1');
  p2_homo        = coco_bd_col(bd_homo, 'p2');

  %-------------------%
  %     Plot Data     %
  %-------------------%
  fig = figure(1); fig.Name = 'Bifurcation Diagram'; clf;
  fig.Units = 'inches'; fig.Position = [2, 2, 12, 8]; fig.PaperSize = [12, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;
  
  hold(ax, 'on');

  % Plot regular method
  % % Hopf Line
  % plot(ax, p1_hopf, p2_hopf, LineStyle="-", DisplayName='Hopf');
  % % Saddle Node
  % plot(ax, p1_saddle, p2_saddle, LineStyle='-', DisplayName='Saddle-Node');
  % Approximate Homoclinic Line
  plot(ax, p1_homo_approx, p2_homo_approx, LineStyle='-', DisplayName='Homoclinic (Approximate)');
  % Lin's method homoclinic line
  plot(ax, p1_homo, p2_homo, LineStyle='--', DisplayName='Homoclinic');

  legend(ax, Location='northwest', Interpreter='latex');

  hold(ax, 'off');

  % Axis Ticks
  % ax.XAxis.TickValues = 5.0:1.0:12.0;
  % ax.XAxis.MinorTick = 'on';
  % ax.XAxis.MinorTickValues = 5.0:0.2:12.0;
  % 
  % ax.YAxis.TickValues = 0.0:0.05:0.30;
  % ax.YAxis.MinorTick = 'on';
  % ax.YAxis.MinorTickValues = 0.00:0.01:0.30;

  % Axis Labels
  ax.XAxis.Label.String = ['$p_{1}$'];
  ax.YAxis.Label.String = ['$p_{2}$'];

  % Axis title
  title_str = sprintf('Homoclinic Demo');
  ax.Title.String = title_str;

  % Axis limits
  ax.XAxis.Limits = [-0.06, 0.01];
  ax.YAxis.Limits = [0.0, 25];

  % Tick params
  ax.XAxis.TickDirection = 'in'; ax.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');
  % ax.GridLineWidth = 0.5;
  ax.GridColor = 'black';
  ax.GridAlpha = 0.25;
  
end