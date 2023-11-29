function [x0_out, vu_out, vs_out] = unstable_stable_eigenvectors(p0_in)
  % UNSTABLE_STABLE_EIGENVECTOR: Finds the stable and unstable eigenvectors of
  % the Jacobian matrix for the x0_neg non-trivial equilibrium point.

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Calculate non-trivial steady states
  % x0_out = fsolve(@(x_in) fish(x_in, p0_in), [0; 0]);
  x0_out = [0; 0];

  % Calculate Jacobian
  J_L = func_DFDX(x0_out, p0_in);

  % Calculate eigenvalues
  [eigvec, eigval] = eig(J_L);

  % Inidices for unstable eigenvector (eigval > 0)
  unstable_index = diag(eigval) > 0;
  % Indices for stable eigenvectors (eigval < 0)
  stable_index = diag(eigval) < 0;

  % Unstable eigenvector
  vu = eigvec(:, unstable_index);
  % Stable eigenvector
  vs = eigvec(:, stable_index);

  %----------------%
  %     Output     %
  %----------------%
  % Normalised unstable eigenvector
  vu_out = -vu / norm(vu, 2);

  % Normalised stable eigenvector
  vs_out = -vs / norm(vs, 2);

end