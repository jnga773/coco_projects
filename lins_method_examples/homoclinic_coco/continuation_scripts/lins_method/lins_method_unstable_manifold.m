%-------------------------------------------------------------------------%
%%           Solve for Unstable Manifold towards data_bcs.pt0            %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.lins_method.unstable_manifold;

% Print to console
fprintf("~~~ Lin's Method: First Run (ode_isol2coll) ~~~ \n");
fprintf('Continue unstable trajectory segment until we hit Sigma plane \n');
fprintf('Run name: %s  \n', run_new);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set Continuation steps
% PtMX = 100;
% prob = coco_set(prob, 'cont', 'PtMX', PtMX);
% prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);
% prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_isol2coll(prob, 'unstable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_u, data_bcs.p0);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_s, data_bcs.p0);

% Construct instance of 'ep' tool box to follow stationary point
prob = ode_isol2ep(prob, 'x0', func_list{:}, data_bcs.equilib_pt, ...
                   data_bcs.p0);

% Glue that shit together, haumi ;)
prob = glue_conditions(prob, data_bcs, epsilon0);

% Run COCO
coco(prob, run_new, [], 1, {'seg_u', 'T1', 'p1'});
% coco(prob, run_new, [], 1, {'seg_u', 'p1'});

%-------------------------------------------------------------------------%
%%                                 Plot                                  %%
%-------------------------------------------------------------------------%
% Grab maximum point of Sig_u
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelU');
label_plot = label_plot(1);

%--------------%
%     Plot     %
%--------------%
plot_homoclinic_manifold_run(run_new, label_plot, data_bcs.label_approx, 14, save_figure);
% plot_homoclinic_manifold_run(run_new, 1, 14, run7, p0_L, save_figure);

% plot_temporal_solution_single(run_new, label_plot, 15, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);
[solx, ~] = ep_read_solution('x0', run_new, label_plot);

fprintf('Print Start and End Points to Console\n');
fprintf('Equilibrium point       = (%.3f, %.3f, %.3f)\n', solx.x);
fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));

