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
  % Colour order
  colours = colororder();

  % Plot periodic orbit solution
  plot(ax_in, xbp_PO(:, 1), xbp_PO(:, 2), LineStyle='-', Color=[0.0, 0.0, 0.0, 0.3], ...
       LineWidth=4.0, DisplayName='$\Gamma$');

  % Plot equilibrium points: x_{0}
  plot(ax_in, x_0(1), x_0(2), ...
       LineStyle='none', ...
       Marker='o', MarkerFaceColor='r', MarkerSize=10, ...
       MarkerEdgeColor='r', DisplayName='$\vec{x}_{\ast}$');

end