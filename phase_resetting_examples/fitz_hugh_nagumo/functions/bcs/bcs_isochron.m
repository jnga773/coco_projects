function [data_in, y_out] = bcs_isochron(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_isochron(prob_in, data_in, u_in)
  %
  % Boundary conditions for the four segments of the phase-resetting problem:
  %                          x1(0) - x2(1) = 0 ,
  %                          x1(1) - x2(0) = 0 ,
  %                          e1 . F(x1(0)) = 0 ,
  %                          w1(0) - w2(1) = 0 ,
  %                     mu_s w2(0) - w1(1) = 0 ,
  %                            |w2(0)| - 1 = 0 ,
  %                          x3(1) - x1(0) = 0 ,
  %                x4(0) - x3(0) - A_p d_p = 0 ,
  %                (x4(1) - x2(0)) . w2(0) = 0 ,
  %               | x4(1) - x2(0) | - \eta = 0 .
  %
  % The difference between this function and bcs_PR_segs is that, here, 
  % the displacement vector is defined by two separate component
  % parameters: d_{p} = (d_x, d_y).
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
  %            u_in(1:3)   - x(0) of segment 1,
  %            u_in(4:6)   - w(0) of segment 1,
  %            u_in(7:9)   - x(0) of segment 2,
  %            u_in(10:12) - w(0) of segment 2,
  %            u_in(13:15) - x(0) of segment 3,
  %            u_in(16:18) - x(0) of segment 4,
  %            u_in(19:21) - x(1) of segment 1,
  %            u_in(22:24) - w(1) of segment 1,
  %            u_in(25:27) - x(1) of segment 2,
  %            u_in(28:30) - w(1) of segment 2,
  %            u_in(31:33) - x(1) of segment 3,
  %            u_in(34:36) - x(1) of segment 4,
  %            u_in(37:50) - Parameters.
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
  % Vector field
  field = @fhn;

  %============================================================================%
  %                              INPUT PARAMETERS                              %
  %============================================================================%
  %--------------------------------%
  %     Input: Initial Vectors     %
  %--------------------------------%
  % Segment 1 - x(0)
  x0_seg1       = u_in(1 : xdim);
  % Segment 1 - w(0)
  w0_seg1       = u_in(xdim+1 : 2*xdim);
  % Segment 2 - x(0)
  x0_seg2       = u_in(2*xdim+1 : 3*xdim);
  % Segment 2 - w(0)
  w0_seg2       = u_in(3*xdim+1 : 4*xdim);
  % Segment 3 - x(0)
  x0_seg3       = u_in(4*xdim+1 : 5*xdim);
  % Segment 4 - x(0)
  x0_seg4       = u_in(5*xdim+1 : 6*xdim);

  %------------------------------%
  %     Input: Final Vectors     %
  %------------------------------%
  % Segment 1 - x(1)
  x1_seg1       = u_in(6*xdim+1 : 7*xdim);
  % Segment 1 - w(1)
  w1_seg1       = u_in(7*xdim+1 : 8*xdim);
  % Segment 2 - x(1)
  x1_seg2       = u_in(8*xdim+1 : 9*xdim);
  % Segment 2 - w(1)
  w1_seg2       = u_in(9*xdim+1 : 10*xdim);
  % Segment 3 - x(1)
  x1_seg3       = u_in(10*xdim+1 : 11*xdim);
  % Segment 4 - x(1)
  x1_seg4       = u_in(11*xdim+1 : 12*xdim);

  %---------------------------%
  %     Input: Parameters     %
  %---------------------------%
  % Parameters
  parameters    = u_in(12*xdim+1 : end);

  % System parameters
  p_system     = parameters(1 : pdim);

  % Phase resetting parameters
  % Period of the segment
  % T             = parameters(p_maps.T);
  % Integer for period
  % k             = parameters(p_maps.k);
  % Phase where perturbation starts
  % theta_old     = parameters(p_maps.theta_old);
  % Phase where segment comes back to \Gamma
  % theta_new     = parameters(p_maps.theta_new);
  % Stable Floquet eigenvalue
  mu_s          = parameters(p_maps.mu_s);
  % Distance from pertured segment to \Gamma
  eta           = parameters(p_maps.eta);
  % Size of perturbation
  % A_perturb     = parameters(p_maps.A_perturb);
  % Angle of perturbation
  % theta_perturb = parameters(p_maps.theta_perturb);
  % Perturbation vector components
  d_x = parameters(p_maps.d_x);
  d_y = parameters(p_maps.d_y);

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  %---------------------------------%
  %     Segment 1 and Segment 2     %
  %---------------------------------%
  % Identity matrix
  ones_matrix = eye(xdim);
  % First component unit vector
  e1 = ones_matrix(1, :);

  % Boundary Conditions - Segments 1 and 2
  bcs_seg12_1   = x0_seg1 - x1_seg2;
  bcs_seg12_2   = x1_seg1 - x0_seg2;
  bcs_seg12_3   = e1 * field(x0_seg1, p_system);

  % Adjoint Boundary Conditions - Segments 1 and 2
  a_bcs_seg12_1 = w0_seg1 - w1_seg2;
  a_bcs_seg12_2 = (mu_s * w0_seg2) - w1_seg1;
  a_bcs_seg12_3 = norm(w0_seg2) - 1;

  %-------------------%
  %     Segment 3     %
  %-------------------%
  % Boundary Conditions - Segment 3
  bcs_seg3 = x1_seg3 - x0_seg1;

  %-------------------%
  %     Segment 4     %
  %-------------------%
  % Perturbation vector
  d_vec = [d_x; d_y];

  % Boundary Conditions - Segment 4
  bcs_seg4_1 = x0_seg4 - x0_seg3 - d_vec;
  bcs_seg4_2 = dot(x1_seg4 - x0_seg2, w0_seg2);
  bcs_seg4_3 = norm(x1_seg4 - x0_seg2) - eta;
  % bcs_seg4_3 = (norm(x1_seg4 - x0_seg2) ^ 2) - eta;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %----------------%
  %     Output     %
  %----------------%
  y_out = [bcs_seg12_1;
           bcs_seg12_2;
           bcs_seg12_3;
           a_bcs_seg12_1;
           a_bcs_seg12_2;
           a_bcs_seg12_3;
           bcs_seg3;
           bcs_seg4_1;
           bcs_seg4_2;
           bcs_seg4_3];

end
