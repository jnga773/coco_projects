function J_out = fhn_DFDX(x_in, p_in)
  % J_out = fhn_DFDX(x_in, p_in)
  %
  % COCO encoding of the state-space Jacobian of the Fitz-Hugh-Nagumo
  % model vector field.
  %
  % Input
  % ----------
  % x_in : array, float
  %     State vector
  % p_in : array, float
  %     Array of parameter values
  %
  % Output
  % ----------
  % J_out : matrix, float
  %     The state-space Jacobian matrix.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from x_in
  x1 = x_in(1, :);
  x2 = x_in(2, :);

  % Grab the parameter-space variables from p_in
  c = p_in(1, :);
  a = p_in(2, :);
  b = p_in(3, :);
  z = p_in(4, :);

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian
  J_out = zeros(2, 2, numel(x1));

  J_out(1, 1, :) = c .* (1 - (x1 .^ 2));
  J_out(1, 2, :) = c;

  J_out(2, 1, :) = -1 ./ c;
  J_out(2, 2, :) = -b ./ c;

end