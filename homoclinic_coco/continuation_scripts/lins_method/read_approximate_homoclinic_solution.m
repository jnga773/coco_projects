function [p_out, xbp_out, xss_out] = read_approximate_homoclinic_solution(label_in)
  % READ_APPROXIMATE_HOMOCLINIC_SOLUTION: Reads the solution from run
  % [run_in] and label [label_in] for the approximate homoclinic.
  % Returns the parameters, p1 and p2, the state-space solution, and
  % the approximate equilibrium point.

  % Approximate run name
  run_in = 'run04_continue_approximate_homoclinics';

  % Read solution and data
  [sol, ~] = po_read_solution('', run_in, label_in);

  % Parameters
  p_out = sol.p;
  % Xbp_solution
  xbp_out = sol.xbp;
  % Equilibrium point
  xss_out = xbp_out(1, :)';

end