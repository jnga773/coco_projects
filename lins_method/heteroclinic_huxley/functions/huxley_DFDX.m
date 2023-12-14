function J_out = huxley_DFDX(x_in, p_in)
  % HUXLEY_DFDX: State-space Jacobian of the system of equations
  % for whatever this is.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from x_in
  x1 = x_in(1, :);
  x2 = x_in(2, :);

  % Grab the parameter-space variables from p_in
  p1 = p_in(1,: );
  p2 = p_in(2, :);

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian matrix of the state-space
  J_out = zeros(2, 2, numel(x1));
  
  J_out(1, 1, :) = 0;
  J_out(1, 2, :) = 1;
  J_out(2, 1, :) = (3 * (x1 .^ 2)) - (2 * x1 .* (1 + p1)) + p1;
  J_out(2, 2, :) = p2;

end