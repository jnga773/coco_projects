function J_out = yamada_DFDX(x_in, p_in)
  % J_out = yamada_DFDX(x_in, p_in)
  % 
  % State-space Jacobian of the Yamada model set of equations.
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
  %     Matrix of the state-space derivative Jacobian.

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
  % The Jacobian matrix of the state-space
  J_out = zeros(3, 3, numel(G));
  
  % J_out(1, 1, :) = -gamma - (gamma .* I);
  J_out(1, 1, :) = -gamma .* (1 + I);
  J_out(1, 2, :) = 0;
  J_out(1, 3, :) = -gamma .* G;

  J_out(2, 1, :) = 0;
  % J_out(2, 2, :) = -gamma - (gamma .* a .* I);
  J_out(2, 2, :) = -gamma .* (1 + (a .* I));
  J_out(2, 3, :) = -gamma .* a .* Q;

  J_out(3, 1, :) = I;
  J_out(3, 2, :) = -I;
  J_out(3, 3, :) = G - Q - 1;
end