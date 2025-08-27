function run_PR_continuation(run_new, run_old, label_old, bcs_funcs, pcont, prange, options)
  % run_PR_continuation(run_new, run_old, label_old, bcs_funcs, pcont, prange, options)
  %
  % Run the phase resetting continuation problem, from label_old solution in
  % run_old, and saves the results in run_new.
  %
  % Parameters
  % ----------
  % run_new : string or cell of strings
  %     The new run identifier for the main continuation problem.
  % run_old : string or cell of strings
  %     The old run identifier for the sub continuation problem.
  % label_old : integer
  %     The label identifier for the previous continuation problem.
  % bcs_funcs : list of functions
  %     Structure containing boundary condition functions.
  % pcont : cell
  %     Cell array containing additional parameters for the continuation.
  % prange : cell
  %     Cell array containing the ranges for the continuation parameters.
  % SP_parameter : array
  %     Parameter to save SP solutions for
  % SP_values : array
  %     Array of values of theta_old to save solutions with the 'SP' label.
  % bcs_isochron : boolean
  %     Flag to determine if the isochron phase condition should be added.
  % par_isochron : boolean
  %     Flag to determine if isochron parameters should be recorded.
  % TOL : double
  %     Tolerance for the continuation. (Default: 1e-6)
  % h_min : double
  %     Minimum step size for the continuation. (default: 1e-2)
  % h0 : double
  %     Initial step size for the continuation. (default: 1e-1)
  % h_max : double
  %     Maximum step size for the continuation. (default: 1e0)
  % NAdapt : integer
  %     Number of adaptive mesh refinements. (default: 10)
  % PtMX : integer
  %     Maximum number of points in the continuation. (default: 750)
  % MaxRes : integer
  %     Maximum number of residuals allowed. (default: 10)
  % al_max : integer
  %     Maximum number of continuation steps. (default: 25)
  % NPR : integer
  %     Frequency of saved solutions. (default: 10)
  %
  % See Also
  % --------
  % coco_prob, coco_set, ode_coll2coll, apply_PR_boundary_conditions, coco_add_event, coco

  %-------------------%
  %     Arguments     %
  %-------------------%
  arguments
    run_new
    run_old
    label_old double
    bcs_funcs struct
    pcont cell = {'theta_old', 'theta_new', 'eta', 'mu_s'};
    prange cell = {[0.0, 2.0], [], [-1e-4, 1e-2], [0.99, 1.01]};

    % Optional arguments
    options.SP_parameter string = ''
    options.SP_values double = []

    % Optional settings for isochron computations
    options.bcs_isochron logical = false;
    options.par_isochron logical = false;

    % COCO Settings
    options.TOL    = 1e-6
    options.h_min  = 1e-2;
    options.h0     = 1e-1;
    options.h_max  = 1e0;
    options.NAdapt = 10;
    options.PtMX   = 750;
    options.MaxRes = 10;
    options.al_max = 25;
    options.NPR    = 10;
  end

  %----------------------------%
  %     Setup Continuation     %
  %----------------------------%
  % Set up the COCO problem
  prob = coco_prob();

  % Set tolerance
  % prob = coco_set(prob, 'corr', 'TOL', options.TOL);

  % Set step sizes
  prob = coco_set(prob, 'cont', 'h_min', options.h_min);
  prob = coco_set(prob, 'cont', 'h0', options.h0);
  prob = coco_set(prob, 'cont', 'h_max', options.h_max);

  % Set adaptive meshR
  prob = coco_set(prob, 'cont', 'NAdapt', options.NAdapt);

  % Set number of steps
  prob = coco_set(prob, 'cont', 'PtMX', options.PtMX);

  % Set norm to int
  prob = coco_set(prob, 'cont', 'norm', inf);

  % % Set MaxRes and al_max
  % prob = coco_set(prob, 'cont', 'MaxRes', options.MaxRes);
  % prob = coco_set(prob, 'cont', 'al_max', options.al_max);

  % Set frequency of saved solutions
  prob = coco_set(prob, 'cont', 'NPR', options.NPR);

  %-------------------%
  %     Set NTSTs     %
  %-------------------%
  % % Read k value from previous run
  % k = coco_bd_val(coco_bd_read(run_old), label_old, 'k');
  % 
  % % Set NTSTs
  % prob = coco_set(prob, 'seg1.coll', 'NTST', 25);
  % prob = coco_set(prob, 'seg2.coll', 'NTST', 25);
  % prob = coco_set(prob, 'seg3.coll', 'NTST', 25);
  % prob = coco_set(prob, 'seg4.coll', 'NTST', 40 * k);

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

  %------------------------------------%
  %     Continue Equilibrium Point     %
  %------------------------------------%
  % Add equilibrium point for q inside periodic orbit
  prob = ode_ep2ep(prob, 'x0', run_old, label_old);

  %------------------------------------------------%
  %     Apply Boundary Conditions and Settings     %
  %------------------------------------------------%
  % Apply all boundary conditions, glue parameters together, and
  % all that other good COCO stuff. Looking the function file
  % if you need to know more ;)
  prob = apply_boundary_conditions_PR(prob, bcs_funcs, ...
                                      bcs_isochron=options.bcs_isochron, ...
                                      par_isochron=options.par_isochron);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  if ~isempty(options.SP_values)
    prob = coco_add_event(prob, 'SP', options.SP_parameter, options.SP_values);
  end

  %--------------------------%
  %     Run Continuation     %
  %--------------------------%
  % Run COCO continuation
  coco(prob, run_new, [], 1, pcont, prange);

end
