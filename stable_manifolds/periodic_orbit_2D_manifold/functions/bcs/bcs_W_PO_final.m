function [data_in, y_out] = bcs_W_PO_final(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_W_PO_final(prob_in, data_in, u_in)
  %
  % COCO compatible encoding for the "initial" boundary conditions of the two
  % trajectory segments of the stable manifold of the saddle periodic
  % orbit. Both segments start near the periodic orbit along the stable
  % Floquet vector,, with
  %           x1(1) = x_PO_end + (eps1 * vs) ,
  %           x2(1) = x_PO_end + (eps2 * vs) .
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
  %          * u_in(7:9)   - The end point of the periodic orbit (x_PO_end),
  %          * u_in(10:12) - The stable floquet vector (vec_floquet),
  %          * u_in(13:14) - The epsilon spacings and theta angle (eps1, eps2).
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  % State- and parameter-space dimensions
  xdim = data_in.xdim;
  pdim = data_in.pdim;

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Initial vector of the unstable manifold
  x1_seg1     = u_in(1 : xdim);
  % Final vector of the stable manifold
  x1_seg2     = u_in(xdim+1 : 2*xdim);
  % Final point of periodic orbit solution
  x_PO_end    = u_in(2*xdim+1 : 3*xdim);
  % Eigenvector indices
  vec_floquet = u_in(3*xdim+1 : 4*xdim);
  % Epsilon spacings and angle
  eps         = u_in(end);

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Unstable boundary condition
  x_init_1 = x_PO_end + (eps * vec_floquet);

  % Stable boundary condition
  x_init_2 = x_PO_end - (eps * vec_floquet);

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [x1_seg1 - x_init_1 ;
           x1_seg2 - x_init_2];

end