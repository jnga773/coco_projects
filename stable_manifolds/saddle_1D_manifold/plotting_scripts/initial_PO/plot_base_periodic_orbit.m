function plot_base_periodic_orbit(ax_in)
  % Plot the solution g
  
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Load data matrix
  load('./data_mat/initial_PO.mat');

  %--------------%
  %     Plot     %
  %--------------%
  % Plotting colours
  colours = colororder();

  % Plot initial periodic orbit
  plot3(ax_in, xbp_PO(:, 1), xbp_PO(:, 2), xbp_PO(:, 3), ...
        LineStyle='-', Color=colours(3, :), ...
        DisplayName='$\Gamma$');

  % Plot equilibrium points: x_{+}
  plot3(ax_in, x_pos(1), x_pos(2), x_pos(3), ...
        LineStyle='none', ...
        Marker='*', MarkerFaceColor='b', MarkerSize=10,  ...
        MarkerEdgeColor='b', DisplayName='$q$');

  % % Plot equilibrium points: x_{-}
  % plot3(ax_in, x_neg(1), x_neg(2), x_neg(3), ...
  %       LineStyle='none', ...
  %       Marker='*', MarkerFaceColor='r', MarkerSize=10,  ...
  %       MarkerEdgeColor='r', DisplayName='$p$');
  %
  % % Plot equilibrium points: x_{0}
  % plot3(ax_in, x_0(1), x_0(2), x_0(3), ...
  %       LineStyle='none', ...
  %       Marker='o', MarkerFaceColor='r', MarkerSize=10, ...
  %       MarkerEdgeColor='r', DisplayName='$o$');
  % 
  % % Plot stable manifold of q / x_{+}
  % plot3(ax_in, W_q_stable(:, 1), W_q_stable(:, 2), W_q_stable(:, 3), ...
  %       Color=colours(1, :), ...
  %       DisplayName='$W^{s}(p)$');

end