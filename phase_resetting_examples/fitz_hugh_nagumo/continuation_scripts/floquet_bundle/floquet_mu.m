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
run_new = run_names.compute_floquet_1;
% Which run this continuation continues from
run_old = run_names.initial_periodic_orbit;

% Continuation point
% label_old = coco_bd_labs(coco_bd_read(run_old), 'PO_PT');
label_old = 1;

% Print to console
fprintf("~~~ Floquet Bundle: First Run (floquet_mu.m) ~~~ \n");
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

% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

% Add event
prob = coco_add_event(prob, 'mu=1', 'mu_s', 1.0);

% Run COCO
coco(prob, run_new, [], 1, {'mu_s', 'w_norm', 'T'} , [0.0, 1.1]);
