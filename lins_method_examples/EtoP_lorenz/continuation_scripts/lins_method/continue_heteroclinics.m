%-------------------------------------------------------------------------%
%%                      Two-Parameter Continuation                       %%
%-------------------------------------------------------------------------%
% The continuation problem structure encoded below is identical to that
% above, but constructed from stored data. We continue in the problem
% parameters by releasing 'r', 'b', 'eps1', 'eps2', and 'T2', and allow
% these to vary during continuation.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.continue_heteroclinics;
% Which run this continuation continues from
run_old = run_names.close_lingap;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');
label_old = label_old(1);

% Calculate minimum solution to continue from
data_lins = find_lingap_vector(run_old);

% Print to console
fprintf("~~~ Lin's Method: Fourth Run (ode_coll2coll) ~~~ \n");
fprintf('Reduce the Lin gap to zero \n');
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
PtMX = 200;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Set NPR to save every 50 steps
prob = coco_set(prob, 'cont', 'NPR', 10);

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

% Glue lin conditions
prob = glue_lin_conditions(prob, data_lins, data_lins.lingap0);

% Run COCO
coco(prob, run_new, [], 1, {'s', 'r', 'eps1', 'eps2', 'T2'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Plot bifurcation diagram
plot_bifurcation_diagram(run_new, save_figure);
