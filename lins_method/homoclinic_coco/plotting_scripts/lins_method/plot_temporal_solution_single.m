function plot_temporal_solution_single(run_in, label_in, fig_num_in, save_figure)
  % PLOT_TEMPORAL_SOLUTIONS: Plot the temporal solutions for all COCO
  % solutions for the two-parameter continuation. Will probably do in a
  % waterfall plot or something to see what's happening.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Label for solution to plot
  % label_plot = 1;

  % Read solution of current run
  [sol1, ~] = coll_read_solution('unstable', run_in, label_in);
  [sol2, ~] = coll_read_solution('stable', run_in, label_in);

  % x-solution
  x_sol1 = sol1.xbp;
  x_sol2 = sol2.xbp;

  % Time solution
  t_sol1 = sol1.tbp;
  t_sol2 = sol2.tbp + t_sol1(end);

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(fig_num_in); clf;
  fig.Name = 'Temporal Solutions';
  fig.Units = 'inches'; fig.Position = [3, 3, 24, 8]; fig.PaperSize = [24, 8];

  % Create subplot azes
  % ax1 = subplot(1, 3, 1); ax2 = subplot(1, 3, 2); ax3 = subplot(1, 3, 3);

  % Create tiled layout
  tiles = tiledlayout(1, 3, TileSpacing='compact', Padding='compact');
  ax = [];

  %-------------------%
  %     Plot G(t)     %
  %-------------------%
  % Grab tile
  ax1 = nexttile;
  ax = [ax, ax1];

  % Plot
  hold(ax1, 'on');
  plot(ax1, t_sol1, x_sol1(:, 1), DisplayName='Unstable', ...
       Marker='.', MarkerSize=15);
  plot(ax1, t_sol2, x_sol2(:, 1), DisplayName='Stable', ...
       Marker='.', MarkerSize=15);
  legend(ax1);
  hold(ax1, 'off');
  % Labels
  ax1.YAxis.Label.String = '$G(t)$';

  %-------------------%
  %     Plot Q(t)     %
  %-------------------%
  % Grab tile
  ax2 = nexttile;
  ax = [ax, ax2];

  % Plot
  hold(ax2, 'on');
  plot(ax2, t_sol1, x_sol1(:, 2), DisplayName='Unstable', ...
       Marker='.', MarkerSize=15);
  plot(ax2, t_sol2, x_sol2(:, 2), DisplayName='Stable', ...
       Marker='.', MarkerSize=15);
  legend(ax2);
  hold(ax2, 'off');
  % Labels
  ax2.YAxis.Label.String = '$G(t)$';

  %-------------------%
  %     Plot I(t)     %
  %-------------------%
  % Grab tile
  ax3 = nexttile;
  ax = [ax, ax3];

  % Plot
  hold(ax3, 'on');
  plot(ax3, t_sol1, x_sol1(:, 3), DisplayName='Unstable', ...
       Marker='.', MarkerSize=15);
  plot(ax3, t_sol2, x_sol2(:, 3), DisplayName='Stable', ...
       Marker='.', MarkerSize=15);
  legend(ax3);
  hold(ax3, 'off');
  % Labels
  ax3.YAxis.Label.String = '$G(t)$';

  %--------------------%
  %     Axis Stuff     %
  %--------------------%
  for i = 1:3
    % Grab axis
    axi = ax(i);

    %---------------------%
    %     Axis Limits     %
    %---------------------%
    % axi.XAxis.Limits = [-2.5, 92.5];
    % axi.YAxis.Limits = [-0.25, 9.25];

    %---------------------%
    %     Axis Labels     %
    %---------------------%
    axi.XAxis.Label.String = '$t$';

    %----------------------%
    %     Figure Stuff     %
    %----------------------%
    % Tick params
    axi.XAxis.TickDirection = 'in';
    axi.YAxis.TickDirection = 'in';
    axi.ZAxis.TickDirection = 'in';

    % Figure stuff
    box(axi, 'on');
    grid(axi, 'on');
    
  end

  if save_figure == true
    % Filename
    figname = sprintf('homoclinic_time_series_%s_d', run_in(1:5), label_in);
    % exportgraphics(fig, ['./images/', figname, '.png'], Resolution=800);
    exportgraphics(fig, ['./images/', figname, '.pdf'], ContentType='vector');
  end

end