function J_out = lorenz_DFDX(x_in, p_in)
  % LORENZ_DFDX: State-space Jacobian of the Lorenz system.

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
  J_out = zeros(3, 3, numel(x1));
  
  J_out(1, 1, :) = -s;
  J_out(1, 2, :) = s;
  J_out(1, 3, :) = 0;

  J_out(2, 1, :) = r - x3;
  J_out(2, 2, :) = -1;
  J_out(2, 3, :) = -x1;

  J_out(3, 1, :) = x2;
  J_out(3, 2, :) = x1;
  J_out(3, 3, :) = -b;
end