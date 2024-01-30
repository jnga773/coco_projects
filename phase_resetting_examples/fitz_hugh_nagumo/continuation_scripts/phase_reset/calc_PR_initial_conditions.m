function data_out = calc_PR_initial_conditions(run_in, label_in)
  % data_out = calc_initial_conditions(run_in, label_in)
  %
  % Reads data from previous run solution and calculates the 
  % initial conditions for the various different trajectory segments.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read COCO solution
  [sol, data] = coll_read_solution('adjoint', run_in, label_in);

  % Original dimension of state space
  xdim = 0.5 * data.xdim;
  % Original dimension of parameter space
  pdim = data.pdim - 2;

  % State space solution
  xbp_read = sol.xbp;
  
  % Periodic orbit solution
  gamma_read = xbp_read(:, 1:xdim);
  % Perpendicular solution
  wn_read    = xbp_read(:, xdim+1:end);

  % Initial zero-phase point of the periodic orbit
  gamma_0 = gamma_read(1, :)';
  % Initial perpendicular vector
  wn_0    = wn_read(1, :)';

  % Time data
  tbp = sol.tbp;
  % Period of solution
  T   = sol.T;

  % Parameters
  p_read      = sol.p;
  pnames_read = data.pnames;

  % System parameters
  p_system      = p_read(1:pdim);
  pnames_system = {};
  for i = 1 : pdim
    pnames_system{i} = pnames_read{i};
  end

  % Stable eigenvalue
  mu_s        = p_read(end-1);
  mu_s_name   = pnames_read{end-1};

  %---------------------------%
  %     Parameter Indices     %
  %---------------------------%
  % This p_maps data structure will be used in each boundary condition
  % function to ensure the correct parameters are being used.

  % Save the index mapping of each parameter
  p_maps.k             = pdim + 1;
  p_maps.mu_s          = pdim + 2;
  p_maps.eta           = pdim + 3; 
  p_maps.theta_old     = pdim + 4;
  p_maps.theta_new     = pdim + 5;
  p_maps.theta_perturb = pdim + 6;
  p_maps.A             = pdim + 7;
  p_maps.d_x           = pdim + 8;
  p_maps.d_y           = pdim + 9;

  %----------------------------%
  %     Initial Parameters     %
  %----------------------------%
  % Initial parameters
  % System parameters
  p0_initial.system        = p_system;
  % Integer for period
  p0_initial.k             = 16;
  % Stable Floquet eigenvalue (should be = 1)
  p0_initial.mu_s          = mu_s;
  % Distance from perturbed segment to \Gamma
  p0_initial.eta           = 0.0;
  % \theta_old (where perturbation starts)
  p0_initial.theta_old     = 1.0;
  % \theta_new (where segment comes back to \Gamma)
  p0_initial.theta_new     = 1.0;
  % Angle at which perturbation is applied?
  p0_initial.theta_perturb = 0.0;
  % Size of perturbation
  p0_initial.A             = 0.0;
  % Initial displacement vector
  p0_initial.d_x           = p0_initial.A * cos(p0_initial.theta_perturb);
  p0_initial.d_y           = p0_initial.A * sin(p0_initial.theta_perturb);

  % Initial parameter array
  p0_out = zeros(pdim+9, 1);
  % Put parameters in order
  p0_out(1:pdim)               = p0_initial.system;
  p0_out(p_maps.k)             = p0_initial.k;
  p0_out(p_maps.eta)           = p0_initial.eta;
  p0_out(p_maps.theta_old)     = p0_initial.theta_old;
  p0_out(p_maps.theta_new)     = p0_initial.theta_new;
  p0_out(p_maps.theta_perturb) = p0_initial.theta_perturb;
  p0_out(p_maps.A)             = p0_initial.A;
  p0_out(p_maps.d_x)           = p0_initial.d_x;
  p0_out(p_maps.d_y)           = p0_initial.d_y;

  %-------------------------%
  %     Parameter Names     %
  %-------------------------%
  % Parameter names
  pnames_PR                       = {pnames_system{1:pdim}};
  % Integer for period
  pnames_PR{p_maps.k}             = 'k';
  % Stable Floquet eigenvalue (should be = 1)
  pnames_PR{p_maps.mu_s}          = mu_s_name;
  % Distance from perturbed segment to \Gamma
  pnames_PR{p_maps.eta}           = 'eta';
  % \theta_old (where perturbation starts)
  pnames_PR{p_maps.theta_old}     = 'theta_old';
  % \theta_new (where segment comes back to \Gamma)
  pnames_PR{p_maps.theta_new}     = 'theta_new';
  % Angle at which perturbation is applied?
  pnames_PR{p_maps.theta_perturb} = 'theta_perturb';
  % Size of perturbation
  pnames_PR{p_maps.A}             = 'A';
  % Displacement vector components
  pnames_PR{p_maps.d_x}           = 'd_x';
  pnames_PR{p_maps.d_y}           = 'd_y';

  %------------------------------------%
  %     Segment Initial Conditions     %
  %------------------------------------%
  % Segment 1
  t_seg1 = tbp;
  x_seg1 = [gamma_read, wn_read];
  
  % Segment 2
  t_seg2 = [0.0; T];
  x_seg2 = [[gamma_0'; gamma_0'], [wn_0'; wn_0']];
  
  % Segment 3
  t_seg3 = [0.0; T];
  x_seg3 = [gamma_0'; gamma_0'];
  
  % Segment 4
  % If only one period, i.e., k = 1, then the
  % input solutions remain unchanged
  t_seg4 = tbp;
  x_seg4 = gamma_read;

  % Otherwise, keep appending periodic solutions
  if p0_initial.k > 1
    % Cycle through k integers
    for j = 1 : p0_initial.k-1
      % Append another period of time data
      t_seg4 = [tbp    ; T + t_seg4(2:end)];
      x_seg4 = [gamma_read; x_seg4(2:end, :)];
    end
    % Normalise time data by integer
    t_seg4 = t_seg4 / p0_initial.k;
  end

  %----------------%
  %     Output     %
  %----------------%
  % Original vector field dimensions
  data_out.xdim    = xdim;
  data_out.pdim    = pdim;

  % Parameters
  data_out.p0      = p0_out;
  data_out.pnames  = pnames_PR;
  data_out.p0_initial = p0_initial;
  data_out.p_maps  = p_maps;

  % Initial time solutions for each segment
  data_out.t_seg1  = t_seg1;
  data_out.t_seg2  = t_seg2;
  data_out.t_seg3  = t_seg3;
  data_out.t_seg4  = t_seg4;

  % Initial state space solutions for each segment
  data_out.x_seg1  = x_seg1;
  data_out.x_seg2  = x_seg2;
  data_out.x_seg3  = x_seg3;
  data_out.x_seg4  = x_seg4;

end