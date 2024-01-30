function [data_in, H_out] = bcs_PO_dudu(prob_in, data_in, u_in)
  % [data_in, H_out] = bcs_PO_dudu(prob_in, data_in, u_in)
  % 
  % Hessian of the periodic orbit boundary conditions.
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
  %          * u_in(1:2) - Initial point of the periodic orbit,
  %          * u_in(3:4) - Final point of the periodic orbit,
  %          * u_in(5)   - Parameters.
  %
  % Output
  % ----------
  % H_out : matrix of floats
  %     The Hessian w.r.t. u-vector components of the boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % Original vector field dimensions
  xdim = data_in.xdim;
  pdim = data_in.pdim;

  %---------------%
  %     Input     %
  %---------------%
  % Initial point of the periodic orbit
  x0         = u_in(1 : xdim);
  % Final point of the periodic orbit
  x1         = u_in(xdim+1 : 2*xdim);
  % Parameters
  parameters = u_in(2*xdim+1 : end);

  % Actual parameters
  c = parameters(1);
  a = parameters(2);
  b = parameters(3);
  z = parameters(4);

  %----------------%
  %     Output     %
  %----------------%
  % The Hessian
  H_out = zeros(3, 8, 8);

  H_out(3, 1, 1) = -3 * c * x0(1);
  H_out(3, 1, 5) = 1 - (3 / 2) * (x0(1) ^ 2);

  H_out(3, 2, 5) = 1;

  H_out(3, 5, 1) = 1 - (x0(1) ^ 2);
  H_out(3, 5, 2) = 1;
  H_out(3, 5, 8) = 1;

  H_out(3, 8, 5) = 1;

  % H_out(3, 1, 1) = -3 * c * x0(1);
  % H_out(3, 5, 1) = 1 - (3 / 2) * (x0(1) ^ 2);

  % H_out(3, 5, 2) = 1;

  % H_out(3, 1, 5) = 1 - (x0(1) ^ 2);
  % H_out(3, 2, 5) = 1;
  % H_out(3, 8, 5) = 1;

  % H_out(3, 5, 8) = 1;

end
