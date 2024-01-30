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
label_old = 1;

% Print to console
fprintf("~~~ Second Run (ode_isol2bvp) ~~~ \n");
fprintf('Calculate Floquet bundle (mu) \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------%
%     Calculate Things     %
%--------------------------%
data_adjoint = calc_initial_solution_adjoint_problem(run_old, label_old);

% Function list
% func_list = {@floquet_adjoint, [], []};
func_list_adj = symbolic_floquet_adjoint();

%------------------------------------%
%     Setup Floquet Continuation     %
%------------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set PtMX
prob = coco_set(prob, 'cont', 'PtMX', 1500);
% Set NTST
prob = coco_set(prob, 'coll', 'NTST', 50);

% Add segment as initial solution
prob = ode_isol2coll(prob, 'adjoint', func_list_adj{:}, ...
                     data_adjoint.t0, data_adjoint.x0, ...
                     data_adjoint.pnames, data_adjoint.p0);

% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

% Run COCO
coco(prob, run_new, [], 1, {'mu_s', 'w_norm'} , [0.0, 1.1]);
