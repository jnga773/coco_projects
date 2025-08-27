function y_out = yamada(x_in, p_in)
  % y_out = yamada(x_in, p_in)
  % 
  % Vector field of the Yamada model set of equations
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
  %     Array of the vector field of the Yamada model.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from u_in
  % Gain
  G = x_in(1, :);
  % Absorption
  Q = x_in(2, :);
  % Laser intensity
  I = x_in(3, :);

  % Grab the parameter-space variables from p_in
  % Decay time of gain
  gamma = p_in(1, :);
  % Pump current on the gain
  A = p_in(2, :);
  % (Relative) absorption
  B = p_in(3, :);
  a = p_in(4, :);

  %----------------%
  %     Output     %
  %----------------%
  % The system of equations
  % y_out = zeros(3, 1);
  y_out(1, :) = gamma .* (A - G - (G .* I));
  y_out(2, :) = gamma .* (B - Q - (a .* Q .* I));
  y_out(3, :) = (G - Q - 1.0) .* I;

end