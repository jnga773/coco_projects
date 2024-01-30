function [data_in, J_out] = bcs_PR_seg4_du(prob_in, data_in, u_in)
  % [data_in, J_out] = bcs_PR_seg4_du(prob_in, data_in, u_in)
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
  %          * u_in(1:2)   - x0 of segment 2,
  %          * u_in(3:4)   - w0 of segment 2,
  %          * u_in(5:6)   - x0 of segment 3,
  %          * u_in(7:8)   - x0 of segment 4,
  %          * u_in(9:10)  - x1 of segment 4,
  %          * u_in(11:28) - Parameters.
  %
  % Output
  % ----------
  % J_out : matrix of floats
  %     The Jacobian w.r.t. u-vector components of the boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % (defined in calc_PR_initial_conditions.m)
  % State space dimensions
  xdim   = data_in.xdim;
  pdim   = data_in.pdim;
  % Parameter maps
  p_maps = data_in.p_maps;

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
  % p_system     = parameters(1 : pdim);

  % Phase resetting parameters
  % Integer for period
  % k             = parameters(p_maps.k);
  % Stable Floquet eigenvalue
  % mu_s          = parameters(p_maps.mu_s);
  % Distance from pertured segment to \Gamma
  eta           = parameters(p_maps.eta);
  % Phase where perturbation starts
  % theta_old     = parameters(p_maps.theta_old);
  % Phase where segment comes back to \Gamma
  % theta_new     = parameters(p_maps.theta_new);
  % Angle of perturbation
  theta_perturb = parameters(p_maps.theta_perturb);
  % Size of perturbation
  A             = parameters(p_maps.A);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Displacement vector
  % d_vec = [A * cos(theta_perturb); A * sin(theta_perturb)];
  d_vec = [parameters(p_maps.d_x); parameters(p_maps.d_y)];

  % Boundary Conditions - Segment 4
  % bcs_seg4_1    = x0_seg4 - x0_seg3 - (A * d_vec);
  % bcs_seg4_1    = x0_seg4 - x0_seg3 - d_vec;
  % bcs_seg4_2    = dot(x1_seg4 - x0_seg2, w0_seg2);
  % bcs_seg4_3    = norm(x1_seg4 - x0_seg2) - eta;

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian
  J_out = zeros(4, 23);

  J_out(1, 5)  = -1;
  J_out(1, 7)  = 1;
  J_out(1, 22) = -1;

  J_out(2, 6)  = -1;
  J_out(2, 8)  = 1;
  J_out(2, 23) = -1;

  J_out(3, 1)  = -(x1_seg4(1) - x0_seg2(1)) / sqrt( ((x1_seg4(1) - x0_seg2(1)) ^ 2) + ((x1_seg4(2) - x0_seg2(2)) ^ 2));
  J_out(3, 2)  = -(x1_seg4(2) - x0_seg2(2)) / sqrt( ((x1_seg4(1) - x0_seg2(1)) ^ 2) + ((x1_seg4(2) - x0_seg2(2)) ^ 2));
  J_out(3, 9)  = (x1_seg4(1) - x0_seg2(1)) / sqrt( ((x1_seg4(1) - x0_seg2(1)) ^ 2) + ((x1_seg4(2) - x0_seg2(2)) ^ 2));
  J_out(3, 10) = (x1_seg4(2) - x0_seg2(2)) / sqrt( ((x1_seg4(1) - x0_seg2(1)) ^ 2) + ((x1_seg4(2) - x0_seg2(2)) ^ 2));
  J_out(3, 17) = 1;

end
