%-------------------------------------------------------------------------%
%%                   Phase Response Curve Calculation                    %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.phase_response_curve_2;
% Which run this continuation continues from
run_old = run_names.phase_response_curve_1;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

% Print to console
fprintf("~~~ Fourth Run (ode_BP2bvp) ~~~ \n");
fprintf('Calculate phasse resetting curve \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% % Set tolerance
% prob = coco_set(prob, 'corr', 'TOL', 5e-7);
% 
% % Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 5e-5);
% prob = coco_set(prob, 'cont', 'h0', 1e-2);
% prob = coco_set(prob, 'cont', 'h_max', 1e2);

% Set adaptive mesh
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set number of steps
prob = coco_set(prob, 'cont', 'PtMX', 200);

%-------------------------------------------%
%     Continue from Trajectory Segments     %
%-------------------------------------------%
% Segment 1
prob = ode_coll2coll(prob, 'seg1', run_old, label_old);
% Segment 2
prob = ode_coll2coll(prob, 'seg2', run_old, label_old);
% Segment 3
prob = ode_coll2coll(prob, 'seg3', run_old, label_old);
% Segment 4
prob = ode_coll2coll(prob, 'seg4', run_old, label_old);  

% Equilibrium point
prob = ode_ep2ep(prob, 'singularity', run_old, label_old);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply all boundary conditions, glue parameters together, and
% all that other good COCO stuff. Looking the function file
% if you need to know more ;)
prob = glue_PR_conditions(prob, data_PR);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Array of values for special event
SP_values = [0.1, 0.9];

% When the parameter we want (from param) equals a value in A_vec
prob = coco_add_event(prob, 'SP', 'theta_old', SP_values);

% Run COCO continuation
prange = {[0.0, 1.0], [0.0, 1.0], [], [0.99, 1.01]};
coco(prob, run_new, [], 1, {'theta_old', 'theta_new', 'eta', 'mu_s'}, prange);

%-------------------------------------------------------------------------%
%%                            Testing Things                             %%
%-------------------------------------------------------------------------%
% Label of solution to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'SP'));
% label_plot = label_plot(3);

% Plot bifurcation data
plot_theta_bifurcations(run_new, label_plot);

% Plot first SP solution
plot_phase_reset_phase_space(run_new, label_plot(1), 5, save_figure);

% Plot first SP solution
plot_phase_reset_phase_space(run_new, label_plot(2), 6, save_figure);
