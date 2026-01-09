%=========================================================================%
%              WINFREE MODEL (FINDING PERIODIC ORBIT ode45)               %
%=========================================================================%
% Doing an example from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.

% Here we compute a periodic orbit of the Winfree model using ode45. We
% set this as an initial solution to the 'PO' toolbox to find a periodic
% orbit.
%
%  We then rotate that periodic orbit such that the first point is the
% maximum of the first state variable. We verify this solution using the
% 'COLL' toolbox.
%
% Finally, we compute the adjoint variational problem, and find the
% left eigenvector corresponding to the stable Floquet eigenvalue. We
% continue in \mu_{s} until \mu_{s} = 1.0. We then switch branches to
% grow the norm of the left eigenvector until wnorm = 1.0.

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

%----------------------------------------------%
%     Functions Lists: Boundary Conditions     %
%----------------------------------------------%
% Boundary conditions: Periodic orbit
% bcs_funcs.bcs_PO = {@bcs_PO};
bcs_funcs.bcs_PO = bcs_PO_symbolic();

% Boundary conditions: Floquet multipliers
% bcs_funcs.bcs_VAR = {@bcs_VAR};
bcs_funcs.bcs_VAR = bcs_VAR_symbolic();

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
run_names.initial_PO_ODE45 = 'run01_initial_PO_ODE45';
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
run_names.initial_PO_COLL = 'run02_initial_PO_COLL';
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
%                               END OF FILE                               %
%=========================================================================%
