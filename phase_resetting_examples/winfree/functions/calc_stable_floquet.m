function [vec_out, val_out] = calc_stable_floquet(run_in, label_in)
  % [vec_out, val_out] = calc_stable_floquet(run_in, label_in)
  %
  % Read the monodromy matrix, and then calculate and output the stable
  % Floquet eigenvector and eigenvalue.
   
  %--------------------------------%
  %     Read Data and Solution     %
  %--------------------------------%
  % Find good label to plot
  label_plot = 1;

  % Read one of the solutions
  chart = coco_read_solution('winfree.po.orb.coll.var', run_in, label_in, 'chart');
  data  = coco_read_solution('winfree.po.orb.coll', run_in, label_in, 'data');

  % Create monodrony matrix
  M1 = chart.x(data.coll_var.v1_idx);

  fprintf('~~~ Monodromy Matrix ~~~\n');
  fprintf('(%.7f, %.7f)\n', M1(1, :));
  fprintf('(%.7f, %.7f)\n', M1(2, :));

  %------------------------------------------------%
  %     Calculate Eigenvalues and Eigenvectors     %
  %------------------------------------------------%
  % Calculate eigenvalues and eigenvectors
  [eigvecs, eigvals] = eig(M1);

  % Eigen 1
  vec1 = eigvecs(:, 1);
  val1 = eigvals(1, 1);
  fprintf('vec1  = (%f, %f) \n', vec1);
  fprintf('val1  = %f \n\n', val1);

  % Eigen 2
  vec2 = eigvecs(:, 2);
  val2 = eigvals(2, 2);
  fprintf('vec2  = (%f, %f) \n', vec2);
  fprintf('val2  = %f \n\n', val2);

  %----------------%
  %     Output     %
  %----------------%
  if val1 < 1
      vec_out = vec1;
      val_out = val1;
  elseif val2 < 1
      vec_out = vec2;
      val_out = val2;
  end

end