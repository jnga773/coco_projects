function J_out = marsden_DFDX(x_in, p_in)
  % Grab the state-space variables from x_in
  x1 = x_in(1, :);
  x2 = x_in(2, :);
  x3 = x_in(3, :);

  % Grab the parameter-space variables from p_in
  p1 = p_in(1, :);
  p2 = p_in(2, :);

  % The Jacobian matrix of the state-space
  J_out = zeros(3, 3, numel(x1));
  
  J_out(1, 1, :) = p1 + (2 * p2 .* x1);
  J_out(1, 2, :) = 1;
  J_out(1, 3, :) = 0;

  J_out(2, 1, :) = -1;
  J_out(2, 2, :) = p1 + x3;
  J_out(2, 3, :) = x2;

  J_out(3, 1, :) = -1 + (2 * x1);
  J_out(3, 2, :) = (p1 .^ 2) - 1;
  J_out(3, 3, :) = -1;
end