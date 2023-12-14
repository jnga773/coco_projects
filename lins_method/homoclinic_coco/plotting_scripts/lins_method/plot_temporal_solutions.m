function tu_data = plot_temporal_solutions(run_in, fig_num_in, save_figure)
  % PLOT_TEMPORAL_SOLUTIONS: Plot the temporal solutions for all COCO
  % solutions for the two-parameter continuation. Will probably do in a
  % waterfall plot or something to see what's happening.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Data
  bd = coco_bd_read(run_in);
  % Label for solution to plot
  labels = coco_bd_labs(bd, 'ALL');
  labels = sort(labels);

  % Empty arrays
  xu1_data = {};
  xu2_data = {};
  xu3_data = {};
  tu_data  = {};

  xs1_data = {};
  xs2_data = {};
  xs3_data = {};
  ts_data  = {};

  p1_data = [];

  % Cycle through all labels
  for lab = labels
    % Read solution
    [solu, ~] = coll_read_solution('unstable', run_in, lab);
    [sols, ~] = coll_read_solution('stable', run_in, lab);

    % Get gamme value
    p1_val = coco_bd_val(bd, lab, 'p1');

    % State-space solution
    xu = solu.xbp;
    xs = sols.xbp;

    % Time solution
    tu = solu.tbp;
    ts = sols.tbp + tu(end);

    % Append to arrays
    xu1_data{end+1} = xu(:, 1);
    xu2_data{end+1} = xu(:, 2);
    xu2_data{end+1} = xu(:, 3);
    tu_data{end+1}  = tu;

    xs1_data{end+1} = xs(:, 1);
    xs2_data{end+1} = xs(:, 2);
    xs2_data{end+1} = xs(:, 3);
    ts_data{end+1}  = ts;

    p1_data = [p1_data, p1_val];

  end

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(fig_num_in); clf;
  fig.Name = 'Temporal Solutions';
  fig.Units = 'inches'; fig.Position = [3, 3, 16, 8]; fig.PaperSize = [16, 8];

  % Create tiled layout
  tiles = tiledlayout(1, 1, TileSpacing='compact', Padding='compact');
  ax = nexttile;

  % Get colour order
  C = get(gca, 'ColorOrder');
  % Colors
  C0 = C(1, :);
  C1 = C(2, :);

  % Hold axis
  hold(ax, 'on');

  % Plot solutions
  for i = 1 : numel(labels)

    % Get data
    xu_plot = xu1_data{i};
    % xu_plot = xu2_data{i};
    % xu_plot = xu3_data{i};
    tu_plot = tu_data{i};

    xs_plot = xs1_data{i};
    % xs_plot = xs2_data{i};
    % xs_plot = xs3_data{i};
    ts_plot = ts_data{i};

    % labelu_plot = labels(i) * ones(1, numel(tu_plot));
    % labels_plot = labels(i) * ones(1, numel(ts_plot));

    labelu_plot = p1_data(i) * ones(1, numel(tu_plot));
    labels_plot = p1_data(i) * ones(1, numel(ts_plot));

    % Plot
    plot3(ax, labelu_plot, tu_plot, xu_plot, Color=C0);
    plot3(ax, labels_plot, ts_plot, xs_plot, Color=C1);


  end


  hold(ax, 'off');


  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$p_{1}$';
  ax.YAxis.Label.String = '$t$';
  % ax.ZAxis.Label.String = '$G(t)$';
  % ax.ZAxis.Label.String = '$Q(t)$';
  ax.ZAxis.Label.String = '$x_{3}(t)$';

  % Axis title
  ax.Title.String = 'Temporal Solution';

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  % ax.XAxis.Limits = [];
  % ax.YAxis.Limits = [];
  % ax.ZAxis.Limits = [];

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  % Tick params
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';
  ax.ZAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;
  view(45, 15.0);

  if save_figure == true
    % Filename
    figname = sprintf('homoclinic_time_series_scan_%s', run_in(1:5));
    % exportgraphics(fig, ['./images/', figname, '.png'], Resolution=800);
    exportgraphics(fig, ['./images/', figname, '.pdf'], ContentType='vector');
  end

end