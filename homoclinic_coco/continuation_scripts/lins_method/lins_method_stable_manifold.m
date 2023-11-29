%-------------------------------------------------------------------------%
%%            Solve for Stable Manifold towards data_bcs.pt0             %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.lins_method.stable_manifold;
% Which run this continuation continues from
run_old = run_names.lins_method.unstable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelU');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Second Run (ode_coll2coll) ~~~ \n");
fprintf('Continue stable trajectory segment until we hit Sigma plane \n');
fprintf('Run name: %s  \n', run_new);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

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

% Run COCO
coco(prob, run_new, [], 1, {'seg_s', 'T2', 'p1'});
% coco(prob, run_new, [], 1, {'seg_s', 'p1'});

%-------------------------------------------------------------------------%
%%                                 Plot                                  %%
%-------------------------------------------------------------------------%
% Grab maximum point of Sig_s
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelS');
label_plot = label_plot(1);

%--------------%
%     Plot     %
%--------------%
plot_homoclinic_manifold_run(run_new, label_plot, 3, data_bcs.label_approx, save_figure);
% plot_homoclinic_manifold_run(run_new, 1, 14, run7, p0_L, save_figure);

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