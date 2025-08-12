function plot_base_periodic_orbit(ax_in, run_in)
  % plot_base_periodic_orbit(ax_in, run_in)
  %
  % Plots the base periodic orbit from the phase resetting data
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read segment data
  sol1 = coll_read_solution('seg1', run_in, 1);
  sol2 = coll_read_solution('seg2', run_in, 1);
  solx = ep_read_solution('x0', run_in, 1);

  % State space data
  xbp1 = sol1.xbp;
  xbp2 = sol2.xbp;
  x0   = solx.x;

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
  plot(ax_in, xbp1(:, 1), xbp1(:, 2), Color=colours(3, :), ...
       DisplayName='$\Gamma$');

  % Plot segment 2
  plot(ax_in, xbp2(:, 1), xbp2(:, 2), Color=colours(3, :), ...
       HandleVisibility='off');


end