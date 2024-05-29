% % Add this function with the following code:
% % Add boundary conditions for segment 4
% prob = coco_add_func(prob, 'bcs_PR_seg4', @bcs_PR_seg4, data_in, 'zero', 'uidx', ...
%                      [uidx2(maps2.x0_idx);
%                       uidx3(maps3.x0_idx);
%                       uidx4(maps4.x0_idx);
%                       uidx4(maps4.x1_idx);
%                       uidx1(maps1.p_idx)]);

function [data_in, y_out] = bcs_PR_seg4(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_PR_seg4(prob_in, data_in, u_in)
  %
  % Boundary conditions for segment four of the phase reset
  % segments:
  %                x4(0) - x3(0) - A d_r = 0 ,
  %              (x4(1) - x2(0)) . w2(0) = 0 ,
  %             | x4(1) - x2(0) | - \eta = 0 .
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
  %          * u_in(1:2)   - x0 of segment 2,
  %          * u_in(3:4)   - w0 of segment 2,
  %          * u_in(5:6)   - x0 of segment 3,
  %          * u_in(7:8)   - x0 of segment 4,
  %          * u_in(9:10)  - x1 of segment 4,
  %          * u_in(11:28) - Parameters.
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing the boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % (defined in calc_PR_initial_conditions.m)
  % State space dimensions
  xdim   = data_in.xdim;
  pdim   = data_in.pdim;
  % Parameter maps
  p_maps = data_in.p_maps;

  % Isochron check
  isochron_check = data_in.isochron_check;

  %---------------%
  %     Input     %
  %---------------%
  % Segment 2 - x(0)
  x0_seg2    = u_in(1 : xdim);
  % Segment 2 - w(0)
  w0_seg2    = u_in(xdim+1 : 2*xdim);
  % Segment 3 - x(0)
  x0_seg3    = u_in(2*xdim+1 : 3*xdim);
  % Segment 4 - x(0)
  x0_seg4    = u_in(3*xdim+1 : 4*xdim);
  % Segment 4 - x(1)
  x1_seg4    = u_in(4*xdim+1 : 5*xdim);

  %---------------------------%
  %     Input: Parameters     %
  %---------------------------%
  % Parameters
  parameters = u_in(5*xdim+1 : end);
  
  % Distance from pertured segment to \Gamma
  eta           = parameters(p_maps.eta);
  % Angle of perturbation
  theta_perturb = parameters(p_maps.theta_perturb);
  % Size of perturbation
  A_perturb     = parameters(p_maps.A_perturb);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  if isochron_check == true
    % Calculating isochrons doesn't work with varying A_perturb and
    % theta_perturb for some unknown reason.
    % Displacement vector
    d_vec = [parameters(p_maps.d_x); parameters(p_maps.d_y)];

  else
    % Displacement vector
    d_vec = [cos(theta_perturb); sin(theta_perturb)];
    d_vec = A_perturb * d_vec;

  end

  % Boundary Conditions - Segment 4
  bcs_seg4_1    = x0_seg4 - x0_seg3 - d_vec;
  bcs_seg4_2    = dot(x1_seg4 - x0_seg2, w0_seg2);
  bcs_seg4_3    = norm(x1_seg4 - x0_seg2) - eta;

  %----------------%
  %     Output     %
  %----------------%
  y_out = [bcs_seg4_1;
           bcs_seg4_2;
           bcs_seg4_3];

end
