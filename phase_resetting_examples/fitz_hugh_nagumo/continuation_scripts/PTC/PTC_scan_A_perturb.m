function PTC_scan_A_perturb(run_new_in, run_old_in, label_old_in, data_PR_in, bcs_funcs_in)
  % PTC_scan_A_perturb(run_name_in, label_old_in)
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
  prob = coco_set(prob, 'cont', 'NAdapt', 10);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', 800);

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
  prange = {[0.0, 2.0], [], [-1e-4, 1e-2], [0.99, 1.01], []};
  coco(prob, run_new_in, [], 1, {'theta_old', 'theta_new', 'eta', 'mu_s', 'T', 'A_perturb'}, prange);

end
