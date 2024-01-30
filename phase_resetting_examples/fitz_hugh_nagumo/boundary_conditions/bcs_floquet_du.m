function [data_in, J_out] = bcs_floquet_du(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_floquet_du(prob_in, data_in, u_in)
  %
  % Jacobian of the boundary conditions of the Floquet adjoint
  % problem.
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
  %          * u_in(1:2) - Initial point of the perpendicular vector,
  %          * u_in(3:4) - Final point of the perpendicular vector,
  %          * u_in(5)   - Eigenvalue (mu_s),
  %          * u_in(6)   - Norm of w (w_norm).
  %
  % Output
  % ----------
  % J_out : matrix of floats
  %     The Jacobian w.r.t. u-vector components of the boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % State space dimension
  xdim = data_in.xdim;

  %---------------%
  %     Input     %
  %---------------%
  % Initial perpendicular vector
  w0 = u_in(1 : xdim);

  % Final perpendicular vector
  w1 = u_in(xdim+1 : 2 * xdim);

  % Eigenvector
  mu_s = u_in(end-1);
  
  % Norm of w
  w_norm = u_in(end);

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian
  J_out = zeros(3, 6);

  J_out(1, 1) = -mu_s;
  J_out(1, 3) = 1;
  J_out(1, 5) = -w0(1);

  J_out(2, 2) = -mu_s;
  J_out(2, 4) = 1;
  J_out(2, 5) = -w0(2);

  J_out(3, 1) = 2 * w0(1);
  J_out(3, 2) = 2 * w0(2);
  J_out(3, 6) = -1;

end
