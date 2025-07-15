%=========================================================================%
%                   YAMADA MODEL (Stable Manifold of q)                   %
%=========================================================================%
% We compute the stable manifold of the stable periodic orbit in Region 7,
% where there exists a stable/attracting periodic orbit. The Yamada mode
% equations are
%                     G' = Gamma (A - G - G I) ,
%                     Q' = Gamma (B - Q - a Q I) ,
%                     I' = (G - Q - 1) I ,
% where G is the gain, Q is the absorption, and I is the intensity of the
% laser. The system is dependent on four parameters: the pump current on
% the gain, A (or A); the relative absoprtion, B and a; and the decay
% time of the gain, Gamma.

% Clear plots
close('all');

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');
% Add field functions to path
% addpath('./functions/fields/hardcoded/');
addpath('./functions/fields/');
% Add boundary condition functions to path
% addpath('./functions/bcs/hardcoded/');
addpath('./functions/bcs/');
% Add SymCOCO files to path
addpath('./functions/symcoco/');

% Add continuations script functions to path
addpath('./continuation_scripts/');

% Add plotting scripts
addpath('./plotting_scripts/');

%--------------------%
%     Parameters     %
%--------------------%
% Because we will only be looking at the (A, Gamma) plane, we will be
% setting values for a and B.
B = 5.8;
a = 1.8;

% Parameters for the periodic orbit
gamma_PO = 3.5e-2;
A_PO     = 7.4;

%-----------------------%
%     Problem Setup     %
%-----------------------%
% Parameter names
pnames = {'gamma', 'A', 'B', 'a'};

% Initial parameter values
p0 = [gamma_PO; A_PO; B; a];

% Initial point
x0 = [10; 10; 10];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Yamada model equations
% funcs.field = {@yamada, @yamada_DFDX, @yamada_DFDP};
funcs.field = yamada_symbolic();

% Boundary conditions: Eigenvalues and eigenvectors
bcs_funcs.bcs_eig = {@bcs_eig_PO};

% Boundary conditions: Initial condition
bcs_funcs.bcs_initial = {@bcs_W_PO_initial};

% Boundary conditions: Final condition
bcs_funcs.bcs_final = {@bcs_W_PO_final};

%=========================================================================%
%%                   CALCULATE INITIAL PERIODIC ORBIT                    %%
%=========================================================================%
% Using ODE45, we compute a guess solution to a stable periodic orbit. We
% then feed this as an initial solution to the 'PO' toolbox. Finally, we
% "rotate" the head-point and use this to confirm a solution of a periodic
% orbit, where the first point corresponds to max(G).

%-------------------------------------------------------------------------%
%%                 Confirm ODE45 Periodic Orbit Solution                 %%
%-------------------------------------------------------------------------%
% Calculate the periodic orbit using MATLAB's ode45 function.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_PO_ode45 = 'run01_initial_PO_ode45';
run_new = run_names.initial_PO_ode45;

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initial Periodic Orbit: First Run\n');
fprintf(' Find new periodic orbit\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Continuation parameters : %s\n', 'A, gamma');
fprintf(' =====================================================================\n');

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_ode45 = calc_initial_solution_ODE45(x0, p0, funcs.field);

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

% Turn off bifurcation
prob = coco_set(prob, 'po', 'bifus', false);

% Set initial guess to 'coll'
prob = ode_isol2po(prob, 'PO_stable', funcs.field{:}, ...
                   data_ode45.t, data_ode45.x, pnames, p0, ...
                   '-var', eye(xdim));

% Add equilibrium points for non trivial steady states
prob = ode_isol2ep(prob, 'xpos', funcs.field{:}, ...
                   data_ode45.xpos, p0);
prob = ode_isol2ep(prob, 'xneg', funcs.field{:}, ...
                   data_ode45.xneg, p0);
prob = ode_isol2ep(prob, 'x0', funcs.field{:}, ...
                   data_ode45.x0, p0);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Glue parameters and apply boundary condition
prob = glue_parameters_PO(prob, true);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
prob = coco_add_event(prob, 'PO_PT', 'A', A_PO);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'A', 'gamma'});

%=========================================================================%
%            CALCULATE STABLE MANIFOLD OF SADDLE PERIODIC ORBIT           %
%=========================================================================%
% We compute the stable manifold of the saddle q in forward and backwards
% directions, based on original solution data from
% ./data_mat/initial_PO.mat'.

%-------------------------------------------------------------------------%
%%                 Calculate Stable Manifold Segments - 1                %%
%-------------------------------------------------------------------------%
% Using previous parameters and sasved solutions, we compute the stable and
% saddle periodic orbits, the three stationary points, and two separate
% segments for the stable manifold of the periodic orbit.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.stable_manifold1 = 'run02_Ws_PO';
run_new = run_names.stable_manifold1;
% Which run this continuation continues from
run_old = run_names.initial_PO_ode45;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Stable Manifold of Gamma: First Run\n');
fprintf(' Calculate one of the stable-manifold branches \n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'W_seg1, T1, W_seg2');
fprintf(' =====================================================================\n');

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_isol = calc_initial_solution_WS_PO(run_old, label_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdpat
% prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set step size
% prob = coco_set(prob, 'cont', 'h_min', 5e-2);
% prob = coco_set(prob, 'cont', 'h0', 5e-1);
% prob = coco_set(prob, 'cont', 'h_max', 1e0);

% Set PtMX steps
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 50);

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

% Turn off PO toolbox bifurcation detection (only way to get -var to work)
prob = coco_set(prob, 'po', 'bifus', false);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Continue periodic orbits
prob = ode_po2po(prob, 'PO_stable', run_old, label_old, ...
                 '-var', eye(xdim));

% Add collocation trajectory segment for stable manifold
prob = ode_isol2coll(prob, 'W1', funcs.field{:}, ...
                     data_isol.t0, data_isol.x_init_1, data_isol.p);
prob = ode_isol2coll(prob, 'W2', funcs.field{:}, ...
                     data_isol.t0, data_isol.x_init_2, data_isol.p);

% Continue equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'xpos', run_old, label_old);
prob = ode_ep2ep(prob, 'xneg', run_old, label_old);
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Glue parameters and apply boundary condition
prob = apply_boundary_conditions_W_PO(prob, bcs_funcs, data_isol.eps, data_isol.vec_s, data_isol.lam_s);

%------------------------%
%     Add COCO Event     %
%------------------------%
prob = coco_add_event(prob, 'Del1', 'W_seg1', 0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
prange = {[-50, 0], [-2e-4, 1e4], []};
coco(prob, run_new, [], 1, {'W_seg1', 'T1', 'W_seg2'}, prange);

%----------------------%
%    Testing Plots     %
%----------------------%
% Solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Del1');
% label_plot = 11;

% Plot solution
plot_orbit_and_W_PO_solution(run_new, label_plot);

%-------------------------------------------------------------------------%
%%                 Calculate Stable Manifold Segments - 2                %%
%-------------------------------------------------------------------------%
% Continuing from the previous solution where the W1 manifold segment was
% computed up to some boundary plane, we compute the W2 manifold segment.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.stable_manifold2 = 'run03_stable_manifold_seg2';
run_new = run_names.stable_manifold2;
run_old = run_names.stable_manifold1;

% Previous solution label
label_old = coco_bd_labs(coco_bd_read(run_old), 'Del1');

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Stable Manifold of Gamma: Second Run\n');
fprintf(' Calculate one of the stable-manifold branches \n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'W_seg2, T2, W_seg1');
fprintf(' =====================================================================\n');

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% % Set step size
% prob = coco_set(prob, 'cont', 'h_min', 1e-2);
% prob = coco_set(prob, 'cont', 'h', 5e-2);
% prob = coco_set(prob, 'cont', 'h_max', 1e-1);


% Set PtMX steps
PtMX = 200;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 10);

% Turn off PO toolbox bifurcation detection (only way to get -var to work)
prob = coco_set(prob, 'po', 'bifus', false);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Continue periodic orbits
prob = ode_po2po(prob, 'PO_stable', run_old, label_old, ...
                 '-var', eye(xdim));

% Add collocation trajectory segment for stable manifold
prob = ode_coll2coll(prob, 'W1', run_old, label_old);
prob = ode_coll2coll(prob, 'W2', run_old, label_old);

% Continue equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'xpos', run_old, label_old);
prob = ode_ep2ep(prob, 'xneg', run_old, label_old);
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab the epsilong value
[data, chart] = coco_read_solution('bcs_final', run_old, label_old);
eps = chart.x(data.eps_idx);

% Grab the Floquet eigenvector and eigenvalue
[data, chart] = coco_read_solution('bcs_eig', run_old, label_old);
vec_s = chart.x(data.vec_floquet_idx);
lam_s = chart.x(data.lam_floquet_idx);

% Glue parameters and apply boundary condition
prob = apply_boundary_conditions_W_PO(prob, bcs_funcs, eps, vec_s, lam_s);

%------------------------%
%     Add COCO Event     %
%------------------------%
prob = coco_add_event(prob, 'Del2', 'W_seg2', 0.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
prange = {[0, 10], [0.0, 1e3], []};
coco(prob, run_new, [], 1, {'W_seg2', 'T2', 'T1'}, prange);

%----------------------%
%    Testing Plots     %
%----------------------%
% Solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Del2');

% Plot solution
plot_orbit_and_W_PO_solution(run_new, label_plot);

%-------------------------------------------------------------------------%
%%                     Sweep Out From Periodic Orbit                     %%
%-------------------------------------------------------------------------%
% We now sweep through values of epsilon (eps), moving closer to and
% further away form the periodic orbit. 

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.stable_manifold3 = 'run04_stable_manifold_whanau';
run_new = run_names.stable_manifold3;
run_old = run_names.stable_manifold2;

% Previous solution label
label_old = coco_bd_labs(coco_bd_read(run_old), 'Del2');

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Stable Manifold of Gamma: Third Run\n');
fprintf(' Close the initial distance eps\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'eps, T1, T2');
fprintf(' =====================================================================\n');

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 150);

% Set NAdpat
% prob = coco_set(prob, 'cont', 'NAdapt', 5);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set step size
% prob = coco_set(prob, 'cont', 'h_min', 1e-2);
% prob = coco_set(prob, 'cont', 'h', 5e-2);
% prob = coco_set(prob, 'cont', 'h_max', 1e-1);

% Set PtMX steps
PtMX = 400;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 10);

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

% Turn off PO toolbox bifurcation detection (only way to get -var to work)
prob = coco_set(prob, 'po', 'bifus', false);

% Continue periodic orbits
prob = ode_po2po(prob, 'PO_stable', run_old, label_old, ...
                 '-var', eye(xdim));

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Add collocation trajectory segment for stable manifold
prob = ode_coll2coll(prob, 'W1', run_old, label_old);
prob = ode_coll2coll(prob, 'W2', run_old, label_old);

% Continue equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'xpos', run_old, label_old);
prob = ode_ep2ep(prob, 'xneg', run_old, label_old);
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Grab the epsilong value
[data, chart] = coco_read_solution('bcs_final', run_old, label_old);
eps = chart.x(data.eps_idx);

% Grab the Floquet eigenvector and eigenvalue
[data, chart] = coco_read_solution('bcs_eig', run_old, label_old);
vec_s = chart.x(data.vec_floquet_idx);
lam_s = chart.x(data.lam_floquet_idx);

% Glue parameters and apply boundary condition
prob = apply_boundary_conditions_W_PO(prob, bcs_funcs, eps, vec_s, lam_s);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
prange = {[1e-10, eps], [], []};
coco(prob, run_new, [], 1, {'eps', 'T1', 'T2'}, prange);

%----------------------%
%    Testing Plots     %
%----------------------%
% Solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EP');
label_plot = max(label_plot);
% label_plot = 12;

% Plot singlesolution
plot_orbit_and_W_PO_solution(run_new, label_plot);
% Plot solution scan
plot_solutions_scan(run_new);

%=========================================================================%
%                               END OF FILE                               %
%=========================================================================%