function data_out = find_lingap_vector(run_in, label_in)
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
  % label_in : int
  %     The solution label for the previous solution we will read
  %     information from.
  %
  % Returns
  % -------
  % data_out : structure
  %     Data structure containing the Lin gap vector and distance.
  %
  % See Also
  % --------
  % coll_read_solution, coco_bd_read, coco_bd_labs

  %--------------------------------------%
  %     Read Solutions from [run_in]     %
  %--------------------------------------%
  % Extract solution of unstable manifold
  [solu, ~] = coll_read_solution('unstable', run_in, 1);

  % Extract solution of stable manifold
  [sols, ~] = coll_read_solution('stable', run_in, label_in);

  % Final point of unstable manifold
  x1_unstable = solu.xbp(end, :);

  % Initial point of stable manifold
  x0_stable = sols.xbp(1, :);

  %----------------------------------%
  %     Calculate Lin Gap Vector     %
  %----------------------------------%
  % Lin gap vector
  % vgap = x1_unstable - x0_stable;
  vgap = x0_stable - x1_unstable;

  % Calculate norm (i.e., the initial value of lingap)
  vgap_norm = norm(vgap, 2);
  
  % Add normalised Lin gap vector to data_out
  data_lins.vgap = vgap / vgap_norm;

  % Add value of norm to data_out
  data_lins.lingap0 = vgap_norm;
  data_lins.lingap  = vgap_norm;

  %----------------%
  %     Output     %
  %----------------%
  data_out = data_lins;

end