% % Add this function with the following code:
% % Add boundary conditions for segment 3
% prob = coco_add_func(prob, 'bcs_PR_seg3', @bcs_PR_seg3, data_in, 'zero', 'uidx', ...
%                      [uidx1(maps1.x0_idx(1:2));
%                       uidx3(maps3.x1_idx)]);

function [data_in, y_out] = bcs_PR_seg3(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_PR_seg3(prob_in, data_in, u_in)
  %
  % Boundary conditions for segment three of the phase reset
  % segments:
  %                        x3(1) - x1(0) = 0 .
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
  % y_out : array of vectors
  %     An array containing the boundary conditions.
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

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Boundary Conditions - Segment 3
  bcs_seg3 = x1_seg3 - x0_seg1;

  %----------------%
  %     Output     %
  %----------------%
  y_out = bcs_seg3;

end
