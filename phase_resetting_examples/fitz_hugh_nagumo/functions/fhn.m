function y_out = fhn(x_in, p_in)
  % y_out = fhn(x_in, p_in)
  %
  % CoCo vectorised encoding of the Fitz-Hugh-Nagumo model
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
  % y_out : array, float
  %     The vector field.

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
  % The system of equations
  % y_out = zeros(2, 1);
  y_out(1, :) = c .* (x2 + x1 - ((1/3) * (x1 .^ 3)) + z);
  y_out(2, :) = (-1 ./ c) .* (x1 - a + (b .* x2));

end