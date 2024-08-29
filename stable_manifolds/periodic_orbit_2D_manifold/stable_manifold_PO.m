%=========================================================================%
%                   YAMADA MODEL (Stable Manifold of q)                   %
%=========================================================================%
% We compute the stable manifold of the stable periodic orbit in Region 7,
% where there exists a stable/attracting periodic orbit. The Yamada mode
% equations are
%                     G' = \gamma (A - G - G I) ,
%                     Q' = \gamma (B - Q - a Q I) ,
%                     I' = (G - Q - 1) I ,
% where G is the gain, Q is the absorption, and I is the intensity of the
% laser. The system is dependent on four parameters: the pump current on
% the gain, A (or A); the relative absoprtion, B and a; and the decay
% time of the gain, \gamma.

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
addpath('./continuation_scripts/initial_PO/');
addpath('./continuation_scripts/stable_manifold_PO/');

% Add plotting scripts
addpath('./plotting_scripts/initial_PO/');
addpath('./plotting_scripts/stable_manifold_PO/');

%--------------------%
%     Parameters     %
%--------------------%
% Because we will only be looking at the (A, \gamma) plane, we will be
% setting values for a and B.
B = 5.8;
a = 1.8;

% Set some initial values for \gamma and A
gamma = 0.10;
A = 6.6;

%-----------------------%
%     Problem Setup     %
%-----------------------%
% Parameter names
pnames = {'gamma', 'A', 'B', 'a'};

% Initial parameter values
p0 = [gamma; A; B; a];

% Initial state values
x0 = [A; B; 0];

% Parameter ranges
gamma_range = [0.0, 0.25];
A_range = [5.0, 11.0];
p_range = {A_range, gamma_range};

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
bcs_funcs.bcs_eig = {@bcs_eig};

% Boundary conditions: Initial condition
bcs_funcs.bcs_initial = {@bcs_W_PO_initial};

% Boundary conditions: Final condition
bcs_funcs.bcs_final = {@bcs_W_PO_final};

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

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
prob = coco_set(prob, 'cont', 'PtMX', 50);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up isol2ep problem
prob = ode_isol2ep(prob, '', funcs.field{:}, x0, pnames, p0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'A', A_range);

%-------------------------------------------------------------------------%
%%                   Continuation from Branching Point                   %%
%-------------------------------------------------------------------------%
% We switch branches at the BP point to find the Hopf bifurcations.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.branching_point = 'run02_branching_point_continuation';
run_new = run_names.branching_point;
% Previous run name
run_old = run_names.initial_EP;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

% Print to console
fprintf('~~~ Initial Periodic Orbit: Second run ~~~\n');
fprintf('Continue bifurcations from the branching point\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set upper bound of continuation steps in each direction along solution
PtMX = 50;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Continue from branching point
prob = ode_BP2ep(prob, '', run_old, label_old);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'A', A_range);

%-------------------------------------------------------------------------%
%%                           Move Hopf A Value                           %%
%-------------------------------------------------------------------------%
% Continuing from a Hopf bifurcation with 'ode_HB2HB', we vary
% the 'A' parameter to A = 7.3757

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.move_hopf = 'run03_move_hopf';
run_new = run_names.move_hopf;
% Which run this continuation continues from
run_old = run_names.branching_point;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

% Print to console
fprintf("~~~ Initial Periodic Orbit: Third Run ~~~ \n");
fprintf('Move the gamma value \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 5e-2, 'h0', 5e-2, 'h_max', 5e-2);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 10);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_HB2HB(prob, '', run_old, label_old);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Saved-point solution for A = 7.3757
prob = coco_add_event(prob, 'H_PT', 'A', 7.3757);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'A', 'gamma'}, A_range);

%-------------------------------------------------------------------------%
%%                        Hopf to Periodic Orbit                         %%
%-------------------------------------------------------------------------%
% Continue a family of periodic orbits emanating from the Hopf
% bifurcation with 'ode_HB2po'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.hopf_to_PO = 'run05_hopf_to_PO';
run_new = run_names.hopf_to_PO;
% Which run this continuation continues from
run_old = run_names.move_hopf;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'H_PT');

% Print to console
fprintf("~~~ Initial Periodic Orbit: Fifth Run ~~~ \n");
fprintf('Periodic orbits from Hopf bifurcation \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------%
%     Calculate Things     %
%--------------------------%
% Read previous solution
sol = ep_read_solution('', run_old, label_old);

% Calculate non-trivial solutions
[xpos, xneg] = non_trivial_ss(sol.p);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set norm
prob = coco_set(prob, 'cont', 'norm', inf);

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 5e-2);
prob = coco_set(prob, 'cont', 'h0', 5e-1);
prob = coco_set(prob, 'cont', 'h_max', 1e0);

% Set PtMX steps
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 25);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Turn off PO toolbox bifurcation detection (only way to get -var to work)
prob = coco_set(prob, 'po', 'bifus', false);

% Continue from Hopf bifurcation
prob = ode_HB2po(prob, '', run_old, label_old, ...
                 '-var', eye(3));

% Follow non trivial solutions
prob = ode_isol2ep(prob, 'xpos', funcs.field{:}, ...
                   xpos, sol.p);
prob = ode_isol2ep(prob, 'xneg', funcs.field{:}, ...
                   xneg, sol.p);
prob = ode_isol2ep(prob, 'x0',   funcs.field{:}, ...
                   x0,   sol.p);

% Glue parameters of each continuation problem
prob = glue_parameters_PO(prob);

%------------------------%
%     Add COCO Event     %
%------------------------%
% Saved point for solution for gamma = 3.54e-2
prob = coco_add_event(prob, 'PO_PT', 'gamma', 3.54e-2);

%------------------%
%     Run COCO     %
%------------------%
% Read previous gamme value
sol = ep_read_solution('', run_old, label_old);
% Parameter range
p_range = {[3.5e-2, 1.01*sol.p(1)], []};

% Run COCO continuation
bd = coco(prob, run_new, [], 1, {'gamma', 'A'}, p_range);

%----------------------%
%    Testing Plots     %
%----------------------%
% Solution to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'PO_PT'));
label_plot = label_plot(1);

% Create plots
plot_hopf_to_PO_solution(run_new, label_plot);

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
run_names.stable_manifold1 = 'run06_Ws_PO';
run_new = run_names.stable_manifold1;
% Which run this continuation continues from
run_old = run_names.hopf_to_PO;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');

% Print to console
fprintf("~~~ Stable Manifold (PO): First Run ~~~ \n");
fprintf('Calculate one of the stable-manifold branches \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_isol = calc_stable_W_PO_initial_solution(run_old, label_old);

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
prob = ode_isol2po(prob, 'PO_stable', funcs.field{:}, ...
                   data_isol.tbp_PO, data_isol.xbp_PO, ...
                   data_isol.pnames, data_isol.p, ...
                   '-var', eye(3));

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
prob = apply_W_PO_conditions(prob, bcs_funcs, data_isol.eps, data_isol.vec_s, data_isol.lam_s);

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
run_names.stable_manifold2 = 'run07_stable_manifold_seg2';
run_new = run_names.stable_manifold2;
run_old = run_names.stable_manifold1;

% Previous solution label
label_old = coco_bd_labs(coco_bd_read(run_old), 'Del1');

% Print to console
fprintf("~~~ Stable Manifold (q): Second Run ~~~ \n");
fprintf('Calculate one of the stable-manifold branches \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

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
                 '-var', eye(3));

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
prob = apply_W_PO_conditions(prob, bcs_funcs, eps, vec_s, lam_s);

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
run_names.stable_manifold3 = 'run08_stable_manifold_whanau';
run_new = run_names.stable_manifold3;
run_old = run_names.stable_manifold2;

% Previous solution label
label_old = coco_bd_labs(coco_bd_read(run_old), 'Del2');

% Print to console
fprintf("~~~ Stable Manifold (q): Third Run ~~~ \n");
fprintf('Calculate one of the stable-manifold branches \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

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
                 '-var', eye(3));

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
prob = apply_W_PO_conditions(prob, bcs_funcs, eps, vec_s, lam_s);

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
plot_solutions_scan(run_new)

%=========================================================================%
%                               END OF FILE                               %
%=========================================================================%