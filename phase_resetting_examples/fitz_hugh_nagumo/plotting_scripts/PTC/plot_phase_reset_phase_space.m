function plot_phase_reset_phase_space(run_in, label_in, fig_num_in)
  % plot_phase_reset_PO(run_in, label_in)
  %
  % Plots the phase resetting periodic orbit from all four segments.

  %-------------------%
  %     Plot Data     %
  %-------------------%
  fig = figure(fig_num_in); clf;
  fig.Name = 'Initial Periodic Orbits';
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  % Hold axes
  hold(ax, 'on');

  plot_phase_reset_phase_space_template(ax, run_in, label_in)

  % Hold axes
  hold(ax, 'off');

  % Axis title
  title_str = sprintf('COCO Solution (run: $\\verb!%s!$, label: %d)', run_in, label_in);
  ax.Title.String = title_str;

end