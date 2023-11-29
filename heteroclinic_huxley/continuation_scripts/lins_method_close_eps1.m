%-------------------------------------------------------------------------%
%%                        Close the Distance eps1                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.close_eps1;
% Which run this continuation continues from
run_old = run_names.close_lingap;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');
label_old = label_old(1);

% Print to console
fprintf('~~~ Fourth run (ode_coll2coll) ~~~ \n');
fprintf('Close delta gap until esp2=1e-3 \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Extract stored deviations of stable and unstable manifolds from
% stationary equilibrium point
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = glue_conditions(prob, data_bcs, epsilon);

% Read Linsgap data structure
data_lins = coco_read_solution('lins_data', run_old, label_old);

% Extract stored lingap value from previous run
[data, chart] = coco_read_solution('bcs_lingap', run_old, label_old);
lingap = chart.x(data.lingap_idx);

% Apply Lin's conditions
prob = glue_lingap_conditions(prob, data_lins, lingap);

% Add event for when eps1 gets small enough
prob = coco_add_event(prob, 'EPS1', 'eps1', 1e-4);

% Run COCO
% Free parameters: eps1   - Deviation of initial point of unstable trajectory
%                           from the equilibrium point.
%                  T1     - Period for unstable segment to reach \Sigma plane.
%                  T2     - Period for stable segment to reach \Sigma plane.
%                  p1     - System parameter.
%                  seg_u  - Distance of final point of stable trajectory
%                           to point on \Sigma plane.

coco(prob, run_new, [], 1, {'eps1', 'T1', 'T2', 'p1', 'seg_u'});
% coco(prob, run_new, [], 1, {'eps1', 'p2'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Find good label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EPS1');
label_plot = label_plot(1);

%--------------%
%     Plot     %
%--------------%
plot_run_i(run_new, label_plot, 6, p0, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);

% fprintf('Print Start and End Points to Console\n');
fprintf('Unstable starting point = (%.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f)\n', sol2.xbp(end, :));
