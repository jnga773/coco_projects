function [data_in, y_out] = boundary_conditions_initial(prob_in, data_in, u_in)
  % [data_in, y_out] = boundary_conditions_initial(prob_in, data_in, u_in)
  %
  % COCO compatible encoding for the "initial" boundary conditions of the two
  % trajectory segments. 
  %
  % The unstable manifold starts near the equilibrium point x0=[0, 0, 0], with
  %           x_u(0) = x0 + eps1 * vu,
  % where eps1 is the distance from the equilibrium point, and vu is the unstable
  % eigenvector.
  %
  % The stable manifold starts near the end point of the periodic orbit, with
  %           x_s(T2) = x_PO(end) + eps2 * vs,
  % where x_PO(end) is the final point of the periodic orbit, eps2 is the distance
  % from this point to the start of the trajectory, and vs is the stable Floquet
  % vector.
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with function data.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the following (as imposed by coco_add_func):
  %          * u_in(1:3)   - The initial point of the unstable manifold (x0_unstable),
  %          * u_in(4:6)   - The final point of the stable manifold (x1_stable),
  %          * u_in(7:9)   - The end point of the periodic orbit (x_final_po),
  %          * u_in(10:12) - The system parameters (parameters),
  %          * u_in(13:15) - The stable Floquet vector (vec_floquet),
  %          * u_in(16:17) - The epsilon spacings (eps).
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Initial vector of the unstable manifold from the equilibrium point
  x0_unstable = u_in(1:3);
  % Final vector of the stable manifold from the periodic orbit
  x1_stable   = u_in(4:6);
  % Final point of periodic orbit solution
  x_final_po  = u_in(7:9);

  % System parameters
  parameters  = u_in(10:12);

  % Eigenvector indices
  vec_floquet = u_in(13:15);

  % Epsilon spacings
  eps         = u_in(16:17);
  eps1 = eps(1); eps2 = eps(2);

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Trivial equilibrium point
  x0 = [0; 0; 0];

  % Find the equilibrium point and unstable and stable eigenvectors of the
  % Jacobian matrix.
  [vu, ~, ~] = unstable_stable_eigenvectors(x0, parameters);

  % Unstable boundary conditions
  x_init_u = x0 + (eps1 * vu);

  % Stable manifold boundary condition
  x_final_s = x_final_po + (eps2 * vec_floquet);

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [x0_unstable - x_init_u;
           x1_stable   - x_final_s];

end