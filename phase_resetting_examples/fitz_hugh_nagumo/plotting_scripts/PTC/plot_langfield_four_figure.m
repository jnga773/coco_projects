function plot_langfield_four_figure(run_in)
  % plot_phase_reset_PO(run_in, label_in, run_PO_base_in)
  %
  % Plots the phase resetting periodic orbit from all four segments.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Bifrucation data
  bd = coco_bd_read(run_in);

  % Perturbation value
  A_perturb_data = coco_bd_col(bd, 'A_perturb');
  % \theta_new data
  theta_new_data = coco_bd_col(bd, 'theta_new');

  % Plot labels
  SP_labels = sort(coco_bd_labs(bd, 'SP'));

  SP_A = coco_bd_val(bd, SP_labels, 'A_perturb');
  SP_N = coco_bd_val(bd, SP_labels, 'theta_new');

  %-------------------%
  %     Plot Data     %
  %-------------------%
   % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(3); clf;
  fig.Name = 'Langfield Figure';
  fig.Units = 'inches'; fig.Position = [0, 0, 10, 10]; fig.PaperSize = [10, 10];

  tiles = tiledlayout(2, 2, Padding='compact', TileSpacing='compact');
  ax = [];

  %-------------------------------%
  %     Plot Bifurcation Data     %
  %-------------------------------%
  ax1 = nexttile;
  ax = [ax, ax1];

  % Hold axes
  hold(ax(1), 'on');

  % Plot bifurcation data
  plot(ax(1), A_perturb_data, theta_new_data, Color=colours(1, :));

  % Plot points
  plot(ax(1), SP_A, SP_N, LineStyle='none', Marker='o', MarkerSize=10, ...
       MarkerEdgeColor=colours(2, :), MarkerFaceColor=colours(2, :));

  % Hold axes
  hold(ax(1), 'off');

  % Axis Ticks
  ax(1).XAxis.TickValues = 0.0 : 0.25 : 0.75;
  ax(1).XAxis.MinorTick = 'on';
  ax(1).XAxis.MinorTickValues = 0.125 : 0.25 : 0.875;

  ax(1).YAxis.TickValues = 0.4 : 0.2 : 1.4;
  ax(1).YAxis.MinorTick = 'on';
  ax(1).YAxis.MinorTickValues = 0.5 : 0.2 : 1.5;

  % Axis limits
  ax(1).XAxis.Limits = [0.0, 0.75];
  ax(1).YAxis.Limits = [0.4, 1.4];

  % Axis Labels
  ax(1).XAxis.Label.String = '$A$';
  ax(1).YAxis.Label.String = '$\theta_{\mathrm{new}}$';

  % Tick params
  ax(1).XAxis.TickDirection = 'in';
  ax(1).YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax(1), 'on');
  grid(ax(1), 'on');

  % ax(1).GridLineWidth = 0.5; ax(1).GridColor = 'black'; ax(1).GridAlpha = 0.25;

  %-------------------------%
  %     Plot Solution 1     %
  %-------------------------%
  ax2 = nexttile;
  ax = [ax, ax2];

  % Hold axes
  hold(ax(2), 'on');

  % Plot phase space solution
  plot_PR_phase_template(ax(2), run_in, SP_labels(1));

  % Hold axes
  hold(ax(2), 'off');

  %-------------------------%
  %     Plot Solution 2     %
  %-------------------------%
  ax3 = nexttile;
  ax = [ax, ax3];

  % Hold axes
  hold(ax(3), 'on');

  % Plot phase space solution
  plot_PR_phase_template(ax(3), run_in, SP_labels(2));

  % Hold axes
  hold(ax(3), 'off');

  %-------------------------%
  %     Plot Solution 3     %
  %-------------------------%
  ax4 = nexttile;
  ax = [ax, ax4];

  % Hold axes
  hold(ax(4), 'on');

  % Plot phase space solution
  plot_PR_phase_template(ax(4), run_in, SP_labels(3));

  % Hold axes
  hold(ax(4), 'off');

  for idx = 2 : 4
    grid(ax(idx), 'on');
    box(ax(idx), 'on');

    xlim(ax(idx), [-1.05, 1.05]);
    ylim(ax(idx), [-1.05, 1.05]);
  end

end