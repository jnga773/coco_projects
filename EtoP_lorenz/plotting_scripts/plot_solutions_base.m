function plot_solutions_base(ax_in, data_in)
  % PLOT_HOMOCLINIC_HYPERPLANE_BASE: Plots the unstable and stable
  % eigenvectors and the Sigma plane. This will be called in
  % plot_homoclinic_manifolds().

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Get trivial equilibrium point and unstable eigenvector from data_in
  x0 = data_in.x0;
  vu = data_in.vu;

  % Get final point of periodic orbit and stable Floquet vector from data_in
  x_po_end = data_in.x_po_end;
  vs = -data_in.vec_floquet;

  % Scale for vectors
  scale_u = 0.1;
  scale_s = 5.0;

  plot_vu  = [
              [x0(1), x0(1) + (scale_u * vu(1))];
              [x0(2), x0(2) + (scale_u * vu(2))];
              [x0(3), x0(3) + (scale_u * vu(3))]
              ];

  plot_vs  = [
              [x_po_end(1), x_po_end(1) + (scale_s * vs(1))];
              [x_po_end(2), x_po_end(2) + (scale_s * vs(2))];
              [x_po_end(3), x_po_end(3) + (scale_s * vs(3))]
              ];

  %-------------------%
  %     Plot Data     %
  %-------------------%
  % Manifold boundaries
  x = [-20, 50, 50, -20];
  y = [-20, -20, 30, 30];
  z = [-10, -10, 40, 40];

  % Plot \Sigma plane
  fill3(ax_in, x, y, z, 'blue', FaceColor='blue', FaceAlpha=0.25, ...
        DisplayName='$\Sigma$');

  % Plot dot for stationary point
  plot3(ax_in, x0(1), x0(2), x0(3), Marker='o', LineStyle='none', ...
        MarkerSize=8, MarkerFaceColor='red', DisplayName='Equilibrium Point');

  % Plot vectors
  plot3(ax_in, plot_vu(1, :), plot_vu(2, :), plot_vu(3, :), '->', ...
        Color='blue', DisplayName='$\vec{v}^{u}$');
  plot3(ax_in, plot_vs(1, :), plot_vs(2, :), plot_vs(3, :), '->', ...
        Color='red', DisplayName='$\vec{v}^{s}_{1}$');


end