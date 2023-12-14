function [data_in, y_out] = boundary_conditions_initial(prob_in, data_in, u_in)
  % [data_in, y_out] = boundary_conditions_initial(prob_in, data_in, u_in)
  %
  % COCO compatible encoding for the "initial" boundary conditions of the two
  % trajectory segments. 
  %
  % The unstable manifold starts near the equilibrium point x0_u, with
  %           x_u(0) = x0_u + eps1 * vu,
  % where eps1 is the distance from the equilibrium point, and vu is the unstable
  % eigenvector.
  %
  % The stable manifold ends near the equilibrium point x0_s, with
  %           x_s(T2) = x0_s(end) + eps2 * vs,
  % where eps2 is the distance from this point to the start of the trajectory,
  % and vs is the stable eigenvector.
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
  %          * u_in(1:2) - The initial point of the unstable manifold (x0_unstable),
  %          * u_in(3:4) - The final point of the stable manifold (x1_stable),
  %          * u_in(5)   - The system parameters (parameters),
  %          * u_in(6:7) - The epsilon spacings (eps).
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
  % Initial vector of the unstable manifold
  x0_unstable = u_in(1:2);

  % Final vector of the stable manifold
  x1_stable   = u_in(3:4);

  % System parameters
  parameters = u_in(5);

  % Epsilon spacings and angle
  eps = u_in(6:7);
  eps1 = eps(1); eps2 = eps(2);

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Find the equilibrium point and unstable and stable eigenvectors of the
  % Jacobian matrix.
  [x_ss, vu, vs] = unstable_stable_eigenvectors(parameters);

  % Unstable boundary condition
  x_init_u = x_ss + (eps1 * vu);

  % Stable boundary condition
  x_final_s = x_ss + (eps2 * vs);

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [x0_unstable - x_init_u ;
           x1_stable   - x_final_s];

end