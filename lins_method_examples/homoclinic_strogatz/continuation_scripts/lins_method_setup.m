function data_out = lins_method_setup(x0_in, p_in, pnames_in)
  % data_out = lins_method_setup(p_in)
  %
  % Sets up initial solution to the Lin methods continuation problem.

  %---------------%
  %     Input     %
  %---------------%
  x_ss = x0_in;
  
  %----------------------------------%
  %     Setup Lin's Method Stuff     %
  %----------------------------------%
  % Calculate non-trivial steady states
  [~, vu, vs] = unstable_stable_eigenvectors(p_in);

  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  % eps1 = 0.1;
  % eps2 = 0.05;
  eps1 = 0.2;
  eps2 = 0.2;

  % Lin epsilons vector
  epsilon0 = [eps1; eps2];

  % Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
  normal = [0, 1];
  % Intersection point for hyperplane
  pt0 = [0.5; 0.2];

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
  x_init_s = x_ss' + eps2 * vs';
  % Stable Manifold: Final point
  x_final_s = pt0;

  %----------------%
  %     Output     %
  %----------------%
  data_out.p0        = p_in;
  data_out.pnames    = pnames_in;
  data_out.x_ss      = x0_in;

  data_out.t0        = t0;
  data_out.x_init_u  = x_init_u;
  data_out.x_final_u = x_final_u;
  data_out.x_init_s  = x_init_s;
  data_out.x_final_s = x_final_s;

  data_out.normal    = normal;
  data_out.pt0       = pt0;
  data_out.epsilon0  = epsilon0;

end
