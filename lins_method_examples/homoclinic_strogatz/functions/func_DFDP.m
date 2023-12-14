function J_out = func_DFDP(x_in, p_in)
  % FUNC_DFDP: Parameter-space Jacobian of the system set of equations
  % Grab the state-space variables from x_in

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from u_in
  x = x_in(1, :);
  y = x_in(2, :);

  % Grab the parameter-space variables from p_in
  mu = p_in(1, :);

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian matrix of the state-space
  J_out = zeros(2, numel(x));
  
  J_out(1, :) = 0;
  J_out(2, :) = y;

end