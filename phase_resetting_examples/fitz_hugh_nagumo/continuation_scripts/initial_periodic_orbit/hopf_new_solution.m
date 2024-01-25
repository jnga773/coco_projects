%-------------------------------------------------------------------------%
%%                     Continue New Initial Solution                     %%
%-------------------------------------------------------------------------%
% Reading from the previous solution where z = -0.8, we continue a new 
% solution and vary 'z' and 'c'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.hopf_new_solution;
% Which run this continuation continues from
run_old = run_names.hopf_move_z;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

% Print to console
fprintf("~~~ Third Run (ode_isol2ep) ~~~ \n");
fprintf('Try new guess solution \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-------------------%
%     Read Data     %
%-------------------%
% Read previous solution
[sol, data] = ep_read_solution('equilibrium', run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_isol2ep(prob, 'equilibrium_v2', func_list{:}, ...
                   sol.x, data.pnames, sol.p);

% Run COCO
coco(prob, run_new, [], 1, 'c', [0.9, 1.0]);
