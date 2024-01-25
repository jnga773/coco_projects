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
label_old = coco_bd_labs(coco_bd_read(run_old), 'SP');
label_old = sort(label_old);

% Print to console
fprintf("~~~ Fourth Run (ode_BP2bvp) ~~~ \n");
fprintf('Calculate phasse resetting curve \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from SP points in run: %s \n', run_old);

%-------------------------------------%
%     Cycle Through All SP Points     %
%-------------------------------------%
for solution = label_old
  % Create run name identifier
  run_i = sprintf('SP_%d', solution);
  % Append to directory
  this_run   = {run_new, run_i};

  %----------------------------%
  %     Setup Continuation     %
  %----------------------------%
  % Set up the COCO problem
  prob = coco_prob();

  % Set tolerance
  prob = coco_set(prob, 'corr', 'TOL', 5e-7);

  % Set step sizes
  prob = coco_set(prob, 'cont', 'h_min', 5e-6);
  prob = coco_set(prob, 'cont', 'h0', 1e-3);
  prob = coco_set(prob, 'cont', 'h_max', 0.5);

  % Set adaptive mesh
  prob = coco_set(prob, 'cont', 'NAdapt', 1);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', 100);

  %------------------------------------------%
  %     Continue from Previous Solutions     %
  %------------------------------------------%
  % Segment 1
  prob = ode_coll2coll(prob, 'seg1', run_old, solution);
  % Segment 2
  prob = ode_coll2coll(prob, 'seg2', run_old, solution);
  % Segment 3
  prob = ode_coll2coll(prob, 'seg3', run_old, solution);   
  % Segment 4
  prob = ode_coll2coll(prob, 'seg4', run_old, solution);       
  % Singularity point
  prob = ode_ep2ep(prob, 'singularity', run_old, solution);

  %------------------------------------------------%
  %     Apply Boundary Conditions and Settings     %
  %------------------------------------------------%
  % Apply all boundary conditions, glue parameters together, and
  % all that other good COCO stuff. Looking the function file
  % if you need to know more ;)
  prob = glue_PR_conditions(prob, data_PR);

  % Extract indices and mappings
  [data1, uidx1]   = coco_get_func_data(prob, 'seg1.coll', 'data', 'uidx');
  maps1 = data1.coll_seg.maps;

  % Add zero function for isochron theta boundary conditions
  prob = coco_add_func(prob , 'Delta', @bcs_isochron, data1, ...
                       'zero','uidx', uidx1(maps1.p_idx([7, 8])));

  %--------------------------%
  %     Run Continuation     %
  %--------------------------%
  % Run COCO continuation
  prange = {[-2, 2], [-2, 2], [], [-1e-3, 1e-3], [0.9, 1.1]};
  coco(prob, this_run, [], 1, {'d_x', 'd_y', 'theta_new', 'eta', 'mu_s'}, prange);

  % prange = {[-2, 2], [-2*pi, 2*pi], [], [-1e-3, 1e-3], [0.9, 1.1]};
  % coco(prob, this_run, [], 1, {'A', 'theta_perturb', 'theta_new', 'eta', 'mu_s'}, prange);

end

%-------------------------------------------------------------------------%
%%                            Testing Things                             %%
%-------------------------------------------------------------------------%'
% Create the isochron plot maybe?
plot_isochrons(run_new, label_old, save_figure);
