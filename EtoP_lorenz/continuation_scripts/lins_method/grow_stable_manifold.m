%-------------------------------------------------------------------------%
%%                     Grow Orbit in Stable Manifold                     %%
%-------------------------------------------------------------------------%
% The continuation problem structure encoded below is identical to that
% above, but constructed from stored data. We grow an orbit in the stable
% manifold of the periodic orbit by releasing 'sg2', 'T2', and 'T1', and
% allow these to vary during continuation.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.stable_manifold;
% Which run this continuation continues from
run_old = run_names.unstable_manifold;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelU');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Second Run (ode_coll2coll) ~~~ \n");
fprintf('Grow stable manifold from one of the periodic orbits \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Setup COCO problem
prob = coco_prob();

% % Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Set NPR to save every 50 steps
prob = coco_set(prob, 'cont', 'NPR', 50);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Grab Floquet vector, value, and the initial epsilon parameters
[data, chart] = coco_read_solution('apply_bcs', run_old, label_old);
vec0 = chart.x(data.vec_floquet_idx);
lam0 = chart.x(data.lam_floquet_idx);
eps0 = chart.x(data.epsilon_idx);

% Append eigenspace and boundary conditions
prob = glue_conditions(prob, data_bcs, vec0, lam0, eps0);

% Run COCO
coco(prob, run_new, [], 1, {'seg_s', 'T2', 'T1'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Grab maximum point of Sig_u
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelS');
label_plot = label_plot(2);

%--------------%
%     Plot     %
%--------------%
% Plot single solution
plot_solutions(run_new, label_plot, data_bcs, 3, save_figure);

% Plot scan of stable manifold solutions
% plot_solutions_scan(run_new, label_plot, data_bcs, 4, save_figure)

% %--------------------------%
% %     Print to Console     %
% %--------------------------%
% % [sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
% % [sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% % 
% % fprintf('Print Start and End Points to Console\n');
% % fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
% % fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
% % fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
% % fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));
