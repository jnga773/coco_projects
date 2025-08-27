function data_out = calc_initial_solution_PR(run_in, label_in, k_in, theta_perturb_in, options)
  % data_out = calc_initial_solution_PR(run_in, label_in, k_in, theta_perturb_in, phi_perturb_in)
  %
  % Reads data from previous run solution and calculates the 
  % initial conditions for the various different trajectory segments.
  %
  % Parameters
  % ----------
  % run_in : string
  %     The run identifier for the continuation problem.
  % label_in : integer
  %     The label identifier for the continuation problem.
  % k_in : integer
  %     Integer for the periodicity.
  % theta_perturb_in : float
  %     Angle at which perturbation is applied.
  % phi_perturb_in : float
  %     Azimuthal angle at which perturbation is applied.
  % isochron : boolean
  %     Flag to determine if the isochron is being calculated.
  %
  % Returns
  % -------
  % data_out : struct
  %     Structure containing the initial conditions for the trajectory segments.
  %     Fields:
  %         - xdim : Original dimension of state space.
  %         - pdim : Original dimension of parameter space.
  %         - p0 : Initial parameter array.
  %         - pnames : Parameter names.
  %         - p_maps : Index mapping of each parameter.
  %         - t_seg1 : Initial time solutions for segment 1.
  %         - t_seg2 : Initial time solutions for segment 2.
  %         - t_seg3 : Initial time solutions for segment 3.
  %         - t_seg4 : Initial time solutions for segment 4.
  %         - x_seg1 : Initial state space solutions for segment 1.
  %         - x_seg2 : Initial state space solutions for segment 2.
  %         - x_seg3 : Initial state space solutions for segment 3.
  %         - x_seg4 : Initial state space solutions for segment 4.
  %
  % See Also
  % --------
  % coll_read_solution

  %-------------------%
  %     Arguments     %
  %-------------------%
  arguments
    run_in char
    label_in double
    k_in double             = 25
    theta_perturb_in double = 0.0

    % Optional arguments
    options.phi_perturb_in double = 0.5;
    options.isochron              = false;
  end

  %-----------------------------------------------------------------------%
  %                            Read Data                                  %
  %-----------------------------------------------------------------------%
  %--------------------------------------%
  %     Read Data: Equilibrium Point     %
  %--------------------------------------%
  % Read previous solution
  [sol_EP, data_EP] = ep_read_solution('x0', run_in, label_in);

  % Equilibrium point
  x0 = sol_EP.x;

  % Original dimension of state space
  xdim = data_EP.xdim;
  % Original dimension of parameter space
  pdim = data_EP.pdim;

  %-----------------------------------%
  %     Read Data: Periodic Orbit     %
  %-----------------------------------%
  % Read COCO solution
  [sol, data] = coll_read_solution('VAR', run_in, label_in);

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
  tbp_read = sol.tbp;

  %--------------------%
  %     Parameters     %
  %--------------------%
  p_read      = sol.p;
  pnames_read = data.pnames;

  % System parameters
  p_system      = p_read(1:pdim);
  pnames_system = {};
  for i = 1 : pdim
    pnames_system{i} = pnames_read{i};
  end

  % Stable eigenvalue
  mu_s_read = p_read(end-1);
  mu_s_name = pnames_read{end-1};

  %----------------------------%
  %     Initial Parameters     %
  %----------------------------%
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
  % Azimuthal angle at which perturbation is applied
  phi_perturb   = options.phi_perturb_in;
  % Perturbation vector components
  d_x           = 0.0;
  d_y           = 0.0;
  d_z           = 0.0;

  %---------------------------%
  %     Parameter Indices     %
  %---------------------------%
  % This p_maps data structure will be used in each boundary condition
  % function to ensure the correct parameters are being used.

  % Save the index mapping of each parameter
  p_maps.k               = pdim + 1;
  p_maps.theta_old       = pdim + 2;
  p_maps.theta_new       = pdim + 3;
  p_maps.mu_s            = pdim + 4;
  p_maps.eta             = pdim + 5;
  if ~options.isochron
    p_maps.A_perturb     = pdim + 6;
    p_maps.theta_perturb = pdim + 7;
    if xdim == 3
      p_maps.phi_perturb   = pdim + 8;
    end
  else
    p_maps.d_x           = pdim + 6;
    p_maps.d_y           = pdim + 7;
    if xdim == 3
      p_maps.d_z           = pdim + 8;
    end
  end

  %------------------------%
  %     Set Parameters     %
  %------------------------%
  % Initial parameter array
  p0_out = zeros(pdim+length(p_maps), 1);
  % Put parameters in order
  p0_out(1:pdim)                 = p_system;
  p0_out(p_maps.k)               = k;
  p0_out(p_maps.theta_old)       = theta_old;
  p0_out(p_maps.theta_new)       = theta_new;
  p0_out(p_maps.mu_s)            = mu_s;
  p0_out(p_maps.eta)             = eta;
  if ~options.isochron
    p0_out(p_maps.A_perturb)     = A_perturb;
    p0_out(p_maps.theta_perturb) = theta_perturb;
    if xdim == 3
      p0_out(p_maps.phi_perturb)   = phi_perturb;
    end
  else
    p0_out(p_maps.d_x)           = d_x;
    p0_out(p_maps.d_y)           = d_y;
    if xdim == 3
      p0_out(p_maps.d_z)           = d_z;
    end
  end

  %-------------------------%
  %     Parameter Names     %
  %-------------------------%
  % Parameter names
  pnames_PR                         = {pnames_system{1:pdim}};
  % Integer for period
  pnames_PR{p_maps.k}               = 'k';
  pnames_PR{p_maps.theta_old}       = 'theta_old';
  pnames_PR{p_maps.theta_new}       = 'theta_new';
  pnames_PR{p_maps.mu_s}            = 'mu_s';
  pnames_PR{p_maps.eta}             = 'eta';
  if ~options.isochron
    pnames_PR{p_maps.A_perturb}     = 'A_perturb';
    pnames_PR{p_maps.theta_perturb} = 'theta_perturb';
    if xdim == 3
      pnames_PR{p_maps.phi_perturb}   = 'phi_perturb';
    end
  else
    pnames_PR{p_maps.d_x}           = 'd_x';
    pnames_PR{p_maps.d_y}           = 'd_y';
    if xdim == 3
      pnames_PR{p_maps.d_z}           = 'd_z';
    end
  end

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

  % Equilibrium point
  data_out.x0         = x0;

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