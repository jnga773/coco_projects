function plot_base_diagram(ax_in, p0_in, varargin)
  % PLOT_BASE_DIAGRAM: Plots base solutions calculated from ODE45. This will
  % be called in PLOT_RUN_I().

  %--------------------------------%
  %     Calculate Eigenvectors     %
  %--------------------------------%
  [vu_in, vs_in] = find_jacobian_eigenvectors([0; 0], p0_in);
  vs = sign(vs_in(1)) * vs_in;
  vu = sign(vu_in(1)) * vu_in;

  % ode45 parameters
  opts = odeset('RelTol', 1.0e-6, 'AbsTol', 1.0e-6, 'NormControl', 'on');

  %---------------------------------------%
  %      Calculate and Plot Solutions     %
  %---------------------------------------%
  % Calculate
  X = linspace(-0.3, 0, 300);
  [t, x] = ode45(@(t_in, x_in) huxley(x_in, p0_in), [0 11.5], -1.0e-4*vu, opts); %#ok<ASGLU>
  Y = interp1([0; x(:, 1)], [0; x(:, 2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  [t, x] = ode45(@(t_in, x_in) -huxley(x_in, p0_in), [0 11.5], -1.0e-4*vs, opts); %#ok<ASGLU>
  Y = interp1([0; x(:, 1)], [0; x(:, 2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  X = linspace(0,0.5,500);
  [t, x] = ode45(@(t_in, x_in) huxley(x_in, p0_in), [0 13.5], 1.0e-4*vu, opts); %#ok<ASGLU>
  Y = interp1([0;x(:,1)], [0;x(:,2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  [t, x] = ode45(@(t_in, x_in) -huxley(x_in, p0_in), [0 13.5], 1.0e-4*vs, opts); %#ok<ASGLU>
  Y = interp1([0;x(:,1)], [0;x(:,2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  X = linspace(1,1.3,300);
  [t, x] = ode45(@(t_in, x_in) huxley(x_in, p0_in), [0 11.5], [1;0]+1.0e-4*vu, opts); %#ok<ASGLU>
  Y = interp1([1;x(:,1)], [0;x(:,2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  [t, x] = ode45(@(t_in, x_in) -huxley(x_in, p0_in), [0 11.5], [1;0]+1.0e-4*vs, opts); %#ok<ASGLU>
  Y = interp1([1;x(:,1)], [0;x(:,2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  X = linspace(0.5,1,500);
  [t, x] = ode45(@(t_in, x_in) huxley(x_in, p0_in), [0 13.5], [1;0]-1.0e-4*vu, opts); %#ok<ASGLU>
  Y = interp1([1;x(:,1)], [0;x(:,2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

  % Calculate
  [t, x] = ode45(@(t_in, x_in) -huxley(x_in, p0_in), [0 13.5], [1;0]-1.0e-4*vs, opts); %#ok<ASGLU>
  Y = interp1([1;x(:,1)], [0;x(:,2)], X);
  % Plot
  plot(ax_in, X, Y, varargin{:})

end