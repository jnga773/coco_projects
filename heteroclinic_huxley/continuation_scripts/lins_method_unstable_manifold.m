%-------------------------------------------------------------------------%
%%       Solve for Unstable Manifold towards Middle Point (x1=0.5)       %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.unstable_manifold;

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
prob = coco_set(prob, 'coll', 'NTST', 100);

% Set Continuation steps
PtMX = 100;
% prob = coco_set(prob, 'cont', 'PtMX', PtMX);
% prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_isol2coll(prob, 'unstable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_u, data_bcs.p0);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_s, data_bcs.p0);

% Glue that shit together, haumi ;)
prob = glue_conditions(prob, data_bcs, epsilon0);

% Run COCO
% Free parameters: seg_u - Distance of final point of unstable trajectory
%                          to point on \Sigma plane.
%                  T1    - Period for unstable segment to reach \Sigma plane.
%                  T2    - Period for stable segment to reach \Sigma plane.

coco(prob, run_new, [], 1, {'seg_u', 'T1', 'T2'});
% coco(prob, run_new, [], 1, 'seg_u');

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Grab maximum point of Sig_u
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelU');
label_plot = label_plot(1);

%--------------%
%     Plot     %
%--------------%
plot_run_i(run_new, 1, 2, p0, save_figure);
plot_run_i(run_new, label_plot, 3, p0, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);

fprintf('Print Start and End Points to Console\n');
fprintf('Unstable starting point = (%.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f)\n', sol2.xbp(end, :));
