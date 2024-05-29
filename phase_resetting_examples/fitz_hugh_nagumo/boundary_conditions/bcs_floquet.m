function [data_in, y_out] = bcs_floquet(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_floquet(prob_in, data_in, u_in)
  %
  % Boundary conditions for the Floquet multipliers with the adjoint equation
  %                  d/dt w = -J^{T} w    .
  % The boundary conditions we require are the eigenvalue equations and that
  % the norm of w is equal to 1:
  %                   w(1) = \mu_{f} w(0) ,                         (1)
  %                norm(w) = w_norm       .                         (2)
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
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % State space dimension
  xdim = data_in.xdim;

  %---------------%
  %     Input     %
  %---------------%
  % Initial perpendicular vector
  w0     = u_in(1 : xdim);

  % Final perpendicular vector
  w1     = u_in(xdim+1 : 2 * xdim);

  % Eigenvector
  mu_s   = u_in(end-2);
  
  % Norm of w
  w_norm = u_in(end-1);

  % Period
  T      = u_in(end);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Adjoint boundary conditions
  bcs_adjt_1 = w1 - (mu_s * w0);
  bcs_adjt_2 = (w0' * w0) - w_norm;

  %----------------%
  %     Output     %
  %----------------%
  y_out = [bcs_adjt_1;
           bcs_adjt_2];

end
