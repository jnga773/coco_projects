function F_out = fhn_symbolic_field(x_in, p_in)
  % F_out = fhn_symbolic_field()
  %
  % Symbolic notation of the FHN vector field in the transformed axes.
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

  % Grab the state-space variables from x_in
  x1 = x_in(1);
  x2 = x_in(2);

  % Grab the parameter-space variables from p_in
  c  = p_in(1);
  a  = p_in(2);
  b  = p_in(3);
  z  = p_in(4);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F1 = c * (x2 + x1 - ((1/3) * (x1 ^ 3)) + z);
  F2 = (-1 / c) * (x1 - a + (b * x2));

  % Vector field
  F_vec = [F1; F2];

  %----------------%
  %     Output     %
  %----------------%
  F_out = F_vec;

end