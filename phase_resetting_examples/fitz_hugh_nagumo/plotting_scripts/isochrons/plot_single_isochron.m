function plot_single_isochron(run_in, save_figure)
  % plot_single_isochron(run_in, save_figure)
  %
  % Plots a single isochron from the isochron_test.m run.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Bifurcation data matrix
  bd_read = coco_bd_read(run_in);

  % Read data
  iso1 = coco_bd_col(bd_read, 'iso1');
  iso2 = coco_bd_col(bd_read, 'iso2');


  %-------------------------------------------------------------------------%
  %%                         Plot: Single Isochron                         %%
  %-------------------------------------------------------------------------%
  % matplotlib colour order
  colours = colororder();

  fig = figure(1);
  fig.Name = 'Single (Test) Isochron';
  fig.Units = 'inches';
  fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  %--------------%
  %     Plot     %
  %--------------%
  hold(ax, 'on');

  % Plot base solution
  plot_base_periodic_orbit(ax);

  % Plot single isochron
  plot(ax, iso1, iso2, Color=colours(1, :), LineStyle='-', ...
       DisplayName='Isochron');

  % Legend
  legend(ax, Interpreter='latex', Location='northwest');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax.XAxis.TickDirection = 'in';
  ax.XAxis.TickValues = -3.0:0.5:3.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -3.75:0.5:3.75;

  % Y-Axis
  ax.YAxis.TickDirection = 'in';
  ax.YAxis.TickValues = -3.0:0.5:3.0;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -3.75:0.5:3.75;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax.XAxis.Limits = [-3.05, 3.05];
  ax.YAxis.Limits = [-3.05, 3.05];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$x(t)$';
  ax.YAxis.Label.String = '$y(t)$';

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  box(ax, 'on');
  grid(ax, 'on');

  %---------------------%
  %     Save Figure     %
  %---------------------%
  if save_figure == true
    % Create filename
    filename_out = sprintf('./images/single_isochron_test.pdf');
    % Save figure
    exportgraphics(fig, filename_out, ContentType='vector');
  end

end