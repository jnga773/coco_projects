function run_PTC_continuation(run_new_in, run_old_in, label_old_in, data_PR_in, SP_values_in, bcs_funcs_in)
  % run_PTC_continuation(run_name_in, label_old_in)
  %
  % Scan through SP labels from previous run (different values of A_perturb)
  % and continue in \theta_{old} and \theta_{new}. Each run will save
  % to the 'data/run10_phase_reset_PTC/' directory.
  %
  % Parameters
  % ----------
  % run_new_in : string
  %     The new run identifier for the main continuation problem.
  % run_old_in : string
  %     The old run identifier for the sub continuation problem.
  % label_old_in : integer
  %     The label identifier for the previous continuation problem.
  % data_PR_in : struct
  %     Data structure containing the initial conditions for the trajectory segments.
  % SP_values_in : array
  %     Array of values of theta_old to save solutions with the 'SP' label.
  % bcs_funcs_in : list of functions
  %     Structure containing boundary condition functions.
  %
  % See Also
  % --------
  % coco_prob, coco_set, ode_coll2coll, apply_PR_boundary_conditions, coco_add_event, coco

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
  prob = coco_set(prob, 'cont', 'h_max', 1e0);

  % Set adaptive meshR
  prob = coco_set(prob, 'cont', 'NAdapt', 10);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', 750);

 % Set norm to int
 prob = coco_set(prob, 'cont', 'norm', inf);

  % Set MaxRes and al_max
  prob = coco_set(prob, 'cont', 'MaxRes', 10);
  prob = coco_set(prob, 'cont', 'al_max', 25);

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

  %------------------------------------------------%
  %     Apply Boundary Conditions and Settings     %
  %------------------------------------------------%
  % Apply all boundary conditions, glue parameters together, and
  % all that other good COCO stuff. Looking the function file
  % if you need to know more ;)
  prob = apply_boundary_conditions_PR(prob, data_PR_in, bcs_funcs_in);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  prob = coco_add_event(prob, 'SP', 'theta_old', SP_values_in);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  % Run COCO continuation
  prange = {[0.0, 2.0], [], [-1e-4, 1e-2], [0.99, 1.01], []};
  coco(prob, run_new_in, [], 1, {'theta_old', 'theta_new', 'eta', 'mu_s', 'T', 'A_perturb'}, prange);

end
