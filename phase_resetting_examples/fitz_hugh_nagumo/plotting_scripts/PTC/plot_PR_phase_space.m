function plot_PR_phase_space(run_in, label_in)
  % plot_PR_phase_space(run_in, label_in)
  %
  % Plots the phase resetting periodic orbit from all four segments.

  %-------------------%
  %     Plot Data     %
  %-------------------%
  % Plot colours
  colours = colororder();
  
  fig = figure(1); clf;
  fig.Name = 'Initial Periodic Orbits';
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  set(ax, 'DefaultTextInterpreter', 'latex');

  % Hold axes
  hold(ax, 'on');

  % Plot phase space stuff
  plot_PR_phase_template(ax, run_in, label_in);

  % Hold axes
  hold(ax, 'off');

  %--------------------%
  %     Axis Title     %
  %--------------------%
  title_str = sprintf('COCO Solution (run: %s label: %d)', run_in, label_in);
  ax.Title.Interpreter = 'latex';
  ax.Title.String = title_str;

  % title(ax, title_str, Interpreter='latex')

  % Legend
  legend(ax, Interpreter='latex', Location='northwest');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax.XAxis.TickDirection = 'in';
  ax.XAxis.TickValues = -2.0 : 0.5 : 2.0;
  ax.XAxis.MinorTick = 'on';
  ax.XAxis.MinorTickValues = -2.0 : 0.25 : 2.0;

  % Y-Axis
  ax.YAxis.TickDirection = 'in';
  ax.YAxis.TickValues = -2.0 : 0.5 : 2.0;
  ax.YAxis.MinorTick = 'on';
  ax.YAxis.MinorTickValues = -2.0 : 0.25 : 2.0;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax.XAxis.Limits = [-2, 2];
  ax.YAxis.Limits = [-2, 2];

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

end