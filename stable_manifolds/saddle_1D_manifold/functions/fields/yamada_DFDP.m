function J_out = yamada_DFDP(x_in, p_in)
  % J_out = yamada_DFDP(x_in, p_in)
  % 
  % Parameter-space Jacobian of the Yamada model set of
  % equations.
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
  % J_out : array, float
  %     Matrix of the parameter-space derivative Jacobian.

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
  % The Jacobian matrix of the parameter-space
  J_out = zeros(3, 4, numel(G));
  
  J_out(1, 1, :) = A - G - (G .* I);
  J_out(1, 2, :) = gamma;
  J_out(1, 3, :) = 0;
  J_out(1, 4, :) = 0;

  J_out(2, 1, :) = B - Q - (a .* Q .* I);
  J_out(2, 2, :) = 0;
  J_out(2, 3, :) = gamma;
  J_out(2, 4, :) = -gamma .* Q .* I;

  J_out(3, 1, :) = 0;
  J_out(3, 2, :) = 0;
  J_out(3, 3, :) = 0;
  J_out(3, 4, :) = 0;
end