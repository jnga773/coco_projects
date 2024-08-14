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
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Reads the solution for the approximated large period periodic orbit
  % from a previous COCO run

  % Read solution and data
  [sol_po, data_po] = coll_read_solution('hopf_po.po.orb', run_in, label_in);

  % Parameters
  p_PO   = sol_po.p;
  % Xbp_solution
  xbp_PO = sol_po.xbp;
  % Parameter names
  pnames = data_po.pnames;
  % Dimensions
  xdim   = data_po.xdim;
  pdim   = data_po.pdim;

  % Read data
  [sol, data] = po_read_solution('hopf_po', run_in, label_in);

  % Read parameters from previous solution
  data_out.p0 = sol.p;

  % Final point of periodic orbit solution
  xbp_PO_end_point = xbp_PO(end, :)';

  %---------------------------------------------------%
  %     Eigenvalues of Periodic Orbit (Monodromy)     %
  %---------------------------------------------------%
  % Calculate Floquet stable vector
  [vec_floquet, lam_floquet] = calculate_stable_floquet(run_in, label_in);

  %-----------------------------------------------%
  %     Set Parameters and Equilibrium Points     %
  %-----------------------------------------------%
  % Trivial equilibrium point
  x0 = [0; 0; 0];

  % Calculate unstable and stable eigenvectors of trivial equilibrium point
  [vu, ~, ~] = unstable_stable_eigenvectors(x0, p_PO);

  %----------------------------------%
  %     Setup Lin's Method Stuff     %
  %----------------------------------%
  % Initial distances from the equilibria, along the tangent spaces of the
  % unstable and stable manifolds, to the initial points along the corresponding
  % trajectory segments.
  eps1 = 0.1;
  eps2 = 0.1;

  % Lin epsilons vector
  epsilon0 = [eps1; eps2];

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
  normal = [0, -1, 1] / sqrt(2);
  % Intersection point for hyperplane
  pt0 = [20.0; 20.0; 30.0];

  % Initial time
  t0 = 0;

  % Unstable Manifold: Initial point
  x_init_u = x0' + (eps1 * vu');
  % Unstable Manifold: Final point
  x_final_u = pt0;

  % Stable Manifold: Initial point
  x_init_s = xbp_PO_end_point' + (eps2 * vec_floquet');
  % Stable Manifold: Final point
  x_final_s = pt0;

  %----------------%
  %     Output     %
  %----------------%
  data_out.xdim        = xdim;
  data_out.pdim        = pdim;

  data_out.p0          = p_PO;
  data_out.pnames      = pnames;
  data_out.x0          = x0;
  data_out.xbp_PO      = xbp_PO;
  data_out.x_po_end    = xbp_PO_end_point;

  data_out.vu          = vu;
  data_out.vec_floquet = vec_floquet;
  data_out.lam_floquet = lam_floquet;

  data_out.t0          = t0;
  data_out.x_init_u    = x_init_u;
  data_out.x_final_u   = x_final_u;
  data_out.x_init_s    = x_init_s;
  data_out.x_final_s   = x_final_s;

  data_out.normal      = normal;
  data_out.pt0         = pt0;
  data_out.epsilon0    = epsilon0;

end