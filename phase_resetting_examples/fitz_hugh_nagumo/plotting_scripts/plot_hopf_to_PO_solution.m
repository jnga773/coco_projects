function plot_hopf_to_PO_solution(run_in, label_in, run_old_ep, label_old_ep)
  % plot_test_po(run_in, label_in)
  %
  % Generates a test plot of the periodic orbit from solution [label_in] of
  % COCO run [run_in].

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read 'EP' solution from run_old_ep
  sol_ep = ep_read_solution('equilibrium_v2', run_old_ep, label_old_ep);
  % Equilibrium point
  x_ep   = sol_ep.x;

  % Bifurcation data
  bd_po  = coco_bd_read(run_in);

  % Read 'PO' solution from run_in
  sol_po = po_read_solution('equilibrium_v2', run_in, label_in);

  % Read column data
  x_norm_data_po = coco_bd_col(bd_po, '||equilibrium_v2.x||_{2,MPD}');
  c_data_po      = coco_bd_col(bd_po, 'c');

  % Read state solution
  xbp = sol_po.xbp;

  %------------------------------------%
  %     Plot - Bifurcation Diagram     %
  %------------------------------------%
  fig = figure(1);
  fig.Name = 'Bifurcation Diagram 1';
  fig.Units = 'inches';
  fig.Position = [3, 3, 10, 6]; fig.PaperSize = [10, 6];

  % Axis
  tiles = tiledlayout(1, 2, Padding='compact', TileSpacing='compact');
  ax1 = nexttile;

  % Plot bifurcation data
  plot(ax1, c_data_po, x_norm_data_po, Color='k')

  % Labels
  ax1.XAxis.Label.String = '$c$';
  ax1.YAxis.Label.String = '$\| x \|_{2, \mathrm{MPD}}$';

  % Title
  title_str = sprintf('Bifurcation Diagram (run: $\\verb!%s!$)', run_in);
  ax1.Title.String = title_str;

  % Figure stuff
  grid(ax1, 'on');
  box(ax1, 'on');

  %-----------------------------%
  %     Plot Periodic Orbit     %
  %-----------------------------%
  % Axis
  ax2 = nexttile;

  hold(ax2, 'on');

  % Plot - Periodic orbit
  plot(ax2, xbp(:, 1), xbp(:, 2), Color='k');

  % Plot - Equilibrium point
  stem(ax2, x_ep(1), x_ep(2), LineStyle='none', Marker='o', ...
       MarkerFaceColor='b', MarkerEdgeColor='b');

  hold(ax2, 'off');

  % Axis limits
  % ax.XAxis.Limits = [0.2720, 0.2738];
  % ax.YAxis.Limits = [0.5330, 0.5348];

  % Labels
  ax2.XAxis.Label.String = '$x_{1}(t)$';
  ax2.YAxis.Label.String = '$x_{2}(t)$';

  % Title
  title_str = sprintf('Peridic Orbit Solution (run: $\\verb!%s!$, label: %d)', run_in, label_in);
  ax2.Title.String = title_str;

  % Figure stuff
  grid(ax2, 'on');
  box(ax2, 'on');

end