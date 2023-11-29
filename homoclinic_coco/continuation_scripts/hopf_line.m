%-------------------------------------------------------------------------%
%%                         Hopf Bifurcation Loop                         %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.hopf_bifurcations;
% Which run this continuation continues from
run_old = run_names.initial_run;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

% Print to console
fprintf('~~~ Hopf Bifurcations (ode_HB2HB) ~~~ \n');
fprintf('Calculate line of Hopf bifurcation points H\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 5);

% Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 5e-2);
% prob = coco_set(prob, 'cont', 'h0', 5e-2);
% prob = coco_set(prob, 'cont', 'h_max', 5e-2);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);
% prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);
% prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% % Set number of points
% prob = coco_set(prob, 'coll', 'NTST', 100);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);

% Continue from branching point
prob = ode_HB2HB(prob, '', run_old, label_old);

% Run COCO continuation
coco(prob, run_new, [], 1, {'p1', 'p2'}, p_range);
