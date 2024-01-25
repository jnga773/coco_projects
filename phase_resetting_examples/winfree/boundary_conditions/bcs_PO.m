function [data_in, y_out] = bcs_PO(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_PO(prob_in, data_in, u_in)
  % 
  % Boundary conditions for a periodic orbit,
  %                           x(1) - x(0) = 0 ,
  % in the 'coll' toolbox with the zero phase condition where:
  %                         e . F(x(0)) = 0,
  % that is, the first component of the vector field at t=0 is zero.
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
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % Dimension of state space vector
  xdim = data_in.xdim;

  %---------------%
  %     Input     %
  %---------------%
  % Initial point of the periodic orbit
  x0         = u_in(1:2);
  % Final point of the periodic orbit
  x1         = u_in(3:4);
  % Parameters
  parameters = u_in(5:6);

  %----------------%
  %     Output     %
  %----------------%
  % Periodic boundary conditions
  bcs1 = x0 - x1;
  % First component of the vector field is zero (phase condition)
  bcs2 = [1, 0] * winfree(x0, parameters);

  % Output
  y_out = [bcs1; bcs2];

end
