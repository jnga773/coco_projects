% % Add this function with the following code:
% % Add boundary conditions for segment 4
% prob = coco_add_func(prob, 'bcs_PR_seg4', @bcs_PR_seg4, data4, 'zero', 'uidx', ...
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

  % State space dimensions
  xdim = data_in.xdim;
  pdim = data_in.pdim;

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

  % System parameters
  p_system     = parameters(1 : pdim);

  % Phase resetting parameters
  % Integer for period
  k             = parameters(pdim+1);
  % Stable Floquet eigenvalue
  mu_s          = parameters(pdim+2);
  % Phase where perturbation starts
  theta_old     = parameters(pdim+3);
  % Phase where segment comes back to \Gamma
  theta_new     = parameters(pdim+4);
  % Angle of perturbation
  theta_perturb = parameters(pdim+5);
  % Distance from pertured segment to \Gamma
  eta           = parameters(pdim+6);
  % Size of perturbation
  A             = parameters(pdim+7);
  % Displacement vector
  d_vec         = [parameters(pdim+8); parameters(pdim+9)];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Displacement vector
  % d_vec = [cos(theta_perturb); sin(theta_perturb)];

  % Boundary Conditions - Segment 4
  % bcs_seg4_1    = x0_seg4 - x0_seg3 - (A * d_vec);
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
