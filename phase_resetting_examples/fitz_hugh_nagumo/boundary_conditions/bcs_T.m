function [data_in, y_out] = bcs_T(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_T(prob_in, data_in, u_in)
  %
  % Boundary conditions for the segment period, T = 1.0.
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

  %---------------%
  %     Input     %
  %---------------%
  % Period
  T = u_in(1);

  %----------------%
  %     Output     %
  %----------------%
  y_out = T - 1.0;

end
