function plot_phase_reset_with_isochrons(run_in, label_in, fig_num_in, save_figure)
  % plot_phase_resetplot_phase_reset_with_isochrons_PO(run_in, label_in)
  %
  % Plots the phase resetting periodic orbit along with the calculating isochrons

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read base periodic orbit solution
  sol_PO = coll_read_solution('initial_PO', 'run02_initial_periodic_orbit', 1);
  % State space solution
  xbp_PO = sol_PO.xbp;

  % Read segment data
  sol1 = coll_read_solution('seg1', run_in, label_in);
  % sol2 = coll_read_solution('seg2', run_in, label_in);
  % sol3 = coll_read_solution('seg3', run_in, label_in);
  sol4 = coll_read_solution('seg4', run_in, label_in);

  % State space data
  % x1   = sol1.xbp;
  % x2   = sol2.xbp;
  % x3   = sol3.xbp;
  x4   = sol4.xbp;
  
  % Read equilibrium point data
  sol_ep = ep_read_solution('singularity', run_in, label_in);

  % Equiliubrium point
  x_ep = sol_ep.x;

  % Read parameters
  p = sol4.p;
  % Displacement angle
  theta_perturb = p(8);
  % Displacement amplitude
  A_perturb = p(9);
  % Displacement vector
  d_vec = [cos(theta_perturb); sin(-theta_perturb)];

  % Initial gamma_0 point
  gamma_0 = sol1.xbp(1, 1:2);

  % Plotting vector for d_vec
  d_vec_plot = [[gamma_0(1), gamma_0(1) + (A_perturb * d_vec(1))];
                [gamma_0(2), gamma_0(2) + (A_perturb * d_vec(2))]];

  % Add perturbed orbit
  xbp_perturbed_PO = xbp_PO;
  xbp_perturbed_PO(:, 1) = xbp_perturbed_PO(:, 1) + (A_perturb * d_vec(1));
  xbp_perturbed_PO(:, 2) = xbp_perturbed_PO(:, 2) + (A_perturb * d_vec(2));

  %-------------------------------------------------------------------------%
  %%                       Plot: Reset with Isochron                       %%
  %-------------------------------------------------------------------------%
  % matplotlib colour order
  colours = colororder();

  % Figure setup
  fig = figure(fig_num_in); clf;
  fig.Name = 'Initial Periodic Orbits';
  fig.Units = 'inches';
  fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  %--------------%
  %     Plot     %
  %--------------%
  % Hold axes
  hold(ax, 'on');

  % Plot base solution
  plot(ax, xbp_PO(:, 1), xbp_PO(:, 2), LineStyle='-', Color=[colours(3, :), 0.5], ...
       LineWidth=4.0, DisplayName='$\Gamma$');

  % Read and plot isochrons
  template_plot_isochrons(ax, 'run08_isochron_multi')

  % Plot perturbed orbit
  plot(ax, xbp_perturbed_PO(:, 1), xbp_perturbed_PO(:, 2), Color=[colours(4, :), 0.5]);

  % Plot segment 4
  plot(ax, x4(:, 1), x4(:, 2), Color=[colours(4, :), 0.5], ...
       DisplayName='Segment 4');

  % Plot equilibrium point
  plot(ax, x_ep(1), x_ep(2), Color='k', Marker='*', MarkerSize=10, ...
       MarkerFaceColor='k', MarkerEdgecolor='k', ...
       HandleVisibility='off');

  % Plot d_vec
  plot(ax, d_vec_plot(1, :), d_vec_plot(2, :), Color=colours(5, :), ...
       HandleVisibility='off');

  % Hold axes
  hold(ax, 'off');

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
  ax.XAxis.Limits = [-2.0, 2.0];
  ax.YAxis.Limits = [-2.0, 2.0];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$x(t)$';
  ax.YAxis.Label.String = '$y(t)$';

  % Axis title
  title_str = sprintf('COCO Solution (run: $\\verb!%s!$, label: %d)', run_in, label_in);
  ax.Title.String = title_str;

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
    filename_out = sprintf('./images/phase_reset_curve_%s_%d.pdf', run_in(1:5), label_in);
    % Save figure
    exportgraphics(fig, filename_out, ContentType='vector');
  end

end