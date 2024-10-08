function data_out = lins_method_setup(x0_u, x0_s, p_in, pnames_in)
  % data_out = lins_method_setup()
  %
  % Reads parameters and solution from previous approximate homoclinic
  % run and sets the initialised parameters for the Lin's method
  % problem.

  % Parameter names
  pnames = pnames_in;

  %----------------------------------%
  %     Setup Lin's Method Stuff     %
  %----------------------------------%
  % Calculate stable and unstable eigenvectors
  % [vu, ~] = find_jacobian_eigenvectors(x0_u, p_in)
  % [~, vs] = find_jacobian_eigenvectors(x0_s, p_in)
  [vu, vs] = unstable_stable_eigenvectors(p_in)

  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  eps1 = 0.1;
  eps2 = 0.05;

  % Lin epsilons vector
  epsilon0 = [eps1; eps2];

  % Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
  normal = [1, 0];
  % Intersection point for hyperplane
  pt0    = [0.6; 0.175];

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Initial time
  t0 = 0;

  % Unstable Manifold: Initial point
  x_init_u  = x0_u' + (eps1 * vu');
  % Unstable Manifold: Final point
  x_final_u = pt0;

  % Stable Manifold: Initial point
  x_init_s  = x0_s' + (eps2 * vs');
  % Stable Manifold: Final point
  x_final_s = pt0;

  %----------------%
  %     Output     %
  %----------------%
  data_out.p0        = p_in;
  data_out.pnames    = pnames;
  data_out.x0_u      = x0_u;
  data_out.x0_s      = x0_s;

  data_out.t0        = t0;
  data_out.x_init_u  = x_init_u;
  data_out.x_final_u = x_final_u;
  data_out.x_init_s  = x_init_s;
  data_out.x_final_s = x_final_s;

  data_out.normal    = normal;
  data_out.pt0       = pt0;
  data_out.epsilon0  = epsilon0;

end
