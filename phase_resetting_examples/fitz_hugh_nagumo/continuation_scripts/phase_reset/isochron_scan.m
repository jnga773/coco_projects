function isochron_scan(run_new_in, run_old_in, label_old_in, data_PR_in, bcs_funcs_in)
  % isochron_scan(run_name_in, label_old_in)
  %
  % Scan through SP labels from previous run (different values of d_y)
  % and continue in d_x and d_z to calculate slices of the two-dimensional
  % isochrons.

  %----------------------------%
  %     Setup Continuation     %
  %----------------------------%
  % Set up the COCO problem
  prob = coco_prob();

  % Set tolerance
  % prob = coco_set(prob, 'corr', 'TOL', 5e-7);

  % Set step sizes
  prob = coco_set(prob, 'cont', 'h_min', 1e-2);
  prob = coco_set(prob, 'cont', 'h0', 1e-1);
  prob = coco_set(prob, 'cont', 'h_max', 1e2);

  % Set adaptive mesh
  prob = coco_set(prob, 'cont', 'NAdapt', 10);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', 500);

  % Set fold point detection to parameter 'iso3'
  prob = coco_set(prob, 'cont', 'fpar', 'iso3');

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
  prob = apply_isochron_boundary_conditions(prob, data_PR_in, bcs_funcs_in);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  % % Array of values for special event
  % SP_values = 0.0 : 0.1 : 1.0;
  % 
  % % When the parameter we want (from param) equals a value in A_vec
  % prob = coco_add_event(prob, 'SP', 'theta_old', SP_values);

  %------------------%
  %     Run COCO     %
  %------------------%
  % Run COCO continuation
  prange = {[], [], [], [0.99, 1.01], [], [-4, 6], [-4, 6], []};
  coco(prob, run_new_in, [], 1, {'d_x', 'd_z', 'eta', 'mu_s', 'T', 'iso1', 'iso2', 'iso3'}, prange);

end
