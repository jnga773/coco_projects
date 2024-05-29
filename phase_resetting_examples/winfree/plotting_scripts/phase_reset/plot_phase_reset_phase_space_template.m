function plot_phase_reset_phase_space_template(ax_in, run_in, label_in)
  % plot_phase_reset_phase_space_template(ax_in, run_in, label_in)
  %
  % Plots the state space solution from solution "label_in" of "run_in"
  % to axis "ax_in".

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read segment data
  sol1 = coll_read_solution('seg1', run_in, label_in);
  sol2 = coll_read_solution('seg2', run_in, label_in);
  sol3 = coll_read_solution('seg3', run_in, label_in);
  sol4 = coll_read_solution('seg4', run_in, label_in);

  % State space data
  x1   = sol1.xbp;
  x2   = sol2.xbp;
  x3   = sol3.xbp;
  x4   = sol4.xbp;
  
  % Read equilibrium point data
  sol_ep = ep_read_solution('singularity', run_in, label_in);

  % Equiliubrium point
  x_ep = sol_ep.x;

  % Read parameters
  p = sol1.p;
  % Displacement angle
  theta_perturb = p(7);
  % Displacement amplitude
  A_perturb = p(9);
  % Displacement vector
  d_vec = [cos(theta_perturb); sin(theta_perturb)];

  % Initial gamma_0 point
  gamma_0 = sol1.xbp(1, 1:2);

  % Plotting vector for d_vec
  d_vec_plot = [[gamma_0(1), gamma_0(1) + (A_perturb * d_vec(1))];
                [gamma_0(2), gamma_0(2) + (A_perturb * d_vec(2))]];

  % Segment 1 - x1 vector
  x0_seg2 = sol1.xbp(end, 1:2);
  % Segment 1 - w1 vector
  w0_seg2 = sol1.xbp(end, 3:4);
  % Rotate vector lol
  % w0_seg2 = rot90(w0_seg2, 3);

  % Plotting vector for w vector
  w_vec_plot = [[x0_seg2(1), x0_seg2(1) + (0.2 * w0_seg2(1))];
                [x0_seg2(2), x0_seg2(2) + (0.2 * w0_seg2(2))]];

  %-------------------%
  %     Plot Data     %
  %-------------------%
  % Default line colours
  colours = colororder();

  % Plot base solution
  plot_base_periodic_orbit(ax_in);

  % Plot segment 1
  plot(ax_in, x1(:, 1), x1(:, 2), Color=colours(1, :), ...
       DisplayName='Segment 1');

  % Plot segment 2
  plot(ax_in, x2(:, 1), x2(:, 2), Color=colours(2, :), ...
       DisplayName='Segment 2');

  % Plot segment 3
  plot(ax_in, x3(:, 1), x3(:, 2), Color=colours(3, :), ...
       DisplayName='Segment 3');

  % Plot segment 4
  plot(ax_in, x4(:, 1), x4(:, 2), Color=[colours(4, :), 0.5], ...
       DisplayName='Segment 4');

  % Plot equilibrium point
  plot(ax_in, x_ep(1), x_ep(2), Color='k', Marker='*', MarkerSize=10, ...
       MarkerFaceColor='k', MarkerEdgecolor='k', ...
       HandleVisibility='off');

  % Plot d_vec
  plot(ax_in, d_vec_plot(1, :), d_vec_plot(2, :), Color=colours(5, :), ...
       HandleVisibility='off');

  % Plot w_vec at \theta_new
  plot(ax_in, w_vec_plot(1, :), w_vec_plot(2, :), Color=colours(10, :), ...
       LineWidth=2.5, HandleVisibility='off');

  % Legend
  legend(ax_in, Interpreter='latex', Location='northwest');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % X-Axis
  ax_in.XAxis.TickDirection = 'in';
  ax_in.XAxis.TickValues = -1.0:0.5:1.0;
  ax_in.XAxis.MinorTick = 'on';
  ax_in.XAxis.MinorTickValues = -0.75:0.5:0.75;

  % Y-Axis
  ax_in.YAxis.TickDirection = 'in';
  ax_in.YAxis.TickValues = -1.0:0.5:1.0;
  ax_in.YAxis.MinorTick = 'on';
  ax_in.YAxis.MinorTickValues = -0.75:0.5:0.75;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  ax_in.XAxis.Limits = [-1.05, 1.05];
  ax_in.YAxis.Limits = [-1.05, 1.05];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax_in.XAxis.Label.String = '$x(t)$';
  ax_in.YAxis.Label.String = '$y(t)$';

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  box(ax_in, 'on');
  grid(ax_in, 'on');

end