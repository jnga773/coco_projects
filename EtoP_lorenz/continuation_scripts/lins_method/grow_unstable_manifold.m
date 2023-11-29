%-------------------------------------------------------------------------%
%%                    Grow Orbit in Unstable Manifold                    %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.unstable_manifold;
% Which run this continuation continues from
run_old = run_names.hopf_bifurcation;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = sort(label_old);
label_old = label_old(2);

% Print to console
fprintf("~~~ Lin's Method: First Run (ode_isol2coll) ~~~ \n");
fprintf('Grow unstable manifold from one of the periodic orbits \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Lin's Method     %
%----------------------------%
% Read data from previous COCO run and calculate relevant information to
% setup Lin's method.
data_bcs = lins_method_setup(run_old, label_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% % Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Prob set NTST
prob = coco_set(prob, 'cont', 'NTST', 50);

% Set NPR to save every 50 steps
prob = coco_set(prob, 'cont', 'NPR', 50);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 300;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_isol2coll(prob, 'unstable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_u, data_bcs.p0);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_s, data_bcs.p0);

% Grab Floquet vector, value, and the initial epsilon parameters
vec0 = data_bcs.vec_floquet;
lam0 = data_bcs.lam_floquet;
eps0 = data_bcs.epsilon0;

% Append eigenspace and boundary conditions
prob = glue_conditions(prob, data_bcs, vec0, lam0, eps0); 

% Run COCO
coco(prob, run_new, [], 1, {'seg_u', 'T1', 'T2'});
% coco(prob, run_new, [], 1, {'seg_u'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Grab maximum point of Sig_u
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelU');
label_plot = label_plot(1);
% label_plot = 1;

%--------------%
%     Plot     %
%--------------%
plot_solutions(run_new, label_plot, data_bcs, 1, save_figure);
% plot_solutions(run_new, 1, 14, run7, p0_L, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% 
% fprintf('Print Start and End Points to Console\n');
fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));
