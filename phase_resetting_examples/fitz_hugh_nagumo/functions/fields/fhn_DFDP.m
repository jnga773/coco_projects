function J_out = fhn_DFDP(x_in, p_in)
  % J_out = fhn_DFDXP(x_in, p_in)
  %
  % COCO encoding of the parameter-space Jacobian of the Fitz-Hugh-Nagumo
  % model vector field.
  %
  % Parameters
  % ----------
  % x_in : array, float
  %     State vector.
  % p_in : array, float
  %     Array of parameter values
  %
  % Returns
  % -------
  % y_out : array, float
  %     Matrix of the parameter-space derivative Jacobian.

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
  J_out = zeros(2, 4, numel(x1));

  J_out(1, 1, :) = (x2 + x1 - ((1/3) * (x1 .^ 3)) + z);
  J_out(1, 4, :) = c;


  J_out(2, 1, :) = (x1 - a + (b .* x2)) ./ (c .^ 2);
  J_out(2, 2, :) = 1 ./ c;
  J_out(2, 3, :) = -x2 ./ c;

end