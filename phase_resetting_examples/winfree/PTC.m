%=========================================================================%
%                 WINFREE MODEL (PHASE TRANSITION CURVES)                 %
%=========================================================================%
% Doing an exmaple from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.
%
% Initial Periodic Orbit
% ----------------------
% We first compute a periodic orbit for a set of parameters via numerical
% integration with ode45. We set this as an initial solution to the 'PO'
% toolbox to verify a periodic orbit.
%
% We then rotate that periodic orbit such that the first point is the
% maximum of the first state variable. We verify this solution using the
% 'COLL' toolbox.
%
% Floquet Bundle
% --------------
% We then compute the adjoint variational problem, and find the
% left eigenvector corresponding to the stable Floquet eigenvalue. We
% continue in the eigenvalue \mu_{s} until \mu_{s} = 1.0.
% 
% We then switch branches to grow the norm of the left eigenvector
% until wnorm = 1.0.
%
% Phase Transition Curve
% ----------------------
% We then setup the phase resetting problem to calculate some PTCs. The
% phase resetting problem is split into four segments and an equilibrium
% point. The initial solution to each of these segments, as well as the
% initial phase resetting parameters, are set in the
% 'calc_initial_solution_PR' function. All of the boundary conditions
% are applied in the 'apply_boundary_conditions_PR' function.
%
% The number of free parameters is set to four, however two of these
% must always be eta and mu_s, i.e., the distance of the reset perturbed
% orbit from \Gamma and the stable eigenvalue. That then leaves two other
% parameters to continue in.
%
% In the first continuation, we start with a solution at the zero-phase
% point along \Gamma. We then continue in the perturbation amplitude
% A_perturb and the reset phase theta_new. We save some solution points
% as 'SP' to then calculate PTCs later.
%
% We then compute a single PTC, by continuing in the two phases
% theta_old and theta_new. To save space, the continuation problem
% is setup in the 'run_PR_continuation' function.
%
% Finally, we compute a set of PTCs for each saved perturbation
% amplitude. We make use of MATLAB's parallel computer parfor to
% run these computations in parallel.

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

% Add continuation scripts
addpath('./continuation_scripts/');
% Add plotting scripts
addpath('./plotting_scripts/');

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

%----------------------------------------%
%     Functions Lists: Vector Fields     %
%----------------------------------------%
% Vector field: Functions
% funcs.field = {@winfree, @winfree_DFDX, @winfree_DFDP};
funcs.field = winfree_symbolic();

% Adjoint equations: Functions (for floquet_mu and floquet_wnorm)
% funcs.VAR = {@VAR};
funcs.VAR = VAR_symbolic();

% Phase Reset Segment 1: Functions
% funcs.seg1 = {@func_seg1};
funcs.seg1 = func_seg1_symbolic();

% Phase Reset: Segment 2
% funcs.seg2 = {@func_seg2};
funcs.seg2 = func_seg2_symbolic();

% Phase Reset: Segment 3
% funcs.seg3 = {@func_seg3};
funcs.seg3 = func_seg3_symbolic();

% Phase Reset: Segment 4
% funcs.seg4 = {@func_seg4};
funcs.seg4 = func_seg4_symbolic();

%----------------------------------------------%
%     Functions Lists: Boundary Conditions     %
%----------------------------------------------%
% Boundary conditions: Periodic orbit
% bcs_funcs.bcs_PO = {@bcs_PO};
bcs_funcs.bcs_PO = bcs_PO_symbolic();

% Boundary conditions: Floquet multipliers
% bcs_funcs.bcs_VAR = {@bcs_VAR};
bcs_funcs.bcs_VAR = bcs_VAR_symbolic();

% Boundary conditions: Segment period
% bcs_funcs.bcs_T = {@bcs_T};
bcs_funcs.bcs_T = bcs_T_symbolic();

% Boundary conditions: Phase-resetting segments
% bcs_funcs.bcs_PR = {@bcs_PR};
bcs_funcs.bcs_PR = bcs_PR_symbolic();

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
run_names.initial_PO_ODE45 = 'run01_initial_PO';
run_new = run_names.initial_PO_ODE45;

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initial Periodic Orbit: First Run\n');
fprintf(' Find new periodic orbit\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Continuation parameters : %s\n', 'a, omega');
fprintf(' =====================================================================\n');

%------------------------------------%
%     Calculate Initial Solution     %
%------------------------------------%
data_ode45 = calc_initial_solution_ODE45([10; 10], p0, funcs.field);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% The value of 10 for 'NAdapt' implied that the trajectory discretisation
% is changed adaptively ten times before the solution is accepted.
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
                   data_ode45.t, data_ode45.x, pnames, p0);

% Add equilibrium points for non trivial steady states
prob = ode_isol2ep(prob, 'x0', funcs.field{1}, ...
                   data_ode45.x0, p0);

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
run_old = run_names.initial_PO_ODE45;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initial Periodic Orbit: Second Run\n');
fprintf(' Rotate periodic orbit\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'a, omega');
fprintf(' =====================================================================\n');

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_PO = calc_initial_solution_PO(run_old, label_old);

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
                     data_PO.t, data_PO.x, data_PO.pnames, data_PO.p);

% Add equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Glue parameters and apply boundary condition
prob = apply_boundary_conditions_PO(prob, bcs_funcs.bcs_PO);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Event for a = 0.0
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

% Plot solution
plot_initial_PO(run_new, label_plot);

%=========================================================================%
%%               Compute Floquet Bundle at Zero Phase Point              %%
%=========================================================================%
% We now add the adjoint function and Floquet boundary conditions to
% compute the adjoint (left or right idk) eigenvectors and eigenvalues.
% This will give us the perpendicular vector to the tangent of the periodic
% orbit. However, this will only be for the eigenvector corresponding to
% the eigenvalue \mu = 1.

%-------------------------------------------------------------------------%
%%                     Compute Stable Eigenvalue 1.0                     %%
%-------------------------------------------------------------------------%
% Starting from an initial zero vector, we continue in mu until the stable
% eigenvalue is 1.0

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.VAR_mu = 'run03_VAR_mu';
run_new = run_names.VAR_mu;
% Which run this continuation continues from
run_old = run_names.initial_PO_COLL;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Floquet Bundle: First Run\n');
fprintf(' Calculate stable Floquet bundle eigenvalue\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'mu_s, w_norm');
fprintf(' =====================================================================\n');

%--------------------------%
%     Calculate Things     %
%--------------------------%
data_VAR = calc_initial_solution_VAR(run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 1e-2);
prob = coco_set(prob, 'cont', 'h0', 1e-2);
prob = coco_set(prob, 'cont', 'h_max', 1e-2);

% Set PtMX
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Set NTST
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdapt
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', 'off');

% Add segment as initial solution
prob = ode_isol2coll(prob, 'VAR', funcs.VAR{:}, ...
                     data_VAR.tbp_init, data_VAR.xbp_init, ...
                     data_VAR.pnames, data_VAR.p0);

% Add equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply boundary conditions
prob = apply_boundary_conditions_VAR(prob, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Add event
prob = coco_add_event(prob, 'mu=1', 'mu_s', 1.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'mu_s', 'w_norm'}, {[0.0, 1.1], []});

%-------------------------------------------------------------------------%
%%                  Grow Orthogonal Stable Eigenvector                   %%
%-------------------------------------------------------------------------%
% Having found the solution (branching point 'BP') corresponding to
% \mu = 1, we can continue in the norm of the vector w (w_norm), until the
% norm is equal to zero. Then we will have the correct perpendicular
% vector.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.VAR_wnorm = 'run04_VAR_wnorm';
run_new = run_names.VAR_wnorm;
% Which run this continuation continues from
run_old = run_names.VAR_mu;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Floquet Bundle: Second Run\n');
fprintf(' Grow norm of stable Floquet bundle vector\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'mu_s, w_norm');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set number of PtMX steps
prob = coco_set(prob, 'cont', 'PtMX', 250);

% Continue coll from previous branching point
% prob = ode_BP2coll(prob, 'VAR', run_old, label_old);
prob = ode_coll2coll(prob, 'VAR', run_old, label_old);
prob = coco_set(prob, 'cont', 'branch', 'switch');

% Add equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply boundary conditions
prob = apply_boundary_conditions_VAR(prob, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Add event when w_norm = 1
prob = coco_add_event(prob, 'NORM1', 'w_norm', 1.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'mu_s', 'w_norm'}, {[0.0, 1.1], [0.0, 1.1]});

%=========================================================================%
%%                   CALCULATE PHASE RESET SOLUTIONS                     %%
%=========================================================================%
% We compute a set of phase reset problems. We first continue in the
% parameter 'A_perturb', that is, the amplitude of the perturbation.
% After this, we then compute some phase transition curves (PTCs), by
% continuing in 'theta_old' and 'theta_new'.

%-------------------------------------------------------------------------%
%%                   Increasing Pertubation Amplitude                    %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.PTC_perturbation = 'run05_PTC_perturbation';
run_new = run_names.PTC_perturbation;
% Which run this continuation continues from
run_old = run_names.VAR_wnorm;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'NORM1');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Phase Transition Curve: First Run\n');
fprintf(' Increase perturbation amplitude\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'A_perturb, theta_new, eta, mu_s, T_PO');
fprintf(' =====================================================================\n');

%-------------------%
%     Read Data     %
%-------------------%
% Set periodicity
k = 5;
% Set perturbation direction (in units of 2 \pi)
theta_perturb = 0.5;

% Set initial conditions from previous solutions
data_PR = calc_initial_solution_PR(run_old, label_old, k, theta_perturb);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 1e-3);
% prob = coco_set(prob, 'cont', 'h0', 1e-2);
% prob = coco_set(prob, 'cont', 'h_max', 1e0);

% Set adaptive mesh
prob = coco_set(prob, 'cont', 'NAdapt', 10);

% Set number of steps
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Set number of stored solutions
% prob = coco_set(prob, 'cont', 'NPR', 100);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', 'off');

% Set norm to int
prob = coco_set(prob, 'cont', 'norm', inf);

% % Set MaxRes and al_max
prob = coco_set(prob, 'cont', 'MaxRes', 10);
prob = coco_set(prob, 'cont', 'al_max', 25);

%------------------%
%     Set NTST     %
%------------------%
% In calc_PR_initial conditions, we define segment 4 as having 'k' periods,
% where 'k' is an integer. This is the perturbed segment, that may have to
% orbit the unperturbed periodic orbit many times before "resetting". Hence
% we have set the NTST for this segment (NTST(4)) as k * 50.
NTST(1) = 50;
NTST(2) = 50;
NTST(3) = 50;
NTST(4) = 50 * k;

prob = coco_set(prob, 'seg1.coll', 'NTST', NTST(1));
prob = coco_set(prob, 'seg2.coll', 'NTST', NTST(2));
prob = coco_set(prob, 'seg3.coll', 'NTST', NTST(3));
prob = coco_set(prob, 'seg4.coll', 'NTST', NTST(4));

%------------------------------------%
%     Create Trajectory Segments     %
%------------------------------------%
% Here we set up the four segments to calculate the phase resetting curve:
% Segment 1 - Trajectory segment of the periodic orbit from the zero-phase
%             point (gamma_0) to the point where the perturbed trajectory 
%             comes close to the periodic orbit (at theta_new).
prob = ode_isol2coll(prob, 'seg1', funcs.seg1{:}, ...
                     data_PR.t_seg1, data_PR.x_seg1, data_PR.pnames, data_PR.p0);

% Segment 2 - Trajectory segment of the periodic from the end of Segment 1
%             (at theta_new) back to the zero-phase point (gamma_0).
prob = ode_isol2coll(prob, 'seg2', funcs.seg2{:}, ...
                     data_PR.t_seg2, data_PR.x_seg2, data_PR.p0);

% Segment 3 - Trajectory segment of the periodic orbit from the zero-phase
%             point (gamma_0) to the point at which the perturbation is
%             applied (theta_old).
prob = ode_isol2coll(prob, 'seg3', funcs.seg3{:}, ...
                     data_PR.t_seg3, data_PR.x_seg3, data_PR.p0);   

% Segment 4 - Trajectory segment of the perturbed trajectory, from
%             theta_old to theta_new.
prob = ode_isol2coll(prob, 'seg4', funcs.seg4{:}, ...
                     data_PR.t_seg4, data_PR.x_seg4, data_PR.p0);

%------------------------------------%
%     Continue Equilibrium Point     %
%------------------------------------%
% Continue equilibrium point from previous solution
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply all boundary conditions, glue parameters together, and
% all that other good COCO stuff. Looking the function file
% if you need to know more ;)
prob = apply_boundary_conditions_PR(prob, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Array of values for special event
SP_values = [0.0; 0.4; 0.75];

% When the parameter we want (from param) equals a value in A_vec
prob = coco_add_event(prob, 'SP', 'A_perturb', SP_values);

%------------------%
%     Run COCO     %
%------------------%
% Set continuation parameters and parameter range
pcont  = {'A_perturb', 'theta_new', ...
          'eta', 'mu_s', 'T_PO'};
prange = {[-1e-4, max(SP_values)+0.1], [], ...
          [-1e-4, 1e-2], [0.99, 1.01], []};

% Run COCO
coco(prob, run_new, [], 1, pcont, prange);

%--------------------%
%     Test Plots     %
%--------------------%
% Label of solution to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'SP'));
label_plot = label_plot(end);

% Plot some stuff my g
plot_PR_phase_space(run_new, label_plot);

% % Plot perturbation amplitude against theta_new
plot_langfield_four_figure(run_new);
% % plot_A_perturb_theta_new(run_new);

%-------------------------------------------------------------------------%
%%                 Phase Transition Curve (PTC) - Single                 %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.PTC_single = 'run06_PTC_single';
run_new = run_names.PTC_single;
% Which run this continuation continues from
run_old = run_names.PTC_perturbation;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'SP');
label_old = label_old(end);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Phase Transition Curve: Second Run\n');
fprintf(' Calculate PTC (single)\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'theta_old, theta_new, eta, mu_s, T_PO');
fprintf(' =====================================================================\n');

%------------------%
%     Run COCO     %
%------------------%
% Set continuation parameters and parameter range
pcont  = {'theta_old', 'theta_new', ...
          'eta', 'mu_s', 'T_PO'};
prange = {[0.0, 2.0], [], ...
          [-1e-4, 1e-2], [0.99, 1.01], []};

% Run COCO continuation
run_PR_continuation(run_new, run_old, label_old, bcs_funcs, pcont, prange);

%--------------------%
%     Test Plots     %
%--------------------%
% Plot first SP solution
plot_PR_phase_space(run_new, 2);

% Plot phase transition curve (PTC)
plot_PTC_single(run_new);

%-------------------------------------------------------------------------%
%%                Phase Transition Curve (PTC) - Multiple                %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.PTC_scan = 'run07_PTC_scan';
run_new = run_names.PTC_scan;
% Which run this continuation continues from
run_old = run_names.PTC_perturbation;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'SP');

%---------------------------------%
%     Cycle through SP labels     %
%---------------------------------%
% Set number of threads
M = 0;
parfor (run = 1 : length(label_old), M)
  % Label for this run
  this_run_label = label_old(run);

  % Data directory for this run
  this_run_name = {run_new; sprintf('run_%02d', run)};

  %--------------------------%
  %     Print to Console     %
  %--------------------------%
  fprintf(' =====================================================================\n');
  fprintf(' Phase Transition Curve: Second Run\n');
  fprintf(' Calculate PTC (scan)\n');
  fprintf(' ---------------------------------------------------------------------\n');
  fprintf(' This run name           : {%s, %s}\n', this_run_name{1}, this_run_name{2});
  fprintf(' Previous run name       : %s\n', run_old);
  fprintf(' Previous solution label : %d\n', this_run_label);
  fprintf(' Continuation parameters : %s\n', 'theta_old, theta_new, eta, mu_s, T_PO');
  fprintf(' =====================================================================\n');
  
  %------------------%
  %     Run COCO     %
  %------------------%
  % Set continuation parameters and parameter range
  pcont  = {'theta_old', 'theta_new', ...
            'eta', 'mu_s', 'T_PO'};
  prange = {[0.0, 2.0], [], ...
            [-1e-4, 1e-2], [0.99, 1.01], []};

  % Run COCO continuation
  run_PR_continuation(this_run_name, run_old, this_run_label, bcs_funcs, ...
                      pcont, prange);

end

%--------------------%
%     Test Plots     %
%--------------------%
% Plot PTC plane in A_perturb
% plot_PTC_plane_A_perturb(run_new);

% Save PTC scan data
% save_data_PTC_scan(run_new, './data_mat/PTC_scan_data.mat');

%=========================================================================%
%                               END OF FILE                               %
%=========================================================================%