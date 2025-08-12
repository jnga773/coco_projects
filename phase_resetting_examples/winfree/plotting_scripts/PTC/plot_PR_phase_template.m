function plot_PR_phase_template(ax_in, run_in, label_in)
  % plot_PR_phase_template(ax_in, run_in, label_in)
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
  solx = ep_read_solution('x0', run_in, label_in);

  % State space data
  xbp1 = sol1.xbp;
  xbp2 = sol2.xbp;
  xbp3 = sol3.xbp;
  xbp4 = sol4.xbp;
  x0   = solx.x;

  % Read parameters
  p = sol1.p;
  % Displacement amplitude
  A_perturb = p(8);
  % Displacement angle
  theta_perturb = p(9);
  % Displacement vector
  d_vec = [cos(theta_perturb * (2 * pi));
           sin(theta_perturb * (2 * pi))];

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

  % Plot equilibrium point
  plot(ax_in, x0(1), x0(2), ...
        LineStyle='none', ...
        Marker='o', MarkerFaceColor='r', MarkerSize=10, ...
        MarkerEdgeColor='r', DisplayName='$\vec{x}_{\ast}$');

  % Plot segment 1
  plot(ax_in, xbp1(:, 1), xbp1(:, 2), Color=colours(1, :), ...
       DisplayName='Segment 1');

  % Plot segment 2
  plot(ax_in, xbp2(:, 1), xbp2(:, 2), Color=colours(2, :), ...
       DisplayName='Segment 2');

  % Plot segment 3
  plot(ax_in, xbp3(:, 1), xbp3(:, 2), Color=colours(3, :), ...
       DisplayName='Segment 3');

  % Plot segment 4
  plot(ax_in, xbp4(:, 1), xbp4(:, 2), Color=[colours(4, :), 0.5], ...
       DisplayName='Segment 4');

  % Plot d_vec
  plot(ax_in, d_vec_plot(1, :), d_vec_plot(2, :), Color=colours(5, :), ...
       HandleVisibility='off');

  % % Plot w_vec at \theta_new
  % plot(ax_in, w_vec_plot(1, :), w_vec_plot(2, :), Color=colours(10, :), ...
  %      LineWidth=2.5, HandleVisibility='off');

end