function [vu_out, vs1_out, vs2_out] = unstable_stable_eigenvectors(x0_in, p0_in)
  % Finds the stable and unstable eigenvectors of the Jacobian matrix for the
  % x0_neg non-trivial equilibrium point.

  % Calculate Jacobian
  J_L = marsden_DFDX(x0_in, p0_in);

  % Calculate eigenvalues
  [eigvec, eigval] = eig(J_L);

  % Inidices for unstable eigenvector (eigval > 0)
  unstable_index = find(diag(eigval) > 0);
  % Indices for stable eigenvectors (eigval < 0)
  stable_index = find(diag(eigval) < 0);

  % eigval(1, 1)
  % eigval(2, 2)
  % eigval(3, 3)

  % Unstable eigenvector
  vu = eigvec(:, unstable_index);
  % Stable eigenvector
  vec_stable = eigvec(:, stable_index);
  vs1 = vec_stable(:, 1);
  vs2 = vec_stable(:, 2);

  % % Eigenvalues
  % lu = eigval(unstable_index, unstable_index);
  % lv = eigval(stable_index, stable_index);

  % Normalise
  vu_out = vu / norm(vu, 2);
  vs1_out = vs1 / norm(vs1, 2);
  vs2_out = vs2 / norm(vs2, 2);

end