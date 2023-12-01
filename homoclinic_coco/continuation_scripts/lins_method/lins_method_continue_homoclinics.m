%-------------------------------------------------------------------------%
%%                     Parametrise the Heteroclinic                      %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.lins_method.continue_homoclinics;
% Which run this continuation continues from
run_old = run_names.lins_method.close_eps2;
% run_old = run_names.lins_method.close_lingap;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS2');
% label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');

% Print to console
fprintf("~~~ Lin's Method: Sixth Run (ode_coll2coll) ~~~ \n");
fprintf('Continue constrained segments to find parametrisation of homoclinic \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------------------------------%
%     Initialise Problem Structure (OLD)    %
%-------------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Turn of bifurcation detection
% prob = coco_set(prob, 'coll', 'bifus', 'off');

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set step sizes
% h = 1e-3;
% prob = coco_set(prob, 'cont', 'h_min', h, 'h0', h, 'h_max', h);

% Set Continuation steps
PtMX = 750;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

% Extract stored deviations of heteroclinic trajectory end points from corresponding equilibria
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

% Run COCO
% bdtest = coco(prob, run_new, [], 1, {'p1', 'p2', 'T1', 'theta', 'eps2', 'seg_s'});

bdtest = coco(prob, run_new, [], 1, {'p1', 'p2', 'eps1', 'eps2', 'theta', 'seg_u'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Find good label to plot
% label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
% label_plot = label_plot(1);
label_plot = 73;

%--------------%
%     Plot     %
%--------------%
plot_homoclinic_manifold_run(run_new, label_plot, data_bcs.label_approx, 19, save_figure);

plot_temporal_solution_single(run_new, label_plot, 20, save_figure);
plot_temporal_solutions(run_new, 19, save_figure);

compare_homoclinic_bifurcations(run_names, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);

fprintf('Print Start and End Points to Console\n');
fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));
