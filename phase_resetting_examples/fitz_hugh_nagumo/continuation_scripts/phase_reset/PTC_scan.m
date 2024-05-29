%-------------------------------------------------------------------------%
%%                   Phase Response Curve Calculation                    %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.phase_transition_curve;
% Which run this continuation continues from
run_old = run_names.phase_reset_perturbation;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'SP');
label_old = sort(label_old);

% Print to console
fprintf("~~~ Phase Reset: Second Run (phase_reset_2_PTC.m) ~~~ \n");
fprintf('Calculate phase transition curve \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from SP points in run: %s \n', run_old);

%---------------------------------%
%     Cycle through SP labels     %
%---------------------------------%
parfor run = 1 : length(label_old)
  % Label for this run
  this_run_label = label_old(run);

  % Data directory for this run
  fprintf('\n Continuing from point %d in run: %s \n', this_run_label, run_old);

  this_run_name = {run_new; sprintf('run_%02d', run)};

  % Run continuation
  phase_transition_scan_A_perturb(this_run_name, run_old, this_run_label, data_PR, bcs_funcs);

end

%-------------------------------------------------------------------------%
%%                            Testing Things                             %%
%-------------------------------------------------------------------------%
% % Label of solution to plot
% label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'SP'));
% % label_plot = label_plot(3);
% 
% % Plot bifurcation data
% plot_phase_transition_curve(run_new, label_plot);

% Plot all PTC
% plot_all_PTC(run_new, save_figure);

% Plot PTC plane in A_perturb
plot_PTC_plane_A_perturb(run_new, save_figure);

%-------------------------------------------------------------------------%
%%                         Continuation Function                         %%
%-------------------------------------------------------------------------%
function phase_transition_scan_A_perturb(run_new_in, run_old_in, label_old_in, data_PR_in, bcs_funcs_in)
  % phase_transition_scan_A_perturb(run_name_in, label_old_in)
  %
  % Scan through SP labels from previous run (different values of A_perturb)
  % and continue in \theta_{old} and \theta_{new}. Each run will save
  % to the 'data/run10_phase_reset_PTC/' directory.

  %----------------------------%
  %     Setup Continuation     %
  %----------------------------%
  % Set up the COCO problem
  prob = coco_prob();

  % Set tolerance
  % prob = coco_set(prob, 'corr', 'TOL', 5e-7);

  % Set step sizes
  prob = coco_set(prob, 'cont', 'h_min', 5e-2);
  prob = coco_set(prob, 'cont', 'h0', 1e-1);
  prob = coco_set(prob, 'cont', 'h_max', 1e2);

  % Set adaptive mesh
  prob = coco_set(prob, 'cont', 'NAdapt', 1);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', 750);

  %-------------------------------------------%
  %     Continue from Trajectory Segments     %
  %-------------------------------------------%
  % Segment 1
  prob = ode_coll2coll(prob, 'seg1', run_old_in, label_old_in);
  % Segment 2
  prob = ode_coll2coll(prob, 'seg2', run_old_in, label_old_in);
  % Segment 3
  prob = ode_coll2coll(prob, 'seg3', run_old_in, label_old_in);
  % Segment 4
  prob = ode_coll2coll(prob, 'seg4', run_old_in, label_old_in);  

  % Equilibrium point
  prob = ode_ep2ep(prob, 'singularity', run_old_in, label_old_in);

  %------------------------------------------------%
  %     Apply Boundary Conditions and Settings     %
  %------------------------------------------------%
  % Apply all boundary conditions, glue parameters together, and
  % all that other good COCO stuff. Looking the function file
  % if you need to know more ;)
  prob = apply_PR_boundary_conditions(prob, data_PR_in, bcs_funcs_in);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  % % Array of values for special event
  % SP_values = 0.0 : 0.1 : 1.0;
  % 
  % % When the parameter we want (from param) equals a value in A_vec
  % prob = coco_add_event(prob, 'SP', 'theta_old', SP_values);

  % Run COCO continuation
  prange = {[0.0, 1.0], [-1.0, 1.9], [-1e-4, 1e-2], [0.99, 1.01], []};
  coco(prob, run_new_in, [], 1, {'theta_old', 'theta_new', 'eta', 'mu_s', 'A_perturb', 'T'}, prange);

end
