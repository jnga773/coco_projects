function data_out = calc_stable_W_PO_initial_solution(run_in, label_in)
  % data_out = calc_stable_W_PO_initial_solution(filename_in)
  %
  % Calculate the stable manifold of the equilibrium point in the middle of
  % the periodic orbit.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read PO solution from previous run
  [sol_PO, data_PO] = coll_read_solution('po.orb', run_in, label_in);
  
  % State space solution
  xbp_PO = sol_PO.xbp;
  % Time
  tbp_PO = sol_PO.tbp;
  % Period
  T_PO   = sol_PO.T;
  % Parameters
  p      = sol_PO.p;
  % Parameter names
  pnames = data_PO.pnames;

  % % Read EP solution from previous run
  % sol_EP = ep_read_solution('xpos', run_in, label_in);
  % 
  % % Stationary point
  % xpos = sol_EP.x;

  %--------------------------------------%
  %     Periodic Orbit Floquet Stuff     %
  %--------------------------------------%
  % End point of periodic orbits
  xbp_end = xbp_PO(end, :);

  % Monodromy matrix
  chart = coco_read_solution('po.orb.coll.var', run_in, label_in, 'chart');
  data  = coco_read_solution('po.orb.coll', run_in, label_in, 'data');

  % Create monodrony matrix
  M1 = chart.x(data.coll_var.v1_idx);

  % Get eigenvalues and eigenvectors of the Monodromy matrix
  [floquet_vec, floquet_eig] = eig(M1);

  % Find index for stable eigenvector? < 1
  [lam_s, min_idx] = min(abs(diag(floquet_eig)));

  % Stable eigenvector
  vec_s = floquet_vec(:, min_idx);
  % Stable eigenvalue (Floquet thingie)
  lam_s = floquet_eig(min_idx, min_idx);

  %-------------------------------------%
  %     Setup Stable Manifold Stuff     %
  %-------------------------------------%
  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  eps = 0.01;

  % Initial time
  t0 = 0;

  % Initial state vector
  x_init_1 = xbp_end' + (eps * vec_s);
  x_init_2 = xbp_end' - (eps * vec_s);

  %----------------%
  %     Output     %
  %----------------%
  % Read periodic orbit solution
  data_out.xdim     = length(xbp_end);
  data_out.pdim     = length(p);

  data_out.p        = p;
  data_out.pnames   = pnames;

  data_out.vec_s    = vec_s;
  data_out.lam_s    = lam_s;

  data_out.xbp_PO   = xbp_PO;
  data_out.tbp_PO   = tbp_PO;
  data_out.T_PO     = T_PO;

  data_out.x_init_1 = x_init_1';
  data_out.x_init_2 = x_init_2';
  data_out.t0       = t0;
  data_out.eps      = eps;

end