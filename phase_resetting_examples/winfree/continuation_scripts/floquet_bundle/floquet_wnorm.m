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
run_new = run_names.compute_floquet_2;
% Which run this continuation continues from
run_old = run_names.compute_floquet_1;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

% Print to console
fprintf("~~~ Floquet Bundle: Second Run (floquet_wnorm.m) ~~~ \n");
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

% Apply boundary conditions
prob = apply_floquet_boundary_conditions(prob, bcs_funcs);

% Add event when w_norm = 1
prob = coco_add_event(prob, 'NORM1', 'w_norm', 1.0);

% Run COCO
coco(prob, run_new, [], 1, {'w_norm', 'mu_s', 'T'}, [0.0, 1.1]);
