function data_out = calculate_periodic_orbit(run_in, label_in)
  % data_out = calculate_periodic_orbit(run_in, label_in)
  %
  % Calculates initial periodic solution using ode45

  %------------------%
  %     Read Data    %
  %------------------%
  % Read previous solution
  [sol, data] = po_read_solution('', run_in, label_in);

  % Initial period
  T_sol    = sol.T;
  % Parameters
  p_sol    = sol.p;
  % Read time data
  tbp      = sol.tbp;
  % Read state space solution
  xbp_read = sol.xbp;

  %----------------------------%
  %     Calculate Solution     %
  %----------------------------%
  % Need to find the point where e1 . F(x(t)) = 0, that is
  % the maximum of the first component.
  [~, max_idx] = max(xbp_read(:, 1));

  % Shift everything around
  if max_idx > 1
    x0 = [xbp_read(max_idx:end, :); xbp_read(2:max_idx, :)];
    t0 = [tbp(max_idx:end) - tbp(max_idx); tbp(2:max_idx) + (tbp(end) - tbp(max_idx))];
  end

  %----------------%
  %     Output     %
  %----------------%
  data_out.p      = p_sol;
  data_out.t      = t0;
  data_out.x      = x0;

end