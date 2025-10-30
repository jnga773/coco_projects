%=========================================================================%
%                FITZ-HUGH-NAGUMO (FINDING PERIODIC ORBIT)                %
%=========================================================================%
% Doing an example from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.
%
% Here we compute a periodic orbit of the FitzHugh-Nagumo model via
% continuation of Hopf bifurcations.
%
% We start from a known equilibrium point, and continue it in one
% parameter until we find a Hopf bifurcation.
%
% We then continue the Hopf bifurcation in c until z = -0.8.
%
% From here, we compute a family of periodic orbits emanating from the
% Hopf bifurcation, picking a solution were c = 1.0.
%
% We then rotate that periodic orbit such that the first point is the
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
% Add SymCOCO files to path
addpath('./functions/symcoco/');

% Add continuation scripts
addpath('./continuation_scripts/');
% Add plotting scripts
addpath('./plotting_scripts/initial_PO/');

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

%----------------------------------------%
%     Functions Lists: Vector Fields     %
%----------------------------------------%
% Vector field: Functions
% funcs.field = {@fhn, @fhn_DFDX, @fhn_DFDP};
funcs.field = fhn_symbolic();

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
fprintf(' Initial Periodic Orbit: First Run\n');
fprintf(' Initial continuation from equilibrium point x0\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Continuation parameters : %s\n', 'c');
fprintf(' =====================================================================\n');

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

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initial Periodic Orbit: Second Run\n');
fprintf(' Move the z value\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'z, c');
fprintf(' =====================================================================\n');

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

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initial Periodic Orbit: Third Run\n');
fprintf(' Periodic orbits from Hopf bifurcation\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'c, z');
fprintf(' =====================================================================\n');

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
coco(prob, run_new, [], 1, {'c', 'z'}, [sol.p(1), 2.0]);

%-------------------------------------------------------------------------%
%%                   Re-Solve for Rotated Perioid Orbit                  %%
%-------------------------------------------------------------------------%
% Using previous parameters and MATLAB's ode45 function, we solve for an
% initial solution to be fed in as a periodic orbit solution.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_PO_COLL = 'run04_initial_PO_COLL';
run_new = run_names.initial_PO_COLL;
% Which run this continuation continues from
run_old = run_names.hopf_to_PO;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initial Periodic Orbit: Fourth Run\n');
fprintf(' Rotate periodic orbit\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'z, c');
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
% prob = coco_add_event(prob, 'PO_PT', 'c', 0.0);
prob = coco_add_event(prob, 'PO_PT', 'z', -0.8);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'z', 'c'});

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