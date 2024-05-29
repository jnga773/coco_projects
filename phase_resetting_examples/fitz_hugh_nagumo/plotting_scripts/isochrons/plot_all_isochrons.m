function plot_all_isochrons(run_in, save_figure)
  % plot_all_isochrons(run_in, save_figure)
  %
  % Plots all isochron from the isochron_multi.m run.

  %-------------------------------------------------------------------------%
  %%                         Plot: Single Isochron                         %%
  %-------------------------------------------------------------------------%
  % matplotlib colour order
  colours = colororder();

  fig = figure(1);
  fig.Name = 'All Isochrons';
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

  % Read and plot isochrons
  template_plot_isochrons(ax, run_in)

  % Legend
  % legend(ax, Interpreter='latex', Location='northwest');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax.XAxis.TickDirection = 'in';
  ax.XAxis.TickValues = -2.0 : 0.5 : 2.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -2.75 : 0.5 : 2.75;

  % Y-Axis
  ax.YAxis.TickDirection = 'in';
  ax.YAxis.TickValues = -2.0 : 0.5 : 2.0;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -2.75 : 0.5 : 2.75;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax.XAxis.Limits = [-2.05, 2.05];
  ax.YAxis.Limits = [-2.05, 2.05];

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
    filename_out = sprintf('./images/multi_isochrons.pdf');
    % Save figure
    exportgraphics(fig, filename_out, ContentType='vector');
  end

end