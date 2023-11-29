function plot_solutions_scan(run_in, label_in, data_in, fig_num_in, save_figure)
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution of unstable manifold
  sol_u = coll_read_solution('unstable', run_in, label_in);
  % Read solution of periodic
  sol_p = po_read_solution('hopf_po', run_in, label_in);

  % x-solution
  x_u = sol_u.xbp;
  x_p = sol_p.xbp;

  % Create empty data arrays
  XX = [];
  YY = [];
  ZZ = [];

  % Cycle through stable manifold solutions
  bd = coco_bd_read(run_in);
  for label = coco_bd_labs(bd)
    % Grab solution
    sol = coll_read_solution('stable', run_in, label);
    
    % Append to data arrays
    XX = [XX, sol.xbp(:, 1)];
    YY = [YY, sol.xbp(:, 2)];
    ZZ = [ZZ, sol.xbp(:, 3)];
  end

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

  % Plot COCO solution
  plot3(ax, x_u(:, 1), x_u(:, 2), x_u(:, 3), LineStyle='-', ...
        Marker='.', MarkerSize=15, DisplayName='Unstable Manifold');
  plot3(ax, x_p(:, 1), x_p(:, 2), x_p(:, 3), LineStyle='-', ...
        DisplayName='Periodic Orbit');

  % Plot Surf plot (woah!)
  surf(ax, XX, YY, ZZ, FaceColor=[0.9, 0.9, 0.0], FaceAlpha=1, ...
       MeshStyle='column', LineStyle='-', EdgeColor=[0.6, 0.6, 0.6], ...
       LineWidth=0.5, DisplayName='Stable Manifold');

  % Plot base solution
  plot_solutions_base(ax, data_in)

  % Legend
  legend(ax, 'Interpreter', 'latex')

  hold(ax, 'off');

  % Axis limits
  ax.XAxis.Limits = [-20, 40];
  ax.YAxis.Limits = [-20, 30];
  ax.ZAxis.Limits = [-10, 50];

  % Axis Labels
  ax.XAxis.Label.String = ['$x_{1}(t)$'];
  ax.YAxis.Label.String = ['$x_{2}(t)$'];
  ax.ZAxis.Label.String = ['$x_{3}(t)$'];

  % Axis title
  title_str = sprintf('COCO Solution (run: $\\verb!%s!$)', run_in);
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

  if save_figure == true
    % Filename
    figname = sprintf('heteroclinc_trajectory_sweep_%s', run_in(1:5));
    % exportgraphics(fig, ['./images/', figname, '.png'], Resolution=800);
    exportgraphics(fig, ['./images/', figname, '.pdf'], ContentType='vector');
  end

end