function [vs_out, vo1_out, vo2_out, eigval_out] = stable_oscillating_eigenvectors(x0_neg_in, p0_in)
  % UNSTABLE_STABLE_EIGENVECTORS: Finds the stable and oscillating eigenvectors of
  % the Jacobian matrix for the x0_neg non-trivial equilibrium point.

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Calculate Jacobian
  J_L = lorenz_DFDX(x0_neg_in, p0_in);

  % Calculate eigenvalues
  [eigvec, eigval] = eig(J_L);

  % Indices for stable eigenvectors (eigval < 0)
  stable_index = find(diag(eigval) < 0);
  % Indices for oscillatory eigenvectors
  osc_index = find(diag(imag(eigval)) ~= 0);

  % Stable eigenvector
  vec_stable = eigvec(:, stable_index);
  % Stable eigenvalue
  lam_stable = eigval(stable_index, stable_index);

  % Oscillatory eigenvectors
  vec_osc1 = eigvec(:, osc_index(1));
  vec_osc2 = eigvec(:, osc_index(2));
  % Oscillatory eigenvalues
  lam_osc1 = eigval(osc_index(1), osc_index(1));
  lam_osc2 = eigval(osc_index(2), osc_index(2));

  %----------------%
  %     Output     %
  %----------------%
  % Normalised unstable eigenvector
  vs_out = vec_stable / norm(vec_stable, 2);

  % Normalised stable eigenvectors
  vo1_out = vec_osc1 / norm(vec_osc1, 2);
  vo2_out = vec_osc2 / norm(vec_osc2, 2);

  % Eigenvalues
  eigval_out = [lam_stable, lam_osc1, lam_osc2];

end