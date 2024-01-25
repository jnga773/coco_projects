%-------------------------------------------------------------------------%
%%                           Move Hopf z Value                           %%
%-------------------------------------------------------------------------%
% Continuing from a Hopf bifurcation with 'ode_HB2HB', we vary
% the 'z' parameter to z = -0.8

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.hopf_move_z;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(3);

% Print to console
fprintf("~~~ Second Run (ode_HB2HB) ~~~ \n");
fprintf('Move the z value \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_HB2HB(prob, 'equilibrium', run_old, label_old);

% Run COCO
coco(prob, run_new, [], 1, {'z', 'c'}, [-0.8, -0.4]);
