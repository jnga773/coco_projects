function save_floquet_data(run_in, label_in)
  % save_floquet_data(run_in, label_in)
  %
  % Saves floquet data to MATLAB .mat file

  % Data matrixc filename
  filename_out = './data_mat/floquet_solution.mat';

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

  %-------------------%
  %     Save Data     %
  %-------------------%
  save(filename_out, 'xdim', 'pdim', 'gamma_read', 'wn_read', ...
       'p_system', 'pnames_system', 'mu_s_read', 'mu_s_name', ...
       'tbp_read', 'T_read');

end