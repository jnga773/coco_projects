%-------------------------------------------------------------------------%
%%                  LORENTZ MODEL (Heteroclinic Orbit)                   %%
%-------------------------------------------------------------------------%
% This is a rewrite of the example in Section 10.2.2 of "Recipes for
% Continuation" by Harry Dankowicz and Frank Schilder. In the book they use
% the older 'po' and 'coll' toolboxes. Here, I have rewritten them using the
% newer 'po' and 'coll' tollboxes from the 'ode' toolbox.
%
% We solve for an E-to-P heteroclinic connection using Lin's method.

% The heteroclinic is solved using Lin's method in several steps:
%       Step One: The problem itself is constructed as two collocation
%                 segments in with two calls to the COCO constructor [ode_isol2coll].
%                 The initial conditions, parameters, and other important
%                 inputs are first calculated in 
%                 ./continuation_scripts, and saved
%                 to the data structure [data_bcs].
%       Step Two: The boundary conditions for the unstable and stable
%                 manifolds, found as functions in ./boundary_conditions/
%                 are then appended with the glue_conditions() function.
%                 The system parameters of the two segments are then "glued"
%                 together, i.e., we tell COCO that they are the same
%                 parameters. We then add the \epsilon spacings (eps1, eps2) and
%                 periods (T1 and T2) of the two segments as system parameters,
%                 and also add the parameters seg_u and seg_s, representing
%                 the distance between the plane \Sigma (defined in lins_method_setup)
%                 and the end points of the unstable and stable manifolds, respectively.
%     Step Three: We free the parameter seg_u, allowing the unstable manifold to grow
%                 until it hits the plane \Sigma, which is defined as a label
%                 "DelU".
%      Step Four: We reconstruct the COCO problem with ode_coll2coll, re-append
%                 the boundary conditions, and then free seg_s, growing the
%                 stable manifold until it starts on the plane \Sigma,
%                 corresponding to the label DelS.
%      Step Five: We reconstruct the COCO problem with ode_coll2coll, re-append
%                 the boundary conditions, and then free eps2, sweeping
%                 through a family of periodic orbits where the stable manifold
%                 starts on the plane \Sigma.
%       Step Six: We choose the solution from Step Five that starts closest to the
%                 end point of the unstable manifold, using the function
%                 find_lingap_vector(). With this solution chosen, we then
%                 close the Lin gap by freeing the parameter "lingap".
%     Step Seven: Finally, we reconstruct the problem again and free two of
%                 the system parameters, s and r, and follow the heteroclinic
%                 connection in two parameters.

% Clear plots
close all;

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');
% Add boundary condition functions to path
addpath('./boundary_conditions/');

% Add continuation scripts
addpath('./continuation_scripts/');

% Add plotting scripts
addpath('./plotting_scripts/');

% Save figures switch
% save_figure = true;
save_figure = false;

%--------------------%
%     Parameters     %
%--------------------%
% Some parameters and stuff
s = 10;
b = 8 / 3;
% r = 470 / 19;
r = 0.0;

% Initial parameter array
p0 = [s; r; b];

% Parameter namesS
pnames = {'s', 'r', 'b'};

% Parameter range
r_range = [20, 30];

%-----------------------%
%     Problem Setup     %
%-----------------------%
% Initial state values
x0 = [0.0; 0.0; 0.0];

% Parameter ranges
p1_range = [-1.0, 1.0];
p2_range = [0.0, 40.0];
p_range = [p1_range, p2_range];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
% funcs_field = {@lorenz, [], [], [], []};
% funcs_field = {@lorenz, @lorenz_DFDX, @lorenz_DFDP, [], []};
funcs_field = {@lorenz, @lorenz_DFDX, @lorenz_DFDP, @lorenz_DFDXDX, @lorenz_DFDXDP};

% Boundary conditions: Initial conditions
bcs_funcs.bcs_initial  = {@bcs_initial};
% Boundary conditions: Final conditions
bcs_funcs.bcs_final    = {@bcs_final};
% Boundary conditions: Eigenvector conditions
bcs_funcs.bcs_eig      = {@bcs_eig};
% Boundary conditions: Lin gap conditions
bcs_funcs.bcs_lingap   = {@bcs_lingap};
bcs_funcs.bcs_linphase = {@bcs_linphase};

%=========================================================================%
%                 FIND INITIAL ATTRACTING PERIODIC ORBIT                  %
%=========================================================================%
% wWe first compute a family of attracting/stable periodic orbits emanating
% from a Hopf bifurcation. Following this, we will use Lin's method to
% calculate the E-to-P connection.

%-------------------------------------------------------------------------%
%%                   Compute Initial Equilibrium Point                   %%
%-------------------------------------------------------------------------%
% We compute and continue the equilibrium point of the model using
% the 'EP' toolbox constructor 'ode_isol2ep'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_EP = 'run01_initial_EP';
run_new = run_names.initial_EP;

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initialisation: First Run\n');
fprintf(' Continue family of equilibrium points\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Continuation parameters : %s\n', 'r');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
prob = coco_set(prob, 'cont', 'PtMX', 100);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);
prob = coco_set(prob, 'ep', 'BTP', true);

% Set up isol2ep problem
prob = ode_isol2ep(prob, 'hopf_po', funcs_field{:}, x0, pnames, p0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'r', [0, 30]);

%-------------------------------------------------------------------------%
%%                   Continuation from Branching Point                   %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.branching_point = 'run02_branching_point';
run_new = run_names.branching_point;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initialisation: Second Run\n');
fprintf(' Continue bifurcations from the branching point\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'r');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);

% Continue from branching point
prob = ode_BP2ep(prob, 'hopf_po', run_old, label_old);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'r');

%-------------------------------------------------------------------------%
%%                 Periodic Orbit from Hopf Bifurcation                  %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.PO_from_hopf = 'run03_hopf_bifurcation_PO';
run_new = run_names.PO_from_hopf;
% Which run this continuation continues from
run_old = run_names.branching_point;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initialisation: Third Run\n');
fprintf(' Continue periodic orbits originating from Hopf bifurcation\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'r');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 0.5);
prob = coco_set(prob, 'cont', 'h0', 0.1);
prob = coco_set(prob, 'cont', 'h_max', 0.1);

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set 'var' (whatever that is) to true
prob = coco_set(prob, 'po', 'var', true);

% Prob set NTST
prob = coco_set(prob, 'cont', 'NTST', 50);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Continue from branching point
prob = ode_HB2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Hold the initial condition of solution to variational problem fixed
% Read data and uidx indices
[data, uidx] = coco_get_func_data(prob, 'hopf_po.po.orb.coll.var', 'data', 'uidx');
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars', ...
                     uidx(data.coll_var.v0_idx,:), ...
                     {'s1', 's2', 's3', ...
                      's4', 's5', 's6', ...
                      's7', 's8', 's9'});
%------------------%
%     Run COCO     %
%------------------%
% Add COCO event for r = 24
prob = coco_add_event(prob, 'r24', 'r', 24.0);

% Run COCO continuation
coco(prob, run_new, [], 1, 'r', [24, 25]);

%=========================================================================%
%                   LIN'S METHOD FOR HETEROCLINIC ORBIT                   %
%=========================================================================%
% We now calculate the heteroclinic connection using Lin's method, with steps
% outlined at the top of this program.

%-------------------------------------------------------------------------%
%%                         Grow Unstable Manifold                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.unstable_manifold = 'run03_unstable_manifold';
run_new = run_names.unstable_manifold;

% Which run this continuation continues from
run_old = run_names.PO_from_hopf;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'r24');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: First Run\n");
fprintf(' Continue unstable trajectory segment until we hit Sigma plane\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'seg_u, T1, T2');
fprintf(' =====================================================================\n');

%-------------------%
%     Read Data     %
%-------------------%
data_lins = lins_method_setup(run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
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
prob = ode_isol2coll(prob, 'unstable', funcs_field{:}, ...
                     data_lins.t0, data_lins.x_init_u, data_lins.p0);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', funcs_field{:}, ...
                     data_lins.t0, data_lins.x_init_s, data_lins.p0);

% Construct instance of equilibrium point
prob = ode_isol2ep(prob, 'x0', funcs_field{:}, ...
                   data_lins.x0, data_lins.p0);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab Floquet vector, value, and the initial epsilon parameters
vec0 = data_lins.vec_floquet;
lam0 = data_lins.lam_floquet;
eps0 = data_lins.epsilon0;

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, vec0, lam0, eps0); 

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'seg_u', 'T1', 'T2'}, {[], [0.0, 100], []});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelU');
label_plot = label_plot(1);
% label_plot = 1;

plot_solutions(run_new, label_plot, data_lins, 1, save_figure);
% plot_solutions(run_new, 1, 14, run7, p0_L, save_figure);

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
run_names.stable_manifold = 'run04_stable_manifold';
run_new = run_names.stable_manifold;
% Which run this continuation continues from
run_old = run_names.unstable_manifold;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelU');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Second Run\n");
fprintf(' Continue stable trajectory segment until we hit Sigma plane\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'seg_s, T2, T1');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
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
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Construct instance of equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab the Floquet eigenvector and eigenvalue
[data, chart] = coco_read_solution('bcs_eig', run_old, label_old);
vec0 = chart.x(data.vec_floquet_idx);
lam0 = chart.x(data.lam_floquet_idx);

% Grab the initial epsilon parameters
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
eps0 = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, vec0, lam0, eps0); 

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'seg_s', 'T2', 'T1'}, {[], [0, 100], []});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'DelS'));
label_plot = label_plot(1);
% label_plot = 1;

plot_solutions(run_new, label_plot, data_lins, 2, save_figure);

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
run_names.sweep_orbits = 'run05_sweep_orbits';
run_new = run_names.sweep_orbits;
% Which run this continuation continues from
run_old = run_names.stable_manifold;

% Continuation point
label_old = sort(coco_bd_labs(coco_bd_read(run_old), 'DelS'));
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Third Run\n");
fprintf(' Grow stable manifold from one of the periodic orbits\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'eps2, T1, T2');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
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
PtMX = 600;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Construct instance of equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab the Floquet eigenvector and eigenvalue
[data, chart] = coco_read_solution('bcs_eig', run_old, label_old);
vec0 = chart.x(data.vec_floquet_idx);
lam0 = chart.x(data.lam_floquet_idx);

% Grab the initial epsilon parameters
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
eps0 = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, vec0, lam0, eps0); 

%------------------%
%     Run COCO     %
%------------------%
% Add COCO event
prob = coco_add_event(prob, 'EPS2', 'eps2', 1e-6);

% Run COCO continuation
coco(prob, run_new, [], 1, {'eps2', 'T1', 'T2'}, [1e-6, eps0(2)]);

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EP');
label_plot = max(label_plot);
% label_plot = 1;

% Plot scan of stable manifold solutions
plot_solutions_scan(run_new, label_plot, data_lins, 4, save_figure)

% Plot single solution
plot_solutions(run_new, label_plot, data_lins, 5, save_figure);

%-------------------------------------------------------------------------%
%%                   Lin's Method: Closing the Lin Gap                   %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.close_lingap = 'run06_close_lingap';
run_new = run_names.close_lingap;
% Which run this continuation continues from
run_old = run_names.sweep_orbits;

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Fourth Run\n");
fprintf(' Reduce the Lin gap to zero\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'lingap, r, eps2, T1, T2');
fprintf(' =====================================================================\n');

%-------------------%
%     Read Data     %
%-------------------%
% Calculate minimum solution to continue from
data_lingap = find_lingap_vector(run_old);

% Continuation point
label_old = data_lingap.min_label;

% Print to console
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
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
PtMX = 200;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Construct instance of equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab the Floquet eigenvector and eigenvalue
[data, chart] = coco_read_solution('bcs_eig', run_old, label_old);
vec0 = chart.x(data.vec_floquet_idx);
lam0 = chart.x(data.lam_floquet_idx);

% Grab the initial epsilon parameters
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
eps0 = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, vec0, lam0, eps0); 

%---------------------------------%
%     Apply Lin Gap Condition     %
%---------------------------------%
% Find Lin's Vector
lingap = data_lingap.lingap0;

% Apply Lin's conditions
prob = apply_lingap_conditions(prob, data_lingap, bcs_funcs, lingap);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'lingap', 'r', 'eps2', 'T1', 'T2'}, {[0.0, lingap], [], [], [], []});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'Lin0'));
label_plot = label_plot(1);

plot_solutions(run_new, label_plot, data_lins, 6, save_figure);

%-------------------------------------------------------------------------%
%%                      Two-Parameter Continuation                       %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.continue_heteroclinics = 'run07_continue_heteroclinics';
run_new = run_names.continue_heteroclinics;
% Which run this continuation continues from
run_old = run_names.close_lingap;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Fourth Run\n");
fprintf(' Continue constrained segments to find parametrisation of homoclinic\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 's, r, eps1, eps2, T2');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
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
PtMX = 200;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);

% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Construct instance of equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab the Floquet eigenvector and eigenvalue
[data, chart] = coco_read_solution('bcs_eig', run_old, label_old);
vec0 = chart.x(data.vec_floquet_idx);
lam0 = chart.x(data.lam_floquet_idx);

% Grab the initial epsilon parameters
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
eps0 = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, vec0, lam0, eps0); 

%---------------------------------%
%     Apply Lin Gap Condition     %
%---------------------------------%
% Calculate minimum solution to continue from
data_lingap = find_lingap_vector(run_old);

% Apply Lin's conditions
prob = apply_lingap_conditions(prob, data_lingap, bcs_funcs, data_lingap.lingap);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'s', 'r', 'eps1', 'eps2', 'T2'});

%--------------%
%     Plot     %
%--------------%
% Plot two-parameter bifurcation diagram
plot_bifurcation_diagram(run_new, save_figure);