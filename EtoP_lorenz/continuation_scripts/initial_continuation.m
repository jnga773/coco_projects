%-------------------------------------------------------------------------%
%%                         Initial Continuation                          %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
% Run name
run_new = run_names.initial_continuation;

% Print to console
fprintf('~~~ Initialisation: First run (ode_isol2ep) ~~~\n');
fprintf('Initial continuation from some point x0\n');
fprintf('Run name: %s \n', run_new);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);
prob = coco_set(prob, 'ep', 'BTP', true);

% Set up isol2ep problem
prob = ode_isol2ep(prob, 'hopf_po', func_list{:}, [0, 0, 0], pnames, [s; 0; b]);

% Run COCO continuation
coco(prob, run_new, [], 1, 'r', [0, 30]);
