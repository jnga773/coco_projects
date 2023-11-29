%-------------------------------------------------------------------------%
%%                 Initial Equilibrium Point Continuation                %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Run names
run_new = run_names.initial_run;

% Print to console
fprintf('~~~ First run (ode_isol2ep) ~~~\n');
fprintf('Run name: %s\n', run_new);
fprintf('Continue family of equilibrium points.\n')

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
% prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);
prob = coco_set(prob, 'ep', 'BTP', true);

% Set up isol2ep problem
prob = ode_isol2ep(prob, '', func_list{:}, x0, pnames, p0);

% Run COCO continuation
% bd1 = coco(prob, run_new, [], 1, {'p1', 'p2'}, p_range);
coco(prob, run_new, [], 'p1', p1_range);
