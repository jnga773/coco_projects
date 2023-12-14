%-------------------------------------------------------------------------%
%%                        Close the Distance eps2                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.lins_method.close_eps2;
% Which run this continuation continues from
run_old = run_names.lins_method.close_eps1;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS1');

% Print to console
fprintf("~~~ Lin's Method: Fifth Run (ode_coll2coll) ~~~ \n");
fprintf('Close epsilon gap until eps2=1e-8 \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set Continuation steps
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

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
prob = coco_add_event(prob, 'EPS2', 'eps2', 1.0e-4);

% Run COCO
coco(prob, run_new, [], 1, {'eps2', 'T1', 'T2', 'theta', 'p1', 'seg_u'});

%-------------------------------------------------------------------------%
%%                                 Plot                                  %%
%-------------------------------------------------------------------------%
% Find good label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EPS2');

%--------------%
%     Plot     %
%--------------%
plot_homoclinic_manifold_run(run_new, label_plot, data_bcs.label_approx, 18, save_figure);

plot_temporal_solution_single(run_new, label_plot, 15, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);
[solx, ~] =   ep_read_solution('x0', run_new, label_plot);

fprintf('Print Start and End Points to Console\n');
fprintf('Equilibrium point       = (%.3f, %.3f, %.3f)\n', solx.x);
fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));
