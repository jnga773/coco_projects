function y_out = marsden(x_in, p_in)
  % Grab the state-space variables from x_in
  x1 = x_in(1, :);
  x2 = x_in(2, :);
  x3 = x_in(3, :);

  % Grab the parameter-space variables from p_in
  p1 = p_in(1, :);
  p2 = p_in(2, :);

  % The system of equations
  % y_out = zeros(3, 1);
  y_out(1, :) = (p1 .* x1) + x2 + (p2 .* (x1 .^ 2));
  y_out(2, :) = (-x1) + (p1 .* x2) + (x2 .* x3);
  y_out(3, :) = (((p1 .^ 2) - 1) .* x2 ) - x1 - x3 + (x1 .^ 2);

end