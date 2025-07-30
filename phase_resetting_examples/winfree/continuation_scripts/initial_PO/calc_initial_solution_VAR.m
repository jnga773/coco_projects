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

  %-----------------------%
  %     Read Solution     %
  %-----------------------%
  % Read previous solution
  [sol, data] = coll_read_solution('initial_PO', run_in, label_in);

  % Dimensions
  xdim = data.xdim;
  pdim = data.pdim;

  % State solution
  xbp = sol.xbp;

  % Period
  T   = sol.T;

  % Temporal data
  tbp = sol.tbp;

  % Initial parameter space
  p_OG = sol.p;
  % Initial parameter names
  pnames_OG = data.pnames;

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
  data_out.t0 = tbp;
  data_out.T  = T;

  % Initial state solution. First two columns correspond to the
  % periodic orbit, the third column corresponds to the eigenvalue
  % mu_s, and the last column corresponds to the norm of w.
  data_out.x0 = [xbp, zeros(length(tbp), xdim)];

  % Parameters
  data_out.p0     = p_out;
  data_out.pnames = pnames_out';

end