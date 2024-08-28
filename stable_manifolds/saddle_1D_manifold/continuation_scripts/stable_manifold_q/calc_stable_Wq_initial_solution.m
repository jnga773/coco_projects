function data_out = calc_stable_Wq_initial_solution(run_in, label_in)
  % data_out = calc_stable_Wq_initial_solution(filename_in)
  %
  % Calculate the stable manifold of the equilibrium point in the middle of
  % the periodic orbit.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read PO solution from previos run
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

  % Read EP solution from previous run
  [sol_pos, ~] = ep_read_solution('xpos', run_in, label_in);

  % Stationary point
  xpos = sol_pos.x;
  
  % DFDX function
  func_DFDX = data_PO.dfdxhan;

  %------------------------------------------------%
  %     Calculate Eigenvectors and Eigenvalues     %
  %------------------------------------------------%
  % Calculate non-trivial steady states
  J = func_DFDX(xpos, p);

  % Calculate eigenvalues and eigenvectors
  [eigval, eigvec] = eig(J);

  % Stable eigenvalue and eigenvector
  ls = eigval(3, 3);
  vs = eigvec(:, 3);

  %-------------------------------------%
  %     Setup Stable Manifold Stuff     %
  %-------------------------------------%
  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  eps = 0.001;

  % Initial time
  t0 = 0;

  % Initial state vector
  x_init_1 = xpos + (eps * vs);
  x_init_2 = xpos - (eps + vs);

  %----------------%
  %     Output     %
  %----------------%
  % Load PO solution data
  data_out.p        = p;
  data_out.pnames   = pnames;

  data_out.xbp_PO   = xbp_PO;
  data_out.tbp_PO   = tbp_PO;
  data_out.T_PO     = T_PO;

  data_out.x_init_1 = x_init_1';
  data_out.x_init_2 = x_init_2';
  data_out.t0       = t0;

  data_out.ls       = ls;
  data_out.vs       = vs;

  data_out.eps      = eps;

end