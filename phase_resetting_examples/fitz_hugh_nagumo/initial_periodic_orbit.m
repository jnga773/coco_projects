%=========================================================================%
%            FITZ-HUGH-NAGUMO (Phase Resetting Periodic Orbit)            %
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
addpath('./continuation_scripts/initial_PO/');

% Add plotting scripts
addpath('./plotting_scripts/initial_PO');

% Figure save switch
% save_figure = true;
save_figure = false;

%--------------------%
%     Parameters     %
%--------------------%
% Parameters
c = 2.5;
a = 0.7;
b = 0.8;
z = -0.4;

%-----------------------%
%     Problem Setup     %
%-----------------------%
p0 = [c; a; b; z];
pnames = {'c'; 'a'; 'b'; 'z'};

% Initial state vector
x0 = [0.9066; -0.2582];
% x0 = [0.2729; 0.5339];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
% funcs.field = {@fhn, @fhn_DFDX, @fhn_DFDP};
funcs.field = fhn_symbolic();

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

% Print to console
fprintf('~~~ Initial Periodic Orbit: First Run ~~~\n');
fprintf('Solve for initial solution of the equilibrium point\n')
fprintf('Run name: %s\n', run_new);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
prob = coco_set(prob, 'cont', 'PtMX', 50);

% Set up isol2ep problem
prob = ode_isol2ep(prob, '', funcs.field{:}, x0, pnames, p0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'c', [-4.0, 4.0]);

%-------------------------------------------------------------------------%
%%                           Move Hopf z Value                           %%
%-------------------------------------------------------------------------%
% Continuing from a Hopf bifurcation with 'ode_HB2HB', we vary
% the 'A' parameter to A = 7.3757

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.move_hopf = 'run02_move_hopf';
run_new = run_names.move_hopf;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Continuation point
label_old = sort(coco_bd_labs(coco_bd_read(run_old), 'HB'));
label_old = label_old(1);

% Print to console
fprintf("~~~ Initial Periodic Orbit: Second Run ~~~ \n");
fprintf('Move the z value \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_HB2HB(prob, '', run_old, label_old);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Saved-point solution for z = -0.8
prob = coco_add_event(prob, 'H_PT', 'z', -0.8);

%------------------%
%     Run COCO     %
%------------------%
% Parameter range
p_range = {[-1.0, 1.0], [-4.0, 4.0]};
% Run COCO continuation
coco(prob, run_new, [], 1, {'z', 'c'}, p_range);

%-------------------------------------------------------------------------%
%%                        Hopf to Periodic Orbit                         %%
%-------------------------------------------------------------------------%
% Continue a family of periodic orbits emanating from the Hopf
% bifurcation with 'ode_HB2po'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.hopf_to_PO = 'run03_hopf_to_PO';
run_new = run_names.hopf_to_PO;
% Which run this continuation continues from
run_old = run_names.move_hopf;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'H_PT');

% Print to console
fprintf("~~~ Initial Periodic Orbit: Third Run ~~~ \n");
fprintf('Periodic orbits from Hopf bifurcation \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------%
%     Calculate Things     %
%--------------------------%
% Read previous solution
sol = ep_read_solution('', run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set PtMX steps
PtMX = 200;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% % Set step sizes
% h_size = 1e0;
% prob = coco_set(prob, 'cont', 'h_min', h_size, 'h0', h_size, 'h_max', h_size);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 50);

% Continue from Hopf bifurcation
prob = ode_HB2po(prob, '', run_old, label_old);

% Follow non trivial solutions
prob = ode_isol2ep(prob, 'x0',   funcs.field{:}, ...
                   sol.x, sol.p);

%---------------------------------%
%     Glue Segment Parameters     %
%---------------------------------%
% Glue parameters (defined in './continuation_scripts/glue_parameters.m')
prob = glue_parameters_PO(prob);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Saved point for solution
prob = coco_add_event(prob, 'PO_PT', 'c', 1.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
bd_PO = coco(prob, run_new, [], 1, {'c', 'z'}, [sol.p(1), 2.0]);

%----------------------%
%    Testing Plots     %
%----------------------%
% Solution to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'PO_PT'));
label_plot = label_plot(1);

% Create plots
plot_hopf_to_PO_solution(run_new, label_plot);

%-------------------------------------------------------------------------%
%%                   Re-Solve for Rotated Perioid Orbit                  %%
%-------------------------------------------------------------------------%
% Using previous parameters and MATLAB's ode45 function, we solve for an
% initial solution to be fed in as a periodic orbit solution.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_PO = 'run04_initial_periodic_orbit';
run_new = run_names.initial_PO;
% Which run this continuation continues from
run_old = run_names.hopf_to_PO;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');
label_old = label_old(1);

% label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
% label_old = max(label_old);

% Print to console
fprintf("~~~ Initial Periodic Orbit: Sixth Run ~~~ \n");
fprintf('Find new periodic orbit \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_soln = calculate_periodic_orbit(run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
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

% Set initial guess to 'coll'
prob = ode_isol2coll(prob, 'initial_PO', funcs.field{:}, ...
                     data_soln.t, data_soln.x, pnames, data_soln.p);

% Add equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'x0',   run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Glue parameters and apply boundary condition
prob = apply_PO_boundary_conditions(prob, bcs_funcs.bcs_PO);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Event for A = 7.5
prob = coco_add_event(prob, 'PO_PT', 'c', data_soln.p(1));

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
bd_PO = coco(prob, run_new, [], 1, {'c', 'z'}, [0.0, 2.0]);

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
run_names.compute_floquet_1 = 'run05_compute_floquet_bundle_1_mu';
run_new = run_names.compute_floquet_1;
% Which run this continuation continues from
run_old = run_names.initial_PO;

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

%------------------------------------%
%     Setup Floquet Continuation     %
%------------------------------------%
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

% Add segment as initial solution
prob = ode_isol2coll(prob, 'adjoint', funcs.floquet{:}, ...
                     data_adjoint.t0, data_adjoint.x0, ...
                     data_adjoint.pnames, data_adjoint.p0);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
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
run_names.compute_floquet_2 = 'run06_compute_floquet_bundle_2_w';
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

%------------------------------------%
%     Setup Floquet Continuation     %
%------------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set number of PtMX steps
prob = coco_set(prob, 'cont', 'PtMX', 250);

% Continue coll from previous branching point
prob = ode_BP2coll(prob, 'adjoint', run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
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