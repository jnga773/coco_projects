function plot_homoclinic_hyperplane_base(ax_in, p0_in)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Calculate non-trivial steady states and stable and unstable eigenvectors
  [x0, vu, vs] = unstable_stable_eigenvectors(p0_in);

  % Scale for vectors
  scale = 0.1;

  plot_vu  = [
              [x0(1), x0(1) + (scale * vu(1))];
              [x0(2), x0(2) + (scale * vu(2))]
              ];
  plot_vs = [
             [x0(1), x0(1) + (scale * vs(1))];
             [x0(2), x0(2) + (scale * vs(2))]
             ];

  %-------------------%
  %     Plot Data     %
  %-------------------%
  % Plot approximate homoclinic
  yline(ax_in, 0.2, LineStyle='-', Color='green', Alpha=1.0, DisplayName='$\Sigma$');

  % Plot vectors
  plot(ax_in, plot_vu(1, :), plot_vu(2, :), '->', Color='blue', DisplayName='$\vec{v}_{u}$');
  plot(ax_in, plot_vs(1, :), plot_vs(2, :), '->', Color='red', DisplayName='$\vec{v}_{s}$');

  % Plot dot for stationary point
  plot(ax_in, x0(1), x0(2), Marker='o', LineStyle='none', ...
       MarkerSize=8, MarkerFaceColor='black', DisplayName='$\vec{x}_{*}$');

end