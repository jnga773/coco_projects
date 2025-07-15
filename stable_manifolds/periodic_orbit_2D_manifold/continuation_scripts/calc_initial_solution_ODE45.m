function data_out = calc_initial_solution_ODE45(x0_in, p0_in, field_in)
  % data_out = calc_initial_solution_PO(run_in, label_in)
  %
  % Calculate the initial periodic solution using ode45.
  %
  % Parameters
  % ----------
  % x0_in : array
  %     Initial state space point to feed into ODE45.
  % p0_in : array
  %     Initial parameters
  %
  % Returns
  % -------
  % data_out : struct
  %     Structure containing the initial periodic solution data.
  %     Fields:
  %         - p : Parameters of the solution.
  %         - pnames : Names of the parameters.
  %         - t : Time data of the solution.
  %         - x : State space solution.
  %         - x0 : Equilibrium point at x0.
  %         - xpos : Equilibrium point at xpos.
  %         - xneg : Equilibrium point at xneg.
  %
  % See Also
  % --------
  % ode45, non_trivial_ss

  %-------------------------------------------%
  %     Calculate Periodic Orbit Solution     %
  %-------------------------------------------%
  % Numerically integrate out for a long time
  [~, x_long] = ode45(@(t_in, x_in) field_in{1}(x_in, p0_in), [0.0, 400.0], x0_in);

  % Guess period
  T_PO = 41;

  % Do it for a short time
  [tbp_PO, xbp_PO] = ode45(@(t_in, x_in) field_in{1}(x_in, p0_in), [0.0, T_PO], x_long(end, :));

  %--------------------------------------%
  %     Calculate Equilibrium Points     %
  %--------------------------------------%
  % Calculate non-trivial solutions
  [xpos, xneg] = non_trivial_ss(p0_in);

  % Other point
  x0 = [p0_in(2), p0_in(3), 0];

  %----------------%
  %     Output     %
  %----------------%
  data_out.t      = tbp_PO;
  data_out.x      = xbp_PO;
  data_out.x0     = x0;
  data_out.xpos   = xpos;
  data_out.xneg   = xneg;  

end