function data_out = calc_PO_initial_solution(run_in, label_in)
  % data_out = calc_PO_initial_solution(run_in, label_in)
  %
  % Calculates initial periodic solution using ode45

  %----------------------------------%
  %     Read Data: Periodic Orbit    %
  %----------------------------------%
  % Read previous solution
  [sol, data] = coll_read_solution('po.orb', run_in, label_in);

  % Initial period
  T_sol    = sol.T;
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
  [sol_pos, ~] = ep_read_solution('xpos', run_in, label_in);
  [sol_neg, ~] = ep_read_solution('xneg', run_in, label_in);

  % Equilibrium points
  x0   = sol_0.x;
  xpos = sol_pos.x;
  xneg = sol_neg.x;

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
  data_out.xpos   = xpos;
  data_out.xneg   = xneg;  

end