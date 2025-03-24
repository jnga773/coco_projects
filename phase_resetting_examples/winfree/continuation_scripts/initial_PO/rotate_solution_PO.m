function data_out = calc_initial_solution_PO(run_in, label_in)
  % data_out = calc_initial_solution_PO(run_in, label_in)
  %
  % Calculate the initial periodic solution using ode45.
  %
  % This function reads the previous solution data for the periodic orbit and equilibrium points,
  % calculates the initial periodic solution, and shifts the solution to start at the maximum of
  % the first component.
  %
  % Parameters
  % ----------
  % run_in : string
  %     The run identifier for the continuation problem.
  % label_in : int
  %     The solution label for the continuation problem.
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
  % coll_read_solution, ep_read_solution

  %----------------------------------%
  %     Read Data: Periodic Orbit    %
  %----------------------------------%
  % Read previous solution
  [sol, data] = coll_read_solution('po.orb', run_in, label_in);

  % % Initial period
  % T_sol    = sol.T;
  % Parameters
  p_sol    = sol.p;
  % Read time data
  tbp      = sol.tbp;
  % Read state space solution
  xbp_read = sol.xbp;
  % Parameter names
  pnames   = data.pnames;

  %---------------------------------------%
  %     Read Data: Equilibrium Points     %
  %---------------------------------------%
  % Read solutions
  [sol_0, ~] = ep_read_solution('x0', run_in, label_in);

  % Equilibrium points
  x0   = sol_0.x;

  %----------------------------%
  %     Calculate Solution     %
  %----------------------------%
  % Need to find the point where e1 . F(x(t)) = 0, that is
  % the maximum of the first component.
  [~, max_idx] = max(xbp_read(:, 1));

  % Shift everything around
  if max_idx > 1
    xbp_shifted = [xbp_read(max_idx:end, :); xbp_read(2:max_idx, :)];
    t0 = [tbp(max_idx:end) - tbp(max_idx); tbp(2:max_idx) + (tbp(end) - tbp(max_idx))];
  end

  %----------------%
  %     Output     %
  %----------------%
  data_out.p      = p_sol;
  data_out.pnames = pnames;
  data_out.t      = t0;
  data_out.x      = xbp_shifted;
  data_out.x0     = x0; 

end