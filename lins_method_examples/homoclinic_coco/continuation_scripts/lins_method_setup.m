function data_out = lins_method_setup(run_in, label_in)
  % data_out = lins_method_setup()
  %
  % Reads parameters and solution from previous approximate homoclinic
  % run and sets the initialised parameters for the Lin's method
  % problem.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Reads the solution for the approximated large period periodic orbit
  % from a previous COCO run

  % Read solution and data
  [sol_po, data_po] = coll_read_solution('homo.po.orb', run_in, label_in);
  [sol_ep, ~] = ep_read_solution('x0', run_in, label_in);

  % Parameters
  p_PO   = sol_po.p;
  % Xbp_solution
  xbp_PO = sol_po.xbp;
  % Equilibrium point
  x_ss   = sol_ep.x;
  % Parameter names
  pnames = data_po.pnames;
  % Dimensions
  xdim   = data_po.xdim;
  pdim   = data_po.pdim;

  %----------------------------------%
  %     Setup Lin's Method Stuff     %
  %----------------------------------%
  % Calculate stable and unstable eigenvectors
  [vu, vs1, vs2] = unstable_stable_eigenvectors(x_ss, p_PO);

  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  eps1 = -0.1;
  eps2 = 0.1;

  % Angle for stable vector component
  theta0 = 0.5 * pi;

  % Lin epsilons vector
  epsilon0 = [eps1; eps2; theta0];

  % Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
  normal = [0, 0, 1];
  % Intersection point for hyperplane
  pt0 = [0.0; 0.44; 0.1];

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Initial time
  t0 = 0;

  % Unstable Manifold: Initial point
  x_init_u = x_ss' + eps1 * vu';
  % Unstable Manifold: Final point
  x_final_u = pt0;

  % Stable Manifold: Initial point
  x_init_s = x_ss' + eps2 * (cos(theta0) * vs1' + sin(theta0) * vs2');
  % Stable Manifold: Final point
  x_final_s = pt0;

  %----------------%
  %     Output     %
  %----------------%
  data_out.xdim      = xdim;
  data_out.pdim      = pdim;

  data_out.p0        = p_PO;
  data_out.pnames    = pnames;
  data_out.x_ss      = x_ss;
  data_out.xbp_PO    = xbp_PO;

  data_out.t0        = t0;
  data_out.x_init_u  = x_init_u;
  data_out.x_final_u = x_final_u;
  data_out.x_init_s  = x_init_s;
  data_out.x_final_s = x_final_s;

  data_out.normal    = normal;
  data_out.pt0       = pt0;
  data_out.epsilon0  = epsilon0;

end
