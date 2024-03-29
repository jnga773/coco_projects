function data_out = calc_PR_initial_conditions(run_in, label_in)
  % data_out = calc_initial_conditions(run_in, label_in)
  %
  % Reads data from previous run solution and calculates the 
  % initial conditions for the various different trajectory segments.
  
  % Original dimension of state space
  xdim = 2;
  % Original dimension of parameter space
  pdim = 2;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read COCO solution
  [sol, data] = coll_read_solution('adjoint', run_in, label_in);

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

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Initial parameters
  % System parameters
  p0_data.system        = p_system;
  % Integer for period
  p0_data.k             = 1;
  % Stable Floquet eigenvalue (should be = 1)
  p0_data.mu_s          = mu_s;
  % \theta_old (where perturbation starts)
  p0_data.theta_old     = 1.0;
  % \theta_new (where segment comes back to \Gamma)
  p0_data.theta_new     = 1.0;
  % Angle at which perturbation is applied?
  p0_data.theta_perturb = -pi;
  % Distance from perturbed segment to \Gamma
  p0_data.eta           = 0.0;
  % Size of perturbation
  p0_data.A             = 0.0;

  % Initial parameter array
  p0_out = [p0_data.system;
            p0_data.k;
            p0_data.mu_s;
            p0_data.theta_old;
            p0_data.theta_new;
            p0_data.theta_perturb;
            p0_data.eta;
            p0_data.A];

  % Parameter names
  pnames_PR = {pnames_system{1}; pnames_system{2};
               'k';                             % Integer for period
               'mu_s';                          % Stable Floquet eigenvalue (should be = 1)
               'theta_old';                     % \theta_old (where perturbation starts)
               'theta_new';                     % \theta_new (where segment comes back to \Gamma)
               'theta_perturb';                 % Angle at which perturbation is applied?
               'eta';                           % Distance from perturbed segment to \Gamma
               'A'};                            % Size of perturbation

  %------------------------------------%
  %     Segment Initial Conditions     %
  %------------------------------------%
  % Segment 1
  % t_seg1 = t_norm;
  t_seg1 = tbp;
  x_seg1 = [gamma_read, wn_read];
  
  % Segment 2
  % t_seg2 = [0.0; 1.0];
  t_seg2 = [0.0; T];
  x_seg2 = [[gamma_0'; gamma_0'], [wn_0'; wn_0']];
  
  % Segment 3
  % t_seg3 = [0.0; 1.0];
  t_seg3 = [0.0; T];
  x_seg3 = [gamma_0'; gamma_0'];
  
  % Segment 4
  % If only one period, i.e., k = 1, then the
  % input solutions remain unchanged
  % t_seg4 = t_norm;
  t_seg4 = tbp;
  x_seg4 = gamma_read;
  % Otherwise, keep appending periodic solutions
  if p0_data.k > 1
    % Cycle through k integers
    for j = 1 : p0_data.k-1
      % Append another period of time data
      % t_seg4 = [t_norm    ; 1 + t_seg4(2:end)];
      t_seg4 = [tbp    ; T + t_seg4(2:end)];
      x_seg4 = [gamma_read; x_seg4(2:end, :)];
    end
    % Normalise time data by integer
    t_seg4 = t_seg4 / p0_data.k;
  end

  %----------------%
  %     Output     %
  %----------------%
  % Parameters
  data_out.p0      = p0_out;
  data_out.pnames  = pnames_PR;
  data_out.p0_data = p0_data;

  % Initial time solutions for each segment
  data_out.t_seg1 = t_seg1;
  data_out.t_seg2 = t_seg2;
  data_out.t_seg3 = t_seg3;
  data_out.t_seg4 = t_seg4;

  % Initial state space solutions for each segment
  data_out.x_seg1 = x_seg1;
  data_out.x_seg2 = x_seg2;
  data_out.x_seg3 = x_seg3;
  data_out.x_seg4 = x_seg4;

end