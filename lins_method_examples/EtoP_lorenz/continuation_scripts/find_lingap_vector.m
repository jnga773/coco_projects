function data_out = find_lingap_vector(run_in)
  % data_out = find_lingap_vector(run_in)
  %
  % Calculates the Lin gap vector, the distance between the unstable
  % and stable trajectories, and the Lin phase condition from [run_in].
  %
  % Parameters
  % ----------
  % run_in : str
  %     The string identifier for the previous COCO run that we will
  %     read information from.
  %
  % Returns
  % -------
  % data_out : structure
  %     Data structure containing the Lin gap vector, distance, and phase.
  %
  % See Also
  % --------
  % coll_read_solution, coco_bd_read, coco_bd_labs

  %------------------------------------------%
  %     Read Solution: Unstable Manifold     %
  %------------------------------------------%
  % Read solution
  sol_u = coll_read_solution('unstable', run_in, 1);

  % Get end point at t = T1
  x1_unstable = sol_u.xbp(end, :);

  %--------------------------------------%
  %     Read Solutions from [run_in]     %
  %--------------------------------------%
  % Bifurcation data
  bd = coco_bd_read(run_in);
  % All labels
  labels_all = coco_bd_labs(bd, 'ALL');

  % Empty array for labels 
  labels = [];
  endpoints = [];
  % Cycle through labels and extract end points
  for lab = labels_all
      % Solution for stable manifold
      sol_s_temp = coll_read_solution('stable', run_in, lab);

      % Get end point at t = 0
      x0_stable_temp = sol_s_temp.xbp(1, :);

      % Append to array
      endpoints = [endpoints; x0_stable_temp];
      labels = [labels; lab];
  end

  %-----------------------------------------------%
  %     Find Closest Stable Manifold Solution     %
  %-----------------------------------------------%
  % Remap it so it works with the endpoints array
  pt = repmat(x1_unstable, [size(endpoints, 1),  1]);

  diff = (endpoints - pt) .* (endpoints - pt);
  diff_sum = sum(diff, 2);
  diff_sum_sqrt = sqrt(diff_sum);

  % Find min of diff_sum_sqrt
  [min_val, min_idx] = min(diff_sum_sqrt);

  % Take this point to be the solution
  % x0_stable = endpoints(min_idx, :);
  labels(min_idx);
  sol_s = coll_read_solution('stable', run_in, labels(min_idx));
  x0_stable = sol_s.xbp(1, :);

  %----------------------------------%
  %     Calculate Lin Gap Vector     %
  %----------------------------------%
  % Lin gap vector
  vgap = x0_stable - x1_unstable;

  % Calculate norm (i.e., the initial value of lingap)
  vgap_norm = norm(vgap, 2);

  % Add normalised Lin gap vector to data_out
  data_lins.vgap = vgap / vgap_norm;

  % Add value of norm to data_out
  data_lins.lingap0 = vgap_norm;
  data_lins.lingap  = vgap_norm;

  % Lin phase condition
  vphase_sol1 = endpoints(min_idx+1, :);
  vphase_sol2 = endpoints(min_idx-1, :);

  vphase = vphase_sol1 - vphase_sol2;
  vphase_norm = norm(vphase, 2);

  % Phase condition
  data_lins.vphase_vec = vphase / vphase_norm;
  data_lins.vphase = vphase_norm;

  %----------------%
  %     Output     %
  %----------------%
  % Save solution label too
  data_lins.min_label = labels(min_idx);

  % Output data structure
  data_out = data_lins;

end