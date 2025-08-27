function F_out = yamada_symbolic_field(x_in, p_in)
  % F_out = yamada_symbolic_field(x_in, p_in)
  %
  % Symbolic notation of the Yamada vector field in the transformed axes.
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
  G     = x_in(1);
  Q     = x_in(2);
  I     = x_in(3);

  % Grab the parameter-space variables from p_in
  gamma = p_in(1);
  A     = p_in(2);
  B     = p_in(3);
  a     = p_in(4);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field components
  % d/dt G
  F1 = gamma * (A - G - (G * I));
  % d/dt Q
  F2 = gamma * (B - Q - (a * Q * I));
  % d/dt QI
  F3 = I * (G - Q - 1);

  % Vector field
  F_vec = [F1; F2; F3];

  %----------------%
  %     Output     %
  %----------------%
  F_out = F_vec;

end