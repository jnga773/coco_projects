function [vu_out, vs1_out, vs2_out] = unstable_stable_eigenvectors(x0_neg_in, p0_in)
  % UNSTABLE_STABLE_EIGENVECTORS: Finds the stable and unstable eigenvectors of
  % the Jacobian matrix for the x0_neg non-trivial equilibrium point.

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Calculate Jacobian
  J_L = lorenz_DFDX(x0_neg_in, p0_in);

  % Calculate eigenvalues
  [eigvec, eigval] = eig(J_L);

  % Inidices for unstable eigenvector (eigval > 0)
  unstable_index = find(diag(eigval) > 0);
  % Indices for stable eigenvectors (eigval < 0)
  stable_index = find(diag(eigval) < 0);

  % Unstable eigenvector
  vu = eigvec(:, unstable_index);
  % Stable eigenvector
  vec_stable = eigvec(:, stable_index);
  vs1 = vec_stable(:, 1);
  vs2 = vec_stable(:, 2);

  %----------------%
  %     Output     %
  %----------------%
  % Normalised unstable eigenvector
  % vu_out = vu;
  vu_out = vu * (48 / vu(2));
  % vu_out = vu  / norm(vu, 2);

  % Normalised stable eigenvectors
  vs1_out = vs1;
  vs2_out = vs2;
  % vs1_out = vs1 / norm(vs1, 2);
  % vs2_out = vs2 / norm(vs2, 2);

end