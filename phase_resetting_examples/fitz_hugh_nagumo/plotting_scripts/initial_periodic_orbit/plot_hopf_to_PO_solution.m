function plot_hopf_to_PO_solution(run_in, label_in)
  % Plot the solution g

  % Read da solution g
  sol    = po_read_solution('', run_in, label_in);
  x_plot = sol.xbp;

  %--------------------------------------%
  %     Plot Initial Periodic Orbits     %
  %--------------------------------------%
  % Default colour order (matplotlib)
  colours = colororder();

  fig = figure(1); fig.Name = 'Initial Periodic Orbits'; clf;
  fig.Units = 'inches'; fig.Position = [3, 3, 8, 8]; fig.PaperSize = [8, 8];

  tiles = tiledlayout(1, 1, Padding='compact', TileSpacing='compact');
  ax = nexttile;

  %--------------%
  %     Plot     %
  %--------------%
  % Hold axes
  hold(ax, 'on');
  
  % Plot base solution
  % plot_base_periodic_orbit(ax);

  % Plot continuation solution
  plot(ax, x_plot(:, 1), x_plot(:, 2), LineStyle='-', Color=colours(1, :), ...
       DisplayName='Solution');

  legend(ax, Interpreter='latex');

  hold(ax, 'off');

  %--------------------%
  %     Axis Ticks     %
  %--------------------%
  % % X-Axis
  % ax.XAxis.TickDirection = 'in';
  % ax.XAxis.TickValues = -1.0 :0.5: 1.0;
  % ax.XAxis.MinorTick = 'on';
  % ax.XAxis.MinorTickValues = -0.75: 0.5: 0.75;
  % 
  % % Y-Axis
  % ax.YAxis.TickDirection = 'in';
  % ax.YAxis.TickValues = -1.0 : 0.5 : 1.0;
  % ax.YAxis.MinorTick = 'on';
  % ax.YAxis.MinorTickValues = -0.75 : 0.5 : 0.75;

  %---------------------%
  %     Axis Limits     %
  %---------------------%
  % ax.XAxis.Limits = [-1.05, 1.05];
  % ax.YAxis.Limits = [-1.05, 1.05];

  %---------------------%
  %     Axis Labels     %
  %---------------------%
  ax.XAxis.Label.String = '$x_{1}(t)$';
  ax.YAxis.Label.String = '$x_{2}(t)$';

  %--------------------%
  %     Axis Title     %
  %--------------------%
  ax.Title.String = 'Initial Periodic Orbit';

  %----------------------%
  %     Figure Stuff     %
  %----------------------%
  box(ax, 'on');
  grid(ax, 'on');

end