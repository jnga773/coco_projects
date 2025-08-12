function y_out = winfree(x_in, p_in)
  % y_out = winfree(x_in, p_in)
  %
  % Winfree model in Euclidean coordinates, from 
  % "A Continuation Approach to Computing Phase Resetting Curves" by
  % Langfield et al.
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
  %     Array of the vector field encoding.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from x_in
  x = x_in(1, :);
  y = x_in(2, :);

  % Grab the parameter-space variables from p_in
  a = p_in(1, :);
  w = p_in(2, :);

  % square root bit
  sqrt_xy = sqrt( (x .^ 2) + (y .^ 2) );
  % front bit
  first_bit = 1 - sqrt_xy;
  
  %----------------%
  %     Output     %
  %----------------%
  % The system of equations

  % y_out = zeros(2, 1);
  y_out(1, :) = first_bit .* (x .* (sqrt_xy - a) + (w .* y)) + y;
  y_out(2, :) = first_bit .* (y .* (sqrt_xy - a) - (w .* x)) - x;

end