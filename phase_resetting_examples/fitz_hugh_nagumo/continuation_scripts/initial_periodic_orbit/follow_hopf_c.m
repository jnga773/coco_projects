%-------------------------------------------------------------------------%
%%                           Move Hopf c Value                           %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.follow_hopf_c;
% Which run this continuation continues from
run_old = run_names.follow_hopf_z;

% Continuation point
label_old = sort(coco_bd_labs(coco_bd_read(run_old), 'H_PT'));

% Print to console
fprintf("~~~ Initial Periodic Orbit: Third Run (follow_hopf_c.m) ~~~ \n");
fprintf('Move the c value \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------%
%     Read Data     %
%-------------------%
% Read previous solution
[sol, data] = ep_read_solution('', run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% % Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 1e-2, 'h0', 1e-2, 'h_max', 1e-2);

% % Set frequency of saved solutions
% prob = coco_set(prob, 'cont', 'NPR', 25);

% Set upper bound of continuation steps in each direction along solution
PtMX = 300;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_isol2ep(prob, '', funcs.field{:}, ...
                   sol.x, data.pnames, sol.p);

% Run COCO
coco(prob, run_new, [], 1, {'c', 'z'}, [-1.0, 1.0]);

