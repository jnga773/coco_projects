function [vu_out, vs_out] = find_jacobian_eigenvectors(x0_in, p0_in)
  % Finds the stable and unstable eigenvectors from the Jacobian

  % Calculate the Jacobian for some equilibrium point x0_in
  J = huxley_DFDX(x0_in, p0_in);

  % Find the eigenvalues and eigenvectors
  [eigvec, eigval] = eig(J);

  % Inidices for unstable eigenvalue (eigval > 0)
  unstable_index = find(diag(real(eigval)) > 0);
  % Indices for stable eigenvalue (eigval < 0)
  stable_index   = find(diag(real(eigval)) < 0);

  % Eigenvalues
  unstable_value = eigval(unstable_index, unstable_index);
  stable_vale    = eigval(stable_index, stable_index);

  % Unstable eigenvector
  vu = eigvec(:, unstable_index);
  % Stable eigenvector
  vs   = eigvec(:, stable_index);

  % Normalise
  vu_out = vu / norm(vu);
  vs_out   = vs / norm(vs);

  % Get the correct signs?
  vu_out = vu_out * sign(vu_out(2));
  vs_out = vs_out * sign(vs_out(2));

end