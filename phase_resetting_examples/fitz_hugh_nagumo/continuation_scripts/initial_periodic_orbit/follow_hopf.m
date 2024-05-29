%-------------------------------------------------------------------------%
%%                           Move Hopf c Value                           %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.follow_hopf;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = sort(label_old);
label_old = label_old(1);

% Print to console
fprintf("~~~ Initial Periodic Orbit: Second Run (follow_hopf.m) ~~~ \n");
fprintf('Follow Hopf birufcation until z=-0.8 \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Initial solution to periodic orbit (COLL Toolbox)
prob = ode_HB2HB(prob, '', run_old, label_old);

% Add event when z = -0.8
prob = coco_add_event(prob, 'H_PT', 'z', -0.8);

% Run COCO
coco(prob, run_new, [], 1, {'z', 'c'}, {[-1.0, 1.0], [-4.0, 4.0]});
