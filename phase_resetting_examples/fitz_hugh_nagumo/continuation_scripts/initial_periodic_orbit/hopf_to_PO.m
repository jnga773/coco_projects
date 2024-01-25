%-------------------------------------------------------------------------%
%%                        Hopf to Periodic Orbit                         %%
%-------------------------------------------------------------------------%
% Continue a family of periodic orbits emanating from the Hopf
% bifurcation with 'ode_HB2po'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.hopf_to_PO;
% Which run this continuation continues from
run_old = run_names.hopf_new_solution;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

% Print to console
fprintf("~~~ Fourth Run (ode_HB2po) ~~~ \n");
fprintf('Periodic orbits from Hopf bifurcation \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set ItMX steps
prob = coco_set(prob, 'corr', 'ItMX', 10);
% Set tolerance
prob = coco_set(prob, 'corr', 'TOL', 5e-7);
% Set NTST steps
prob = coco_set(prob, 'coll', 'NTST', 100);

% Continue from Hopf bifurcation
prob = ode_HB2po(prob, 'equilibrium_v2', run_old, label_old);

% Add event when c = 1.0
prob = coco_add_event(prob, 'c=1', 'c', 1.0);

% Run COCO
coco(prob, run_new, [], 1, 'c', [0.9, 1.2]);

%-------------------------------------------------------------------------%
%%                            Testing Things                             %%
%-------------------------------------------------------------------------%
% Solution to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'c=1');
label_plot = label_plot(1);

% Create plots
plot_hopf_to_PO_solution(run_new, label_plot, run_old, label_old);
