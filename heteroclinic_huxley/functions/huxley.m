function y_out = huxley(x_in, p_in)
  % HUXLEY: Vector field of the set of equations for whatever
  % this system is.

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
  % The system of equations
  y_out(1, :) = x2;
  y_out(2, :) = (p2 .* x2) - (x1 .* (1 - x1) .* (x1 - p1));

end
