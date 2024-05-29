function plot_base_periodic_orbit(ax_in)
  % Plot the solution g
  
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution
  sol_PO = coll_read_solution('initial_PO', 'run02_initial_periodic_orbit', 1);

  % State space solution
  xbp_PO = sol_PO.xbp;

  %--------------%
  %     Plot     %
  %--------------%
  % Colour order
  colours = colororder();

  plot(ax_in, xbp_PO(:, 1), xbp_PO(:, 2), LineStyle='-', Color=[0.0, 0.0, 0.0, 0.3], ...
       LineWidth=4.0, DisplayName='$\Gamma$');

end