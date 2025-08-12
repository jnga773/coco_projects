function [vec_out, lam_out] = calculate_stable_floquet(run_in, label_in)
  % [vec_out, lam_out] = calculate_stable_floquet(run_in, label_in)
  %
  % Calculates the stable eigenvalue and eigenvector (Floquet stuff) of a 
  % periodic orbit from solution [label_in] of [run_in].
  %
  % Parameters
  % ----------
  % run_in : character
  %    String identifier for the COCO run.
  % label_in : double
  %    Integer label for the solution to read.
  %
  % Returns
  % -------
  % vec_out : array (double)
  %    Stable eigenvector.
  % lam_out : double
  %    Stable eigenvalue.
  %
  % See Also
  % --------
  % coco_read_solution
  
  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read one of the solutions
  chart = coco_read_solution('', run_in, label_in, 'chart');
  data  = coco_read_solution('hopf_po.po.orb.coll', run_in, label_in, 'data');

  % Create monodrony matrix
  M = chart.x(data.coll_var.v1_idx);

  %------------------------------------------------%
  %     Calculate Eigenvalues and Eigenvectors     %
  %------------------------------------------------%
  % Calculate eigenvalues and eigenvectors
  [v, d] = eig(M);

  % Find index for stable eigenvector? < 1
  ind = find(abs(diag(d)) < 1);

  % Stable eigenvector
  vec0 = -v(:, ind);
  % Stable eigenvalue (Floquet thingie)
  lam0 = d(ind, ind);

  %----------------%
  %     Output     %
  %----------------%
  vec_out = vec0;
  lam_out = lam0;

end