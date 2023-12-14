function [p_out, xbp_out, xss_out] = read_approximate_homoclinic_solution(label_in)
  % READ_APPROXIMATE_HOMOCLINIC_SOLUTION: Reads the solution from run
  % [run_in] and label [label_in] for the approximate homoclinic.
  % Returns the parameters, p1 and p2, the state-space solution, and
  % the approximate equilibrium point.

  % Approximate run name
  run_in = 'run04_continue_approximate_homoclinics';

  % Read solution and data
  [sol_po, ~] = po_read_solution('homo', run_in, label_in);
  [sol_ep, ~] = ep_read_solution('x0', run_in, label_in);

  % Parameters
  p_out = sol_po.p;
  % Xbp_solution
  xbp_out = sol_po.xbp;
  % Equilibrium point
  xss_out = sol_ep.x;


end