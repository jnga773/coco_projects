function F_out = winfree_symbolic_field(x_in, p_in)
  % F_out = winfree_symbolic_field(x_in, p_in)
  %
  % Symbolic notation of the Winfree model vector field.
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
  % F_out : array, float
  %     Symbolic vector field.

  %---------------%
  %     Input     %
  %---------------%
  % Grab the state-space variables from x_in
  x1    = x_in(1);
  x2    = x_in(2);

  % Grab the parameter-space variables from p_in
  a     = p_in(1);
  omega = p_in(2);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % square root bit
  sqrt_xy = sqrt( (x1 .^ 2) + (x2 .^ 2) );
  % front bit
  first_bit = 1 - sqrt_xy;

  % Vector field components
  F1 = first_bit .* (x1 .* (sqrt_xy - a) + (omega .* x2)) + x2;
  F2 = first_bit .* (x2 .* (sqrt_xy - a) - (omega .* x1)) - x1;

  % Vector field
  F_vec = [F1; F2];

  %----------------%
  %     Output     %
  %----------------%
  F_out = F_vec;

end