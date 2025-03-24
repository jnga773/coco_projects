function save_data_VAR(run_in, label_in, filename_out)
  % save_data_VAR(run_in, label_in, filename_out)
  %
  % Reads periodic orbit solution data from COCO solution, calculates the
  % one-dimensional stable manifold of the "central" saddle point 'q', and
  % saves the data to './data/initial_PO.mat'.
  %
  % Parameters
  % ----------
  % run_in : string
  %     The run identifier for the continuation problem.
  % label_in : int
  %     The solution label for the continuation problem.
  % filename_out : string
  %     Filename for the Matlab .mat data file.
  %
  % Returns
  % -------
  % data_out : struct
  %     Structure containing the initial periodic solution data.
  %     Fields:
  %         - xdim : Dimension of the state space solution.
  %         - pdim : Dimension of the parameter space.
  %         - gamma_read : State space solution of the periodic orbit.
  %         - wn_read : Solution to the adjoint variational problem.
  %         - T_read : Period of the periodic orbit.
  %         - tbp_read : Temporal data of the periodic orbit.
  %         - p_system : Parameters of the solution.
  %         - pnames_system : Names of the parameters.
  %         - mu_s_read : Stable eigenvalue.
  %         - mu_s_name : Name of the stable eigenvalue.
  %
  % See Also
  % --------
  % coll_read_solution

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read COCO solution
  [sol, data] = coll_read_solution('adjoint', run_in, label_in);

  % Original dimension of state space
  xdim = 0.5 * data.xdim;
  % Original dimension of parameter space
  pdim = data.pdim - 3;

  % State space solution
  xbp_read = sol.xbp;
  
  % Periodic orbit solution
  gamma_read = xbp_read(:, 1:xdim);
  % Perpendicular solution
  wn_read    = xbp_read(:, xdim+1:end);

  % Initial zero-phase point of the periodic orbit
  gamma_0 = gamma_read(1, :)';
  % Initial perpendicular vector
  wn_0    = wn_read(1, :)';

  % Time data
  tbp_read = sol.tbp;

  %--------------------%
  %     Parameters     %
  %--------------------%
  p_read      = sol.p;
  pnames_read = data.pnames;

  % System parameters
  p_system      = p_read(1:pdim);
  pnames_system = {};
  for i = 1 : pdim
    pnames_system{i} = pnames_read{i};
  end

  % Stable eigenvalue
  mu_s_read = p_read(end-2);
  mu_s_name = pnames_read{end-2};

  % Period of segment
  T_read    = p_read(end);

  %----------------%
  %     Output     %
  %----------------%
  data_out.xdim          = xdim;
  data_out.pdim          = pdim;
  data_out.gamma_read    = gamma_read;
  data_out.wn_read       = wn_read;
  data_out.p_system      = p_system;
  data_out.pnames_system = pnames_system;
  data_out.mu_s_read     = mu_s_read;
  data_out.mu_s_name     = mu_s_name;
  data_out.tbp_read      = tbp_read;
  data_out.T_read        = T_read;

  %-------------------%
  %     Save Data     %
  %-------------------%
  save(filename_out, '-struct', 'data_out');

end