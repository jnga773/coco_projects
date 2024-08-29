%=========================================================================%
%                     WINFREE MODEL (Phase Resetting)                     %
%=========================================================================%
% Doing an exmaple from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.

% Clear plots
close('all');

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');
% Add field functions to path
addpath('./functions/fields/');
% Add boundary condition functions to path
addpath('./functions/bcs/');
% Add SymCOCO files to path
addpath('./functions/symcoco/');

% Add continuation scripts
addpath('./continuation_scripts/initial_periodic_orbit/');

% Add plotting scripts
addpath('./plotting_scripts/initial_periodic_orbit');

% Figure save switch
% save_figure = true;
save_figure = false;

%--------------------%
%     Parameters     %
%--------------------%
% Set parameters to the same thing as in the paper
a = 0;
omega = -0.5;

%-----------------------%
%     Problem Setup     %
%-----------------------%
% Parameter names
pnames = {'a', 'omega'};

% Initial parameter values
p0 = [a; omega];

% Initial state values
x0 = [0; 0];

% % Parameter ranges
a_range = [-2.0, 2.0];
omega_range = [-5.0, 5.0];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
% funcs.field = {@winfree, @winfree_DFDX, @winfree_DFDP};
funcs.field = winfree_symbolic();

% Boundary conditions: Periodic orbit
% bcs_funcs.bcs_PO = {@bcs_PO};
bcs_funcs.bcs_PO = bcs_PO_symbolic();

% Boundary conditions: Period
% bcs_funcs.bcs_T = {@bcs_T};
bcs_funcs.bcs_T = bcs_T_symbolic();

% Adjoint equations: Functions (for floquet_mu and floquet_wnorm)
% funcs.floquet = {@floquet_adjoint};
funcs.floquet = floquet_symbolic();

% Boundary conditions: Floquet multipliers
% bcs_funcs.bcs_floquet = {@bcs_floquet};
bcs_funcs.bcs_floquet = bcs_floquet_symbolic();

%=========================================================================%
%                    CALCULATE INITIAL PERIODIC ORBIT                     %
%=========================================================================%
% We compute a family of periodic orbits, emanating from a Hopf
% bifurcation. We first compute the Hopf bifurcation line using the 'EP'
% toolbox, and then a family of periodic orbits with the 'PO' toolbox.
% Finally, we shift the state-space solution data such that, at t=0,
%                       x1(t=0) = max(x1) .
% We then verify this solution using the 'COLL' toolbox.

%-------------------------------------------------------------------------%
%%                    Compute Initial Periodic Orbit                     %%
%-------------------------------------------------------------------------%
% We compute and continue an initial periodic orbit from a guess solution
% found by using ode45.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_PO = 'run01_initial_PO';
run_new = run_names.initial_PO;

% Print to console
fprintf('~~~ Initial Periodic Orbit: First Run ~~~\n');
fprintf('Solve for initial solution of a periodic orbit\n')
fprintf('Run name: %s\n', run_new);

%------------------------------------%
%     Calculate Initial Solution     %
%------------------------------------%
data_isol = calculate_initial_PO(p0);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% % The value of 10 for 'NAdapt' implied that the trajectory discretisation
% % is changed adaptively ten times before the solution is accepted.
prob = coco_set(prob, 'coll', 'NTST', 30);

% Set adaptive t mesh
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Continue periodic orbit from initial solution
prob = ode_isol2po(prob, '', funcs.field{:}, ...
                   data_isol.t, data_isol.x, pnames, data_isol.p);

% Add segment for EP continuations
prob = ode_isol2ep(prob, 'x0', funcs.field{1}, ...
                   [0.0; 0.0], data_isol.p);

% Glue parameters
prob = glue_parameters_PO(prob);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Add event for a = 0
prob = coco_add_event(prob, 'PO_PT', 'a', 0.0);

%------------------%
%     Run COCO     %
%------------------%
% Run continuation
coco(prob, run_new, [], 1, {'a', 'omega'}, [-2.0, 2.0]);

%-------------------------------------------------------------------------%
%%                   Re-Solve for Rotated Perioid Orbit                  %%
%-------------------------------------------------------------------------%
% Using previous parameters and MATLAB's ode45 function, we solve for an
% initial solution to be fed in as a periodic orbit solution.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_PO_COLL = 'run02_initial_periodic_orbit';
run_new = run_names.initial_PO_COLL;
% Which run this continuation continues from
run_old = run_names.initial_PO;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');
label_old = label_old(1);

% Print to console
fprintf("~~~ Initial Periodic Orbit: Second Run ~~~ \n");
fprintf('Find new periodic orbit \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_soln = calculate_periodic_orbit(run_old, label_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set PtMX steps
PtMX = 20;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 10);

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set initial guess to 'coll'
prob = ode_isol2coll(prob, 'initial_PO', funcs.field{:}, ...
                     data_soln.t, data_soln.x, pnames, data_soln.p);

% Add equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'x0',   run_old, label_old);

% Glue parameters and apply boundary condition
prob = apply_PO_boundary_conditions(prob, bcs_funcs.bcs_PO);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Event for A = 7.5
prob = coco_add_event(prob, 'PO_PT', 'a', 0.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'a', 'omega'});

%----------------------%
%    Testing Plots     %
%----------------------%
% Label for solution plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'PO_PT');
label_plot = label_plot(1);

% Calculate stable manifold of saddle point 'q' and save data to .mat in 
% ./data_mat/ directory
save_initial_PO_data(run_new, label_plot);

% Plot solution
plot_initial_periodic_orbit(save_figure);

%-------------------------------------------------------------------------%
%%            Compute Floquet Bundle at Zero Phase Point (mu)            %%
%-------------------------------------------------------------------------%
% We now add the adjoint function and Floquet boundary conditions to
% compute the adjoint (left or right idk) eigenvectors and eigenvalues.
% This will give us the perpendicular vector to the tangent of the periodic
% orbit. However, this will only be for the eigenvector corresponding to
% the eigenvalue \mu = 1. Hence, here we continue in \mu (mu_s) until
% mu_s = 1.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.compute_floquet_1 = 'run03_compute_floquet_bundle_1_mu';
run_new = run_names.compute_floquet_1;
% Which run this continuation continues from
run_old = run_names.initial_PO_COLL;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');

% Print to console
fprintf("~~~ Floquet Bundle: First Run ~~~ \n");
fprintf('Calculate Floquet bundle (mu) \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------%
%     Calculate Things     %
%--------------------------%
data_adjoint = calc_initial_solution_adjoint_problem(run_old, label_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 1e-2, 'h0', 1e-2, 'h_max', 1e-2);

% Set PtMX
PTMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Set NTST
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdapt
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', 'off');

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Add segment as initial solution
prob = ode_isol2coll(prob, 'adjoint', funcs.floquet{:}, ...
                     data_adjoint.t0, data_adjoint.x0, ...
                     data_adjoint.pnames, data_adjoint.p0);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Add event
prob = coco_add_event(prob, 'mu=1', 'mu_s', 1.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'mu_s', 'w_norm', 'T'} , [0.0, 1.1]);

%-------------------------------------------------------------------------%
%%          Compute Floquet Bundle at Zero Phase Point (w_norm)          %%
%-------------------------------------------------------------------------%
% Having found the solution (branching point 'BP') corresponding to
% \mu = 1, we can continue in the norm of the vector w (w_norm), until the
% norm is equal to zero. Then we will have the correct perpendicular
% vector.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.compute_floquet_2 = 'run08_compute_floquet_bundle_2_w';
run_new = run_names.compute_floquet_2;
% Which run this continuation continues from
run_old = run_names.compute_floquet_1;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

% Print to console
fprintf("~~~ Floquet Bundle: Second Run ~~~ \n");
fprintf('Calculate Floquet bundle (w_norm) \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set number of PtMX steps
prob = coco_set(prob, 'cont', 'PtMX', 250);

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Continue coll from previous branching point
prob = ode_BP2coll(prob, 'adjoint', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Add event when w_norm = 1
prob = coco_add_event(prob, 'NORM1', 'w_norm', 1.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'w_norm', 'mu_s', 'T'}, [0.0, 1.1]);

%-------------------%
%     Save Data     %
%-------------------%
label_plot = coco_bd_labs(coco_bd_read(run_new), 'NORM1');

% Save solution to .mat to be read in 'yamada_PTC.m'
save_floquet_data(run_new, label_plot);

%=========================================================================%
%                               END OF FILE                               %
%=========================================================================%
