function data_out = calc_initial_solution_PO(param_in, funcs_in)
  % data_out = calc_initial_solution_PO(param_in, funcs_in)
  %
  % Calculates the initial periodic orbit using MATLAB's built-in
  % ode45 to time-integrate a solution.

  % Field function
  field_func = funcs_in.field{1};

  %--------------------%
  %     Parameters     %
  %--------------------%
  p0_PO = param_in;

  % Outer (stable) periodic orbit initial vector
  x0_PO =[1.5, 0.0];
  t_PO_max = 2 * pi;

  % Time max
  t_long_max = 500;

  %-------------------------%
  %     Calculate Stuff     %
  %-------------------------%
  % Time arrays
  % t_long = 0.0:0.001:t_long_max;
  t_PO = 0.0:0.001:t_PO_max;

  % Evolve the state to an "steady state" to find oscillating periodic orbit
  % Solve using ode45 to long-time-limit
  [~, x_long] = ode45(@(t, x) field_func(x, p0_PO), [0, t_long_max], x0_PO);

  % Use the final solution from this run ^ as initial condition here
  [~, x_PO] = ode45(@(t, x) field_func(x, p0_PO), t_PO, x_long(end, :)');

  %----------------%
  %     Output     %
  %----------------%
  data_out.t = t_PO;
  data_out.x = x_PO;
  data_out.p = p0_PO;

end
