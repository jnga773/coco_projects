function [data_in, y_out] = distance_to_singularity(prob_in, data_in, u_in)
  % [data_in, y_out] = distance_to_singularity(prob_in, data_in, u_in)
  %
  % This function calculates the distance and the angle from a point on the 
  % the periodic orbit to the equilibrium point / singularity in the
  % centre of the periodic orbit.
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
  %          * u_in(1:2) - Initial point of segment 4 on the
  %                        periodic orbit.
  %          * u_in(3:4) - Equilibrium point from 'EP' toolbox.
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the monitor function stuff.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % Original dimensions of vector space
  xdim = data_in.xdim;
  
  %---------------%
  %     Input     %
  %---------------%
  % Initial point on segment four
  x0_seg4 = u_in(1 : xdim);

  % Equilibrium point
  x_ep    = u_in(xdim : end);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Displacement from equilibrium point
  x_distance = x0_seg4(1) - x_ep(1);
  y_distance = x0_seg4(2) - x_ep(2);

  % Actual displacement
  displacement = sqrt( (x_distance ^ 2) + (y_distance ^ 2));

  % Angle of displacement from x-axis
  angle = atan2(y_distance, x_distance) / (2 * pi);
  
  %----------------%
  %     Output     %
  %----------------%
  y_out = [displacement;
           angle;
           x_distance];
  
end
