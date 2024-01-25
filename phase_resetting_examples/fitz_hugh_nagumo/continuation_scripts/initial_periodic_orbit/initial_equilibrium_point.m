%-------------------------------------------------------------------------%
%%                       Compute Equilibrium Point                       %%
%-------------------------------------------------------------------------%
% We compute and continue the equilibrium point of the model using
% the 'EP' toolbox constructor 'ode_isol2ep'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.initial_EP;

% Print to console
fprintf('~~~ First Run (ode_isol2ep) ~~~\n');
fprintf('Solve for initial solution of the equilibrium point\n')
fprintf('Run name: %s\n', run_new);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% % The value of 10 for 'NAdapt' implied that the trajectory discretisation
% % is changed adaptively ten times before the solution is accepted.
prob = coco_set(prob, 'coll', 'NTST', 10);

% Set tolerance
prob = coco_set(prob, 'corr', 'TOL', 5e-7);

% Set upper bound of continuation steps in each direction along solution
% PtMX = 100;
% prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_isol2ep(prob, 'equilibrium', func_list{:}, ...
                   x0, pnames, p0);

% Run COCO
coco(prob, run_new, [], 1, 'c', [-4.0, 4.0]);
