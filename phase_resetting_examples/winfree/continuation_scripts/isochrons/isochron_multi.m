%-------------------------------------------------------------------------%
%%                       Phase Response: Isochrons                       %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.isochron_multi;
% Which run this continuation continues from
run_old = run_names.isochron_initial;

% Continuation point
label_old = sort(coco_bd_labs(coco_bd_read(run_old), 'SP'));

% Print to console
fprintf("~~~ Isochron: Second Run (isochron_multi.m) ~~~ \n");
fprintf('Calculate all SP point isochrons from \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from SP points in run: %s \n', run_old);

%-------------------------------------%
%     Cycle Through All SP Points     %
%-------------------------------------%
% Set number of threads to run in parallel
NUM_THREADS = 5;
parfor (i = 1 : length(label_old), NUM_THREADS)
  % Run solution label
  solution = label_old(i);
  
  % Create run name identifier
  run_i = sprintf('SP_%d', solution);
  % Append to directory
  this_run_name   = {run_new, run_i};

  % Data directory for this run
  fprintf('\n Continuing from point %d in run: %s \n', solution, run_old);
  fprintf('Current run_name folder: ./data/%s/%s/ \n', this_run_name{1}, this_run_name{2});

  % Run continuation
  scan_through_all_isochrons(this_run_name, run_old, solution, data_PR, bcs_funcs);

end

%-------------------------------------------------------------------------%
%%                            Testing Things                             %%
%-------------------------------------------------------------------------%'
% Create the isochron plot maybe?
plot_all_isochrons(run_new, save_figure);

%-------------------------------------------------------------------------%
%%                         Continuation Function                         %%
%-------------------------------------------------------------------------%
function scan_through_all_isochrons(run_new_in, run_old_in, label_old_in, data_PR_in, bcs_funcs_in)
  % scan_through_all_isochrons(run_name_in, label_old_in)
  %
  % Scan through SP labels from previous run (different values of theta_old)
  % and continue in d_x and d_y. Each run will save to the 
  % 'data/run08_isochron_multi/' directory.

  %----------------------------%
  %     Setup Continuation     %
  %----------------------------%
  % Set up the COCO problem
  prob = coco_prob();

  % % Set tolerance
  prob = coco_set(prob, 'corr', 'TOL', 1e-8);
  % 
  % % Set step sizes
  % prob = coco_set(prob, 'cont', 'h_min', 5e-2);
  % prob = coco_set(prob, 'cont', 'h0', 1e-1);
  % prob = coco_set(prob, 'cont', 'h_max', 1e2);

  % Set adaptive mesh
  prob = coco_set(prob, 'cont', 'NAdapt', 1);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', 400);

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
  prob = apply_isochron_conditions(prob, data_PR_in, bcs_funcs_in);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  % % Array of values for special event
  % SP_values = 0.0 : 0.1 : 2.0;
  % 
  % % When the parameter we want (from param) equals a value in A_vec
  % prob = coco_add_event(prob, 'SP', 'theta_old', SP_values);

  % Run COCO continuation
  prange = {[-3, 3], [-3, 3], [-1e-4, 1e-2], [0.99, 1.01], []};
  coco(prob, run_new_in, [], 1, {'d_x', 'd_y', 'eta', 'mu_s', 'T'}, prange);

end
