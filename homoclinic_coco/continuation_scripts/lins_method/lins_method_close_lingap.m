%-------------------------------------------------------------------------%
%%                   Lin's Method: Closing the Lin Gap                   %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.lins_method.close_lingap;
% Which run this continuation continues from
run_old = run_names.lins_method.stable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelS');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Third Run (ode_coll2coll) ~~~ \n");
fprintf('Close the Lin Gap on the Sigma Plane \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Set Continuation steps
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);
% prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

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

% Find Lin's Vector
data_lins = find_lingap_vector(run_old, label_old);
lingap = data_lins.lingap0;

% Apply Lin's conditions
prob = glue_lingap_conditions(prob, data_lins, lingap);

% Run COCO
coco(prob, run_new, [], 1, {'lingap', 'T1', 'T2', 'theta', 'p1', 'seg_u'});
% coco(prob, run_new, [], 1, {'lingap' 'theta', 'seg_s', 'p1'});

%-------------------------------------------------------------------------%
%%                                 Plot                                  %%
%-------------------------------------------------------------------------%
% Find good label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
label_plot = label_plot(1);

%--------------%
%     Plot     %
%--------------%
plot_homoclinic_manifold_run(run_new, label_plot, 16, data_bcs.label_approx, save_figure);

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
