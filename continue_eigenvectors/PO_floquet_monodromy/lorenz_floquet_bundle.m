%-------------------------------------------------------------------------%
%%                    LORENTZ MODEL (Floquet Bundle)                     %%
%-------------------------------------------------------------------------%
% This is a rewrite of the example in Section 10.2.2 of "Recipes for
% Continuation" by Harry Dankowicz and Frank Schilder. In the book they use
% the older 'po' and 'coll' toolboxes. Here, I have rewritten them using the
% newer 'po' and 'coll' tollboxes from the 'ode' toolbox.

% Here we compute the Floquet bundle from the monodromy matrix. We compute
% the moonodromy matrix from the append variational problem with the
% added '-var' option in the ode_HB2po call.

% Clear plots
close all;

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');
% Add boundary condition functions to path
addpath('./boundary_conditions/');

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

% Boundary conditions: Eigenvector conditions
bcs_funcs.bcs_eig      = {@bcs_eig};

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

% Print to console
fprintf('~~~ First run (ode_isol2ep) ~~~\n');
fprintf('Run name: %s\n', run_new);
fprintf('Continue family of equilibrium points.\n')

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
prob = coco_set(prob, 'cont', 'PtMX', 100);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);
prob = coco_set(prob, 'ep', 'BTP', true);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
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

% Print to console
fprintf('~~~ Initialisation: Second run (ode_BP2ep) ~~~\n');
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
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
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

% Print to console
fprintf('~~~ Periodic Orbits from Hopf (ode_HB2po) ~~~\n');
fprintf('Continue periodic orbits originating from Hopf bifurcation\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
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

%----------------------------%
%     Setup Continuation     %
%----------------------------%
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

%------------------------%
%     Add COCO Event     %
%------------------------%
% Add COCO event for r = 24
prob = coco_add_event(prob, 'r24', 'r', 24.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'r', [24, 25]);

%-------------------------------------------------------------------------%
%%              Continue Periodic Orbit and Floquet Vector               %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.PO_with_floquet = 'run04_PO_with_floquet';
run_new = run_names.PO_with_floquet;
% Which run this continuation continues from
run_old = run_names.PO_from_hopf;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'r24');

% Print to console
fprintf('~~~ Periodic Orbits from Hopf (ode_po2po) ~~~\n');
fprintf('Continue periodic orbits originating from Hopf bifurcation\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-----------------------------------------%
%     Calculate Stable Floquet Vector     %
%-----------------------------------------%
% Read one of the solutions
chart = coco_read_solution('hopf_po.po.orb.coll.var', run_old, label_old, 'chart');
data  = coco_read_solution('hopf_po.po.orb.coll', run_old, label_old, 'data');

% Create monodrony matrix
M1 = chart.x(data.coll_var.v1_idx);

fprintf('~~~ Monodromy Matrix ~~~\n');
fprintf('(%.7f, %.7f, %.7f)\n', M1(1, :));
fprintf('(%.7f, %.7f, %.7f)\n', M1(2, :));
fprintf('(%.7f, %.7f, %.7f)\n\n', M1(3, :));

% Calculate eigenvalues and eigenvectors
[v, d] = eig(M1);

% Find index for stable eigenvector? < 1
ind = find(abs(diag(d)) < 1);

% Stable eigenvector
vec0 = -v(:, ind);
% Stable eigenvalue (Floquet thingie)
lam0 = d(ind, ind);

fprintf('\n~~~ Eigenvector and Eigenvalue ~~~\n');
fprintf('vec0 (numeric)  = (%f, %f, %f) \n', vec0);
fprintf('lam0 (numeric)  = %s \n\n', lam0);

%-------------------------------%
%     Continuation Settings     %
%-------------------------------%
% Set up COCO problem
prob = coco_prob();

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

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Continue from branching point
prob = ode_po2po(prob, 'hopf_po', run_old, label_old, ...
                 '-var', eye(3));

% Hold the initial condition of solution to variational problem fixed
% Read data and uidx indices
[data_var, uidx_var] = coco_get_func_data(prob, 'hopf_po.po.orb.coll.var', 'data', 'uidx');
% Index mapping
maps_var = data_var.coll_var;

%----------------------------------------%
%     Eigenvalue Boundary Conditions     %
%----------------------------------------%
% Apply the boundary conditions for the eigenvalues and eigenvectors of the
% monodromy matrix
prob = coco_add_func(prob, 'bcs_eig', @bcs_eig, data_var, ...
                     'zero', 'uidx', ...
                     [uidx_var(maps_var.v1_idx(:, 1)); ...
                      uidx_var(maps_var.v1_idx(:, 2)); ...
                      uidx_var(maps_var.v1_idx(:, 3))], ...
                      'u0', [vec0; lam0]);

% Get u-vector indices from this coco_add_func call, including the extra
% indices from the added "vec_floquet" and "lam_floquet".
uidx_eig = coco_get_func_data(prob, 'bcs_eig', 'uidx');

% Grab eigenvector and value indices from u-vector [vec_floquet, lam_floquet]
data_out.vec_floquet_idx = [numel(uidx_eig)-3; numel(uidx_eig)-2; numel(uidx_eig)-1];
data_out.lam_floquet_idx = numel(uidx_eig);

% Save data
prob = coco_add_slot(prob, 'bcs_eig', @coco_save_data, data_out, 'save_full');

%------------------------%
%     Add Parameters     %
%------------------------%
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars', ...
                     uidx_var(maps_var.v0_idx, :), ...
                     {'s1', 's2', 's3', ...
                      's4', 's5', 's6', ...
                      's7', 's8', 's9'});

% Add stable Floquet vector components and value as parametesr
prob = coco_add_pars(prob, 'pars_floquet_vec', ...
                    uidx_eig(data_out.vec_floquet_idx), ...
                    {'vecs_1', 'vecs_2', 'vecs_3'}, 'active');
prob = coco_add_pars(prob, 'pars_floquet_lam', ...
                     uidx_eig(data_out.lam_floquet_idx), 'lams', 'active');

%------------------------%
%     Add COCO Event     %
%------------------------%
% Add COCO event for r = 24
prob = coco_add_event(prob, 'r24', 'r', 24.0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, 'r', [20, 25]);

%-----------------------------------------------%
%     Read Stable Vector from COCO Solution     %
%-----------------------------------------------%
% Get COCO solution label
label_plot = coco_bd_labs(coco_bd_read(run_new), 'r24');

% Read COCO solution
data = coco_read_solution('bcs_eig', run_new, label_plot, 'data');
chart = coco_read_solution('bcs_eig', run_new, label_plot', 'chart');

% Get solution
vec_s = chart.x(data.vec_floquet_idx);
lam_s = chart.x(data.lam_floquet_idx);

fprintf('\n~~~ (NEW SOLUTION) Eigenvector and Eigenvalue ~~~\n');
fprintf('vec_s (numeric)  = (%f, %f, %f) \n', vec_s);
fprintf('lam_s (numeric)  = %s \n\n', lam_s);

%=========================================================================%
%                               END OF FILE                               %
%=========================================================================%