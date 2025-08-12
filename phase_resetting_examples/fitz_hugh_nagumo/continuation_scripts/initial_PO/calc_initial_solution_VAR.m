function data_out = calc_initial_solution_VAR(run_in, label_in)
  % data_out = calc_initial_solution_VAR(run_in, label_in);
  %
  % Calculates and sets the initial solution to solve for the adjoint problem
  %
  % Parameters
  % ----------
  % run_in : string
  %     The run identifier for the continuation problem.
  % label_in : integer
  %     The label identifier for the continuation problem.
  %
  % Returns
  % -------
  % data_out : struct
  %     Structure containing the initial conditions for the trajectory segments.
  %     Fields:
  %         - t0 : Normalized temporal data.
  %         - x0 : Initial state solution.
  %         - p0 : Initial parameter array.
  %         - pnames : Parameter names.
  %
  % See Also
  % --------
  % coll_read_solution

  %---------------------------------------%
  %     Read Solution: Periodic Orbit     %
  %---------------------------------------%
  % Read previous solution
  [sol, data] = coll_read_solution('initial_PO', run_in, label_in);

  % Dimensions
  xdim = data.xdim;
  pdim = data.pdim;

  % State solution
  xbp_PO = sol.xbp;

  % Period
  T_PO   = sol.T;

  % Temporal data
  tbp_PO = sol.tbp;

  % Initial parameter space
  p_OG = sol.p;
  % Initial parameter names
  pnames_OG = data.pnames;

  %--------------------------------------%
  %     Read Data: Equilibrium Point     %
  %--------------------------------------%
  % Read previous solution
  [sol_EP, data_EP] = ep_read_solution('x0', run_in, label_in);

  % Equilibrium point
  x0 = sol_EP.x;

  %-------------------------------------%
  %     Initial Variational Problem     %
  %-------------------------------------%
  % Initial state vector: First two columns correspond to the
  % periodic orbit, the third column corresponds to the eigenvalue
  % mu_s, and the last column corresponds to the norm of w.
  xbp_init = [xbp_PO, zeros(length(tbp_PO), xdim)];

  % Initial v;alues of eigenvalues and norm
  mu_s   = 0.9;
  w_norm = 0.0;

  % Extend the parameter space
  p_out = [p_OG; mu_s; w_norm];

  % Extend the parameter names
  pnames_out = pnames_OG;
  pnames_out{pdim+1} = 'mu_s';
  pnames_out{pdim+2} = 'w_norm';

  %----------------%
  %     Output     %
  %----------------%
  % Initial temporal solution
  data_out.tbp_init = tbp_PO;
  data_out.T_PO     = T_PO;

  % Initial state solution.
  data_out.xbp_init = xbp_init;

  % Parameters
  data_out.p0       = p_out;
  data_out.pnames   = pnames_out';

  % Equilibrium point
  data_out.x0       = x0;

end