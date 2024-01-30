% % Add this function with the following code:
% % Add boundary conditions for segments 1 and 2
% prob = coco_add_func(prob, 'bcs_PR_seg1_seg2', @bcs_PR_seg1_seg2, data_in, 'zero', 'uidx', ...
%                      [uidx1(maps1.x0_idx);
%                       uidx2(maps2.x0_idx);
%                       uidx1(maps1.x1_idx);
%                       uidx2(maps2.x1_idx);
%                       uidx1(maps1.p_idx)]);

function [data_in, y_out] = bcs_PR_seg1_seg2(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_PR_seg1_seg2(prob_in, data_in, u_in)
  %
  % Boundary conditions for segments 1 and 2 of the phase reset
  % segments:
  %                        x1(0) - x2(1) = 0 ,
  %                        x1(1) - x2(0) = 0 ,
  %                        e1 . F(x1(0)) = 0 ,
  % and the adjoint boundary conditions:
  %                        x1(0) - x2(1) = 0 ,
  %                        x1(1) - x2(0) = 0 ,
  %                        e1 . F(x1(0)) = 0 ,
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
  %          * u_in(3:4)   - w0 of segment 1,
  %          * u_in(5:6)   - x0 of segment 2,
  %          * u_in(7:8)   - w0 of segment 2,
  %          * u_in(9:10)  - x1 of segment 1,
  %          * u_in(11:12) - w1 of segment 1,
  %          * u_in(13:14) - x1 of segment 2,
  %          * u_in(15:16) - w1 of segment 2,
  %          * u_in(17:35) - Parameters.
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
  xdim   = data_in.xdim;
  pdim   = data_in.pdim;
  % Parameter maps
  p_maps = data_in.p_maps;

  %---------------%
  %     Input     %
  %---------------%
  % Segment 1 - x(0)
  x0_seg1       = u_in(1 : xdim);
  % Segment 1 - w(0)
  w0_seg1       = u_in(xdim+1 : 2*xdim);

  % Segment 2 - x(0)
  x0_seg2       = u_in(2*xdim+1 : 3*xdim);
  % Segment 2 - w(0)
  w0_seg2       = u_in(3*xdim+1 : 4*xdim);
  
  % Segment 1 - x(1)
  x1_seg1       = u_in(4*xdim+1 : 5*xdim);
  % Segment 1 - w(1)
  w1_seg1       = u_in(5*xdim+1 : 6*xdim);

  % Segment 2 - x(1)
  x1_seg2       = u_in(6*xdim+1 : 7*xdim);
  % Segment 2 - w(1)
  w1_seg2       = u_in(7*xdim+1 : 8*xdim);

  %---------------------------%
  %     Input: Parameters     %
  %---------------------------%  
  % Parameters
  parameters    = u_in(8*xdim+1 : end);

  % System parameters
  p_system     = parameters(1 : pdim);

  % Phase resetting parameters
  % Integer for period
  % k             = parameters(p_maps.k);
  % Stable Floquet eigenvalue
  mu_s          = parameters(p_maps.mu_s);
  % Distance from pertured segment to \Gamma
  % eta           = parameters(p_maps.eta);
  % Phase where perturbation starts
  % theta_old     = parameters(p_maps.theta_old);
  % Phase where segment comes back to \Gamma
  % theta_new     = parameters(p_maps.theta_new);
  % Angle of perturbation
  % theta_perturb = parameters(p_maps.theta_perturb);
  % Size of perturbation
  % A             = parameters(p_maps.A);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Identity matrix
  ones_matrix = eye(xdim);
  % First component unit vector
  e1 = ones_matrix(1, :);

  % Boundary Conditions - Segments 1 and 2
  bcs_seg12_1   = x0_seg1 - x1_seg2;
  bcs_seg12_2   = x1_seg1 - x0_seg2;
  bcs_seg12_3   = e1 * fhn(x0_seg1, p_system);

  % Adjoint Boundary Conditions - Segments 1 and 2
  a_bcs_seg12_1 = w0_seg1 - w1_seg2;
  a_bcs_seg12_2 = (mu_s * w0_seg2) - w1_seg1;
  a_bcs_seg12_3 = norm(w0_seg2) - 1;

  %----------------%
  %     Output     %
  %----------------%
  y_out = [bcs_seg12_1;     % Vector field
           bcs_seg12_2;
           bcs_seg12_3;
           a_bcs_seg12_1;   % Adjoint equations
           a_bcs_seg12_2;
           a_bcs_seg12_3];

end
