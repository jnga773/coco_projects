function plot_base_periodic_orbit(ax_in)
  % Plot the solution g
  
  %-------------------------------%
  %     Calculate unit circle     %
  %-------------------------------%
  theta = 0 : 0.01 : 2 * pi;

  x_base = cos(theta);
  y_base = sin(theta);

  %--------------%
  %     Plot     %
  %--------------%
  plot(ax_in, x_base, y_base, LineStyle='-', Color=[0.0, 0.0, 0.0, 0.5], ...
       LineWidth=4.0, DisplayName='$\Gamma$');

end