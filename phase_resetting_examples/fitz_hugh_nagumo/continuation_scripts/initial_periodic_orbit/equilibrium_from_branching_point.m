%-------------------------------------------------------------------------%
%%                   Continuation from Branching Point                   %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.branching_point;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

% Print to console
fprintf('~~~ Initial Periodic Orbit: Second run (equilibrium_from_branching_point.m) ~~~\n');
fprintf('Continue bifurcations from the branching point\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% % Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 5e-2, 'h0', 5e-2, 'h_max', 5e-2);

% Set upper bound of continuation steps in each direction along solution
PtMX = 50;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);

% Continue from branching point
prob = ode_BP2ep(prob, '', run_old, label_old);

% Run COCO continuation
coco(prob, run_new, [], 1, 'A', A_range);
