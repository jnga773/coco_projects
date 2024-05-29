%-------------------------------------------------------------------------%
%%                           Move Hopf z Value                           %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.follow_hopf_z;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Continuation point
label_old = sort(coco_bd_labs(coco_bd_read(run_old), 'HB'));
label_old = label_old(3);

% Print to console
fprintf("~~~ Initial Periodic Orbit: Second Run (follow_hopf_z.m) ~~~ \n");
fprintf('Move the z value \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% % Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 1e-2, 'h0', 1e-2, 'h_max', 1e-2);

% % Set frequency of saved solutions
% prob = coco_set(prob, 'cont', 'NPR', 25);

% % Set upper bound of continuation steps in each direction along solution
% PtMX = 300;
% prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_HB2HB(prob, '', run_old, label_old);

% Even for Nonlinear Photonics abstract
prob = coco_add_event(prob, 'H_PT', 'z', -0.8);

% Run COCO
coco(prob, run_new, [], 1, {'z', 'c'}, [-0.8, -0.4]);

