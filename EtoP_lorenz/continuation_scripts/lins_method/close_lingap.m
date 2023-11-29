%-------------------------------------------------------------------------%
%%                        Reduce Lin Gap to Zero                         %%
%-------------------------------------------------------------------------%
% The continuation problem structure below consists of an additional one
% zero function, an additional monitor function, and the corresponding
% inactive continuation parameter 'lingap'. Its dimensional deficit equals
% -4. We reduce the Lin gap to 0 by releasing 'lingap', 'r', 'eps2', 'T1',
% and 'T2', and allow these to vary during continuation.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.close_lingap;
% Which run this continuation continues from
run_old = run_names.sweep_orbits;

% Calculate minimum solution to continue from
data_lins = find_lingap_vector(run_old);

% Continuation point
label_old = data_lins.min_label;

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
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

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
coco(prob, run_new, [], 1, {'lingap', 'r', 'eps2', 'T1', 'T2'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Grab label for solution to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
label_plot = label_plot(1);
% label_plot = 1;

%--------------%
%     Plot     %
%--------------%
% Plot single solution
plot_solutions(run_new, label_plot, data_bcs, 6, save_figure);

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
