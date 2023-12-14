function [vu_out, vs_out] = unstable_stable_eigenvectors(parameters_in)
  % UNSTABLE_STABLE_EIGENVECTORS: Finds the stable and unstable eigenvectors of
  % the Jacobian matrix from analytic expressions

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  p1 = parameters_in(1);
  p2 = parameters_in(2);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Unstable eigenvector
  vu = [sqrt(4 * p1 + (p2 ^ 2)) - p2; 2 * p1];
  % Stable eigenvector
  vs = [-sqrt(4 * (1 - p1) + (p2 ^ 2)) - p2; 2 * (1 - p1)];
  % Normalise
  vu = vu / norm(vu, 2);
  vs = vs / norm(vs, 2);

  %----------------%
  %     Output     %
  %----------------%
  vu_out = vu;
  vs_out = vs;

end