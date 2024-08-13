function po_data_out = insert_large_time_segment(run_in, label_in)
  % po_data_out = insert_large_time_segment(run_in, label_in)
  %
  % Reads the periodic orbit solution from solution [label_old] of
  % [run_old], and finds the segment of the state-space solution
  % closest to the equilibrium point.
  %
  % With this point found, we insert a large time segment to
  % "trick" the periodic orbit into having a larger period.
  %
  % Input
  % ----------
  % run_in: string
  %     The string identifier for the previous COCO run that we will
  %     read information from.
  % label_in: int
  %     The solution label we will read the data from
  %
  % Output
  % ----------
  % po_data_out : data structure
  %     Contains the state space solution, temporal solution and
  %     parameters.

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read solution with maximum period
  [sol, data] = coll_read_solution('po.orb', run_in, label_in);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Evaluate vector field at basepoints
  f = marsden(sol.xbp', repmat(sol.p, [1, size(sol.xbp, 1)]));

  % Extract the discretisation points corresponding to the minimum value of
  % the norm of the vector field along the longest-period periodic orbit.
  % Find basepoint closest to equilibrium
  f_norm = sqrt(sum(f .* f, 1)); f_norm = f_norm';
  [~, idx] = min(f_norm);

  % Print
  % fprintf('\n');
  % fprintf('idx = %d \n', idx);

  % Then insert a time segment that is a large multiple of the orbit
  % period immediately following the discretisation point.
  scale = 1000;
  T = sol.T;

  % fprintf('Maximum Period from run ''%s'', T = %f \n', run_new, T);
  % fprintf('Scaled period is T'' = %d x %f = %f \n', scale, T, scale * T);

  % Crank up period by factor scale
  t_sol = [sol.tbp(1:idx,1);
           T * (scale - 1) + sol.tbp(idx+1:end,1)];

  % Approximate equilibrium point
  x0 = sol.xbp(idx, :);

  %----------------%
  %     Output     %
  %----------------%
  % Temporal solution
  po_data_out.t_sol = t_sol;
  % State-space solution
  po_data_out.x_sol = sol.xbp;
  % Parameters
  po_data_out.p0    = sol.p;
  % Equilibrium point
  po_data_out.x0    = x0;
  % NTST setting from previous run
  po_data_out.NTST  = data.coll.NTST;

end