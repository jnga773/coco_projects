function plot_all_three_new_solution(run_new, run_old, save_figure)
  % PLOT_ALL_THREE_NEW_SOLUTION: Plots new solutions from [run_new] and
  % compares them to solutions from [run_old]

  % Read solution of previous run with largest period, in this case LABEL=142
  % label_max = coco_bd_labs(bd_old, 'EP');
  % label_max = max(label_max);
  [sol_old, ~] = coll_read_solution('po.orb', run_old, max(coco_bd_labs(coco_bd_read(run2), 'EP')));
  [sol_new, ~] = coll_read_solution('po.orb', run_new, 1);

  % x solution
  x0_old = sol_old.xbp;
  x0_new = sol_new.xbp;

  %--------------------------------------%
  %     Plot: Panel (f) New Solution     %
  %--------------------------------------%
  fig = figure(7); fig.Name = 'New Solution Periodic Orbit (2D)'; clf;
  fig.Units = 'inches'; fig.Position = [0, 0, 12, 8]; fig.PaperSize = [12, 8];
  ax1 = subplot(1, 3, 1); ax2 = subplot(1, 3, 2); ax3 = subplot(1, 3, 3);
  % ax.FontSize = 14.0;

  % Hold axes
  hold(ax1, 'on');
  hold(ax2, 'on');
  hold(ax3, 'on');

  % Plot: run6 solutions
  leg_lab = sprintf('run6 $\\left( T = %.2f \\right)$', sol_old.T);
  plot(ax1, x0_old(:, 1), x0_old(:, 2), LineWidth=2.0, ...
      DisplayName=leg_lab);
  plot(ax2, x0_old(:, 1), x0_old(:, 3), LineWidth=2.0, ...
      DisplayName=leg_lab);
  plot(ax3, x0_old(:, 2), x0_old(:, 3), LineWidth=2.0, ...
      DisplayName=leg_lab);

  % Plot: run7 solutions
  leg_lab = sprintf('run7 $\\left( T = %.2f \\right)$', sol_new.T);
  plot(ax1, x0_new(:, 1), x0_new(:, 2), LineStyle='none', Marker='x', ...
      DisplayName=leg_lab);
  plot(ax2, x0_new(:, 1), x0_new(:, 3), LineStyle='none', Marker='x', ...
      DisplayName=leg_lab);
  plot(ax3, x0_new(:, 2), x0_new(:, 3), LineStyle='none', Marker='x', ...
      DisplayName=leg_lab);

  % Legend
  legend(ax1, 'Interpreter', 'latex')
  legend(ax2, 'Interpreter', 'latex')
  legend(ax3, 'Interpreter', 'latex')

  hold(ax1, 'off');
  hold(ax2, 'off');
  hold(ax3, 'off');

  % hold(ax1, 'on');
  % coco_plot_sol(run6, [1:1:10, 15:5:100], '', 'x', 1, 'x', 2)
  % hold(ax1, 'off');
  % 
  % hold(ax2, 'on');
  % coco_plot_sol(run6, [1:1:10, 15:5:100], '', 'x', 1, 'x', 3)
  % hold(ax2, 'off');
  % 
  % hold(ax3, 'on');
  % coco_plot_sol(run6, [1:1:10, 15:5:100], '', 'x', 2, 'x', 3)
  % hold(ax3, 'off');

  % Axis Labels
  ax1.XAxis.Label.String = ['$x_{1}$'];
  ax1.YAxis.Label.String = ['$x_{3}$'];

  ax2.XAxis.Label.String = ['$x_{2}$'];
  ax2.YAxis.Label.String = ['$x_{3}$'];

  ax3.XAxis.Label.String = ['$x_{2}$'];
  ax3.YAxis.Label.String = ['$x_{3}$'];

  % Axis limits
  % ax1.XAxis.Limits = [0.0, 7.0];
  % ax1.YAxis.Limits = [0.0, 5.5];
  % 
  % ax2.XAxis.Limits = [0.0, 7.0];
  % ax2.YAxis.Limits = [0.0, 6.5];
  % 
  % ax3.XAxis.Limits = [0.0, 7.0];
  % ax3.YAxis.Limits = [0.0, 6.5];

  % Axis title
  ax2.Title.String = ['High Period Periodic Orbit (New Solution)'];

  % Tick params
  ax1.XAxis.TickDirection = 'in'; ax1.YAxis.TickDirection = 'in';
  ax2.XAxis.TickDirection = 'in'; ax2.YAxis.TickDirection = 'in';
  ax3.XAxis.TickDirection = 'in'; ax3.YAxis.TickDirection = 'in';

  % Figure stuff
  box(ax1, 'on'); box(ax2, 'on'); box(ax3, 'on');
  grid(ax1, 'on'); grid(ax2, 'on'); grid(ax3, 'on');

  ax1.GridLineWidth = 0.5; ax1.GridColor = 'black'; ax1.GridAlpha = 0.25;
  ax2.GridLineWidth = 0.5; ax2.GridColor = 'black'; ax2.GridAlpha = 0.25;
  ax3.GridLineWidth = 0.5; ax3.GridColor = 'black'; ax3.GridAlpha = 0.25;

  if save_figure == true
    exportgraphics(fig, './images/new_solution.png', Resolution=800);
    % exportgraphics(fig, './images/new_solution.pdf', ContentType='vector');
  end 
end