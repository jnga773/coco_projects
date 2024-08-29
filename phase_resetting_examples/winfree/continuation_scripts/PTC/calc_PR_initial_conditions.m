function data_out = calc_PR_initial_conditions(k_in, theta_perturb_in)
  % data_out = calc_initial_conditions(k_in, theta_perturb_in)
  %
  % Reads data from previous run solution and calculates the 
  % initial conditions for the various different trajectory segments.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read from .mat
  load('./data_mat/floquet_solution.mat', 'gamma_read', 'wn_read', ...
       'p_system', 'T_read', 'mu_s_read', ...
       'pnames_system', 'mu_s_name', ...
       'xdim', 'pdim', ...
       'tbp_read');

  % Initial zero-phase point of the periodic orbit
  gamma_0 = gamma_read(1, :)';
  % Initial perpendicular vector
  wn_0    = wn_read(1, :)';

  %----------------------------%
  %     Initial Parameters     %
  %----------------------------%
  % Period of segment
  T             = T_read;
  % Integer for period
  k             = k_in;
  % \theta_old (where perturbation starts)
  theta_old     = 1.0;
  % \theta_new (where segment comes back to \Gamma)
  theta_new     = 1.0;
  % Stable Floquet eigenvalue (should be = 1)
  mu_s          = mu_s_read;
  % Distance from perturbed segment to \Gamma
  eta           = 0.0;
  % Size of perturbation
  A_perturb     = 0.0;
  % Angle at which perturbation is applied?
  theta_perturb = theta_perturb_in;
  % Perturbation vector components
  d_x           = 0.0;
  d_y           = 0.0;

  %---------------------------%
  %     Parameter Indices     %
  %---------------------------%
  % This p_maps data structure will be used in each boundary condition
  % function to ensure the correct parameters are being used.

  % Save the index mapping of each parameter
  p_maps.T             = pdim + 1;
  p_maps.k             = pdim + 2;
  p_maps.theta_old     = pdim + 3;
  p_maps.theta_new     = pdim + 4;
  p_maps.mu_s          = pdim + 5;
  p_maps.eta           = pdim + 6;
  p_maps.A_perturb     = pdim + 7;
  p_maps.theta_perturb = pdim + 8;
  p_maps.d_x           = pdim + 9;
  p_maps.d_y           = pdim + 10;

  %------------------------%
  %     Set Parameters     %
  %------------------------%
  % Initial parameter array
  p0_out = zeros(pdim+length(p_maps), 1);
  % Put parameters in order
  p0_out(1:pdim)               = p_system;
  p0_out(p_maps.T)             = T;
  p0_out(p_maps.k)             = k;
  p0_out(p_maps.theta_old)     = theta_old;
  p0_out(p_maps.theta_new)     = theta_new;
  p0_out(p_maps.mu_s)          = mu_s;
  p0_out(p_maps.eta)           = eta;
  p0_out(p_maps.A_perturb)     = A_perturb;
  p0_out(p_maps.theta_perturb) = theta_perturb;
  p0_out(p_maps.d_x)           = d_x;
  p0_out(p_maps.d_y)           = d_y;

  %-------------------------%
  %     Parameter Names     %
  %-------------------------%
  % Parameter names
  pnames_PR                       = {pnames_system{1:pdim}};
  % Integer for period
  pnames_PR{p_maps.T}             = 'T';
  pnames_PR{p_maps.k}             = 'k';
  pnames_PR{p_maps.theta_old}     = 'theta_old';
  pnames_PR{p_maps.theta_new}     = 'theta_new';
  pnames_PR{p_maps.mu_s}          = mu_s_name;
  pnames_PR{p_maps.eta}           = 'eta';
  pnames_PR{p_maps.A_perturb}     = 'A_perturb';
  pnames_PR{p_maps.theta_perturb} = 'theta_perturb';
  pnames_PR{p_maps.d_x}           = 'd_x';
  pnames_PR{p_maps.d_y}           = 'd_y';

  %----------------------------------------------%
  %     Segment Initial Conditions: Periodic     %
  %----------------------------------------------%
  % Segment 4
  % If only one period, i.e., k = 1, then the
  % input solutions remain unchanged
  t_seg4 = tbp_read;
  x_seg4 = gamma_read;
  t_max  = t_seg4(end);

  for i = 1 : k-1
    % Append x_PO
    x_seg4 = [x_seg4; gamma_read(2:end, :)];

    % Append t_PO
    t_seg4 = [t_seg4; t_max + tbp_read(2:end)];

    t_max = t_seg4(end);
  end

  % Normalise by k
  t_seg4 = t_seg4 / k;

  %-----------------------------------------------%
  %     Segment Initial Conditions: Easy Mode     %
  %-----------------------------------------------%
  % Segment 1
  t_seg1 = tbp_read;
  x_seg1 = [gamma_read, wn_read];
  
  % Segment 2
  t_seg2 = [0.0; max(tbp_read)];
  x_seg2 = [[gamma_0'; gamma_0'], [wn_0'; wn_0']];
  
  % Segment 3
  t_seg3 = [0.0; max(tbp_read)];
  x_seg3 = [gamma_0'; gamma_0'];

  %----------------%
  %     Output     %
  %----------------%
  % Original vector field dimensions
  data_out.xdim       = xdim;
  data_out.pdim       = pdim;

  % Parameters
  data_out.p0         = p0_out;
  data_out.pnames     = pnames_PR;
  data_out.p_maps     = p_maps;

  % Initial time solutions for each segment
  data_out.t_seg1     = t_seg1;
  data_out.t_seg2     = t_seg2;
  data_out.t_seg3     = t_seg3;
  data_out.t_seg4     = t_seg4;

  % Initial state space solutions for each segment
  data_out.x_seg1     = x_seg1;
  data_out.x_seg2     = x_seg2;
  data_out.x_seg3     = x_seg3;
  data_out.x_seg4     = x_seg4;

end