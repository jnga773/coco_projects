function plot_phase_transition_curve(run_in)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Bifurcation data
  bd = coco_bd_read(run_in);

  % theta_old data
  theta_old = coco_bd_col(bd, 'theta_old');
  % theta_new data
  theta_new = coco_bd_col(bd, 'theta_new');

  % Get any theta_new values < 0
  idx_neg = (theta_new < 0);
  % Get any theta_new values >= 0 and <= 1
  idx_mid = (theta_new >= 0 & theta_new <= 1);
  % Get any theta_new values > 1
  idx_big = (theta_new > 1);

  % Read A_perturb value
  A_perturb = coco_bd_val(bd, 1, 'A_perturb');
  % Read theta_perturb and phi_perturb
  theta_perturb = coco_bd_val(bd, 1, 'theta_perturb');

  % Directional vector
  d_vec = [cos(theta_perturb);
           sin(theta_perturb)];

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
  plot(ax, theta_old(idx_mid), theta_new(idx_mid), LineStyle='-', Color=colours(1, :));
  plot(ax, theta_old(idx_neg), theta_new(idx_neg)+1, LineStyle='-', Color=colours(1, :));
  plot(ax, theta_old(idx_big), theta_new(idx_big)-1, LineStyle='-', Color=colours(1, :));


  plot(ax, theta_old(idx_neg), theta_new(idx_neg), LineStyle='--', Color=colours(1, :));
  plot(ax, theta_old(idx_big), theta_new(idx_big), LineStyle='--', Color=colours(1, :));

  % Plot diagonal line
  plot(ax, [0, 1], [0, 1], LineStyle='--', Color=[0, 0, 0, 0.75]);

%   % Plot special points
%   plot(ax, SP_point1(1), SP_point1(2), LineStyle='none', Marker='o', MarkerSize=10, ...
%        MarkerFaceColor=colours(2, :), MarkerEdgeColor=colours(2, :));

%   plot(ax, SP_point2(1), SP_point2(2), LineStyle='none', Marker='o', MarkerSize=10, ...
%        MarkerFaceColor=colours(2, :), MarkerEdgeColor=colours(2, :));

  hold(ax, 'off');

  % Axis Ticks
  ax.XAxis.TickValues = 0.0 : 0.1 : 1.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = 0.05 : 0.1 : 1.0;

  ax.YAxis.TickValues = -0.1 : 0.1 : 1.1;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -0.5 : 0.1 : 1.1;

  % Axis limits
  ax.XAxis.Limits = [-0.025, 1.025];
  ax.YAxis.Limits = [-0.1, 1.1];

  % Axis labels
  ax.XAxis.Label.String = '$\theta_{\mathrm{old}}$';
  ax.YAxis.Label.String = '$\theta_{\mathrm{new}}$';

  % Title
  title_str = sprintf('Phase Transition Curve (PTC) with $A = %.2f$ and $\\vec{d} = (%.0f, %.0f)$', A_perturb, d_vec(1), d_vec(2));
  ax.Title.String = title_str;

  % Axis stuff
  box(ax, 'on');
  grid(ax, 'on');
  
end
