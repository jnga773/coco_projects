function plot_theta_bifurcations(run_in, SP_labels_in)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Bifurcation data
  bd = coco_bd_read(run_in);

  % theta_old data
  theta_old = coco_bd_col(bd, 'theta_old');
  % theta_new data
  theta_new = coco_bd_col(bd, 'theta_new');

  % Special points for other plots
  SP_point1 = [coco_bd_val(bd, SP_labels_in(1), 'theta_old');
               coco_bd_val(bd, SP_labels_in(1), 'theta_new')];
  SP_point2 = [coco_bd_val(bd, SP_labels_in(2), 'theta_old');
               coco_bd_val(bd, SP_labels_in(2), 'theta_new')];

  %--------------%
  %     Plot     %
  %--------------%
   % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(4); clf;
  fig.Name = 'Theta Bifurcations';
  fig.Units = 'inches'; fig.Position = [0, 0, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  hold(ax, 'on');

  % Plot phase resetting curve
  plot(ax, theta_old, theta_new);

  % Plot special points
  plot(ax, SP_point1(1), SP_point1(2), LineStyle='none', Marker='o', MarkerSize=10, ...
       MarkerFaceColor=colours(2, :), MarkerEdgeColor=colours(2, :));

  plot(ax, SP_point2(1), SP_point2(2), LineStyle='none', Marker='o', MarkerSize=10, ...
       MarkerFaceColor=colours(2, :), MarkerEdgeColor=colours(2, :));

  hold(ax, 'off');

  % Axis labels
  ax.XAxis.Label.String = '$\theta_{\mathrm{old}}$';
  ax.YAxis.Label.String = '$\theta_{\mathrm{new}}$';

  % Title
  ax.Title.String = 'Phase Transition Curve (PTC)';

  % Axis limits
  ax.XAxis.Limits = [0.0, 1.0];
  ax.YAxis.Limits = [-0.25, 1.0];

  % Axis stuff
  box(ax, 'on');
  grid(ax, 'on');
  
end
