function plot_homoclinic_manifolds(fig_num_in, label_approx_in)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of previous run with largest period
  [p0_in, x_approx, x0_in] = read_approximate_homoclinic_solution(label_approx_in);

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

  %--------------%
  %     Plot     %
  %--------------%
  fig = figure(fig_num_in); fig.Name = 'Homoclinic Manifolds (3D)'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 12, 8]; fig.PaperSize = [12, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;
  ax.FontSize = 14.0;

  % Hold axes
  hold(ax, 'on');

  % Plot approximate homoclinic (high-period periodic orbit)
  plot3(ax, x_approx(:, 1), x_approx(:, 2), x_approx(:, 3), LineStyle='--', ...
        Color='Black', DisplayName='Approximate Homoclinic');

  % Plot manifold
  z_pt = 0.1;

  x = [-10, 10, 10, -10];
  y = [-10, -10, 10, 10];
  z = [z_pt, z_pt, z_pt, z_pt];
  fill3(ax, x, y, z, 'blue', FaceColor='blue', FaceAlpha=0.25, ...
        DisplayName='$\Sigma$');

  % Plot dot for stationary point
  plot3(ax, x0_in(1), x0_in(2), x0_in(3), Marker='o', LineStyle='none', ...
        MarkerSize=8, MarkerFaceColor='red', DisplayName='Equilibrium Point');

  % Plot vectors
  plot3(ax, plot_vu(1, :), plot_vu(2, :), plot_vu(3, :), '->', ...
        Color='blue', DisplayName='$\vec{v}^{u}$');
  plot3(ax, plot_vs1(1, :), plot_vs1(2, :), plot_vs1(3, :), '->', ...
        Color='red', DisplayName='$\vec{v}^{s}_{1}$');
  plot3(ax, plot_vs2(1, :), plot_vs2(2, :), plot_vs2(3, :), '->', ...
        Color='green', DisplayName='$\vec{v}^{s}_{2}$');

  % Legend
  legend(ax, 'Interpreter', 'latex')

  hold(ax, 'off');

  % Axis limits
  ax.XAxis.Limits = [-0.4, 0.3];
  ax.YAxis.Limits = [-0.6, 0.25];
  ax.ZAxis.Limits = [-0.2, 0.75];

  % Axis Labels
  ax.XAxis.Label.String = '$x_{1}(t)$';
  ax.YAxis.Label.String = '$x_{2}(t)$';
  ax.ZAxis.Label.String = '$x_{3}(t)$';

  % Axis title
  title_str = sprintf('Homoclinic Manifolds');
  ax.Title.String = title_str;

  % Tick params
  ax.XAxis.TickDirection = 'in';
  ax.YAxis.TickDirection = 'in';
  ax.ZAxis.TickDirection = 'in';

  % Figure stuff
  box(ax, 'on');
  grid(ax, 'on');

  ax.GridLineWidth = 0.5; ax.GridColor = 'black'; ax.GridAlpha = 0.25;
  view(45, 15.0);
end