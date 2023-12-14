function J_out = lorenz_DFDXDP(x_in, p_in)
  % LORENZ_DFDXDP: State-space and parameter-space second-order
  % Jacobian of the Lorenz system.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from u_in
  x1 = x_in(1, :);
  x2 = x_in(2, :);
  x3 = x_in(3, :);

  % Grab the parameter-space variables from p_in
  s = p_in(1, :);
  r = p_in(2, :);
  b = p_in(3, :);

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian matrix of the state-space
  J_out = zeros(3, 3, 3, numel(x1));
  
  J_out(1, 1, 1, :) = -1;
  J_out(1, 2, 1, :) = 1;
  J_out(2, 1, 2, :) = 1;
  J_out(3, 3, 3, :) = -1;
end