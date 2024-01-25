function [data_in, y_out] = bcs_isochron(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_isochron(prob_in, data_in, u_in)
  %
  % Boundary conditions for the isochron, that is:
  %            \theta_old - \theta_new = 0 .
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
  %          * u_in(1) - theta_new
  %          * u_in(2) - theta_old
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
  % \theta_old
  theta_old = u_in(1);
  % \theta_new
  theta_new = u_in(2);

  %----------------%
  %     Output     %
  %----------------%
  y_out = [theta_new - theta_old];

end