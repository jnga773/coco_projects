function [data_in, J_out] = bcs_PR_seg3_du(prob_in, data_in, u_in)
  % [data_in, J_out] = bcs_PR_seg3_du(prob_in, data_in, u_in)
  %
  % Jacobian of the boundary conditions with respect to the u-vector
  % components for segment 3.
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
  %          * u_in(1:2)   - x0 of segment 1,
  %          * u_in(3:4)   - x1 of segment 3,
  %
  % Output
  % ----------
  % J_out : matrix of floats
  %     The Jacobian w.r.t. u-vector components of the boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % (defined in calc_PR_initial_conditions.m)
  % Original vector space dimensions
  xdim = data_in.xdim;

  %---------------%
  %     Input     %
  %---------------%
  % Segment 1 - x(0)
  x0_seg1 = u_in(1 : xdim);
  % Segment 3 - x(1)
  x1_seg3 = u_in(xdim+1 : end);

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian
  J_out = zeros(2, 4);

  J_out(1, 1) = -1;
  J_out(2, 3) = 1;

  J_out(2, 2) = -1;
  J_out(2, 4) = 1;

end
