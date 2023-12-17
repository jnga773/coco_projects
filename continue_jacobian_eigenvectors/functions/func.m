function y_out = func(x_in, p_in)
  % FUNC: Vector field of the system set of equationsa

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from x_in
  x = x_in(1, :);
  y = x_in(2, :);

  % Grab the parameter-space variables from p_in
  mu = p_in(1, :);

  %----------------%
  %     Output     %
  %----------------%
  % The system of equations
  % y_out = zeros(2, 1);
  y_out(1, :) = y;
  y_out(2, :) = (mu .* y) + x - (x .^ 2) + (x .* y);

end