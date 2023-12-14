function plot_homoclinic_hyperplane_base(ax_in, x0_in, p0_in, label_approx_in)
  % PLOT_HOMOCLINIC_HYPERPLANE_BASE: Plots the unstable and stable
  % eigenvectors and the Sigma plane. This will be called in
  % plot_homoclinic_manifolds().

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of previous run with largest period
  [~, x_approx, ~] = read_approximate_homoclinic_solution(label_approx_in);

  % Calculate non-trivial steady states and stable and unstable eigenvectors
  [vu, vs1, vs2] = unstable_stable_eigenvectors(x0_in, p0_in);

  % Scale for vectors
  scale = 0.1;

  plot_vu  = [
              [x0_in(1), x0_in(1) + (scale * vu(1))];
              [x0_in(2), x0_in(2) + (scale * vu(2))];
              [x0_in(3), x0_in(3) + (scale * vu(3))]
              ];
  plot_vs1 = [
              [x0_in(1), x0_in(1) + (scale * vs1(1))];
              [x0_in(2), x0_in(2) + (scale * vs1(2))];
              [x0_in(3), x0_in(3) + (scale * vs1(3))]
              ];
  plot_vs2 = [
              [x0_in(1), x0_in(1) + (scale * vs2(1))];
              [x0_in(2), x0_in(2) + (scale * vs2(2))];
              [x0_in(3), x0_in(3) + (scale * vs2(3))]
              ];

  %-------------------%
  %     Plot Data     %
  %-------------------%
  % Plot approximate homoclinic (high-period periodic orbit)
  plot3(ax_in, x_approx(:, 1), x_approx(:, 2), x_approx(:, 3), LineStyle='--', ...
        Color='Black', DisplayName='Approximate Homoclinic');

  % Plot manifold
  z_pt = 0.1;

  x = [-10, 10, 10, -10];
  y = [-10, -10, 10, 10];
  z = [z_pt, z_pt, z_pt, z_pt];
  fill3(ax_in, x, y, z, 'blue', FaceColor='blue', FaceAlpha=0.25, ...
        DisplayName='$\Sigma$');

  % Plot dot for stationary point
  plot3(ax_in, x0_in(1), x0_in(2), x0_in(3), Marker='o', LineStyle='none', ...
        MarkerSize=8, MarkerFaceColor='red', DisplayName='Equilibrium Point');

  % Plot vectors
  plot3(ax_in, plot_vu(1, :), plot_vu(2, :), plot_vu(3, :), '->', ...
        Color='blue', DisplayName='$\vec{v}^{u}$');
  plot3(ax_in, plot_vs1(1, :), plot_vs1(2, :), plot_vs1(3, :), '->', ...
        Color='red', DisplayName='$\vec{v}^{s}_{1}$');
  plot3(ax_in, plot_vs2(1, :), plot_vs2(2, :), plot_vs2(3, :), '->', ...
        Color='green', DisplayName='$\vec{v}^{s}_{2}$');


end