function [data_in, y_out] = bcs_Wq_final(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_Wq_final(prob_in, data_in, u_in)
  % 
  % COCO compatible encoding for the "initial" boundary conditions of the two
  % trajectory segments of the stable manifold of x_pos. Both segments
  % start near the equilibrium point, with boundary conditions:
  %           x1(1) = x_pos + (eps1 * vs) ,
  %           x2(1) = x_pos + (eps2 * vs) .
  % Here, eps1 and eps2 are the distances from of the trajectories to the equilbrium
  % points and vs is the stable eigenvector of the Jacobian at x_pos.
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
  %          * u_in(1:3)   - The final point of segment 1 of the manifold (x1_seg1),
  %          * u_in(4:6)   - The final point of segment 2 of the manifold (x1_seg2),
  %          * u_in(7:9)   - The x_pos equilibrium point (x_pos),
  %          * u_in(10:12) - Stable eigenvector (vs),
  %          * u_in(13:14) - The epsilon spacings (eps1, eps2).
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  % Original vector field dimensions
  xdim = data_in.xdim;
  pdim = data_in.pdim;

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Final vector of segment 1
  x1_seg1 = u_in(1 : xdim);
  % Final vector of segment 2
  x1_seg2 = u_in(xdim+1 : 2*xdim);
  % x_pos equilibrium point
  x_pos   = u_in(2*xdim+1 : 3*xdim);
  % Epsilon spacings and angle
  eps     = u_in(end);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Eigenvector matrix of the Jacobian of x_pos
  eigvec = data_in.ep_X;

  % Get stable eigenvector
  vs = eigvec(:, 3);

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Unstable boundary condition
  x_init_1 = x_pos + (eps * vs);

  % Stable boundary condition
  x_init_2 = x_pos - (eps * vs);

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [x1_seg1 - x_init_1;
           x1_seg2 - x_init_2];

end