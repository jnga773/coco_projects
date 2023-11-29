function data_out = lins_method_setup(run_in, label_in)
  % data_out = lins_method_setup(run_in, label_in)
  %
  % Calculates and saves the appropriate vectors and information
  % needed to setup the Lin's method, such as the initial vectors
  % of the unstable and stable manifolds, the initial displacements
  % (epsilon), normal vector and point on the \Signa plane, etc.
  %
  % Input
  % ----------
  % run_in : str
  %     The string identifier for the previous COCO run that we will
  %     read information from. In this case, it will be for the family
  %     of periodic orbits originating from the Hopf bifurcation.
  % label_in : int
  %     The solution label from the RUN_IN.
  %
  % Output
  % ----------
  % data_out : struct
  %     The data structure containing all of the initialisation
  %     information.
  %-----------------------------------------------------------------------%
  %%                         Setup Lin's Method                          %%
  %-----------------------------------------------------------------------%
  % Save run name and label
  data_out.run_old   = run_in;
  data_out.label_old = label_in;

  %-----------------------------------------%
  %     Read Solution from Previous Run     %
  %-----------------------------------------%
  % Read data
  [sol, data] = po_read_solution('hopf_po', run_in, label_in);

  % Read parameters from previous solution
  data_out.p0 = sol.p;

  % Add parameter names to data_out
  % data_out.pnames = pnames;
  % data_out.pnames = {'s', 'r', 'b'};

  % Final point of periodic orbit solution
  data_out.x_po_end = sol.xbp(end, :)';

  %---------------------------------------------------%
  %     Eigenvalues of Periodic Orbit (Monodromy)     %
  %---------------------------------------------------%
  % Calculate Floquet stable vector
  [data_out.vec_floquet, data_out.lam_floquet] = calculate_stable_floquet(run_in, label_in);

  %-----------------------------------------------%
  %     Set Parameters and Equilibrium Points     %
  %-----------------------------------------------%
  % Trivial equilibrium point
  data_out.x0 = [0; 0; 0];

  % Calculate unstable and stable eigenvectors of trivial equilibrium point
  [data_out.vu, ~, ~] = unstable_stable_eigenvectors(data_out.x0, data_out.p0);

  %----------------------------------%
  %     Setup Lin's Method Stuff     %
  %----------------------------------%
  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  eps1 = 0.1;
  eps2 = 0.1;

  % Lin epsilons vector
  data_out.epsilon0 = [eps1; eps2];

  %--------------------------------------------%
  %     Boundary Conditions data Structure     %
  %--------------------------------------------%
  % Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
  data_out.normal = [0, -1, 1] / sqrt(2);
  % Intersection point for hyperplane
  data_out.pt0 = [20.0; 20.0; 30.0];

  % Initial time
  data_out.t0 = 0;

  % Unstable Manifold: Initial point
  data_out.x_init_u = data_out.x0' + eps1 * data_out.vu';
  % Unstable Manifold: Final point
  data_out.x_final_u = data_out.pt0;

  % Stable Manifold: Initial point
  data_out.x_init_s = data_out.x_po_end' + eps2 * data_out.vec_floquet';
  % Stable Manifold: Final point
  data_out.x_final_s = data_out.pt0;
end