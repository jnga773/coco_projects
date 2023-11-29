function y_out = lorenz(x_in, p_in)
  % LORENZ: Set of equations for the Lorenz system

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
  % The system of equations
  % y_out = zeros(3, 1);
  y_out(1, :) = -(s .* x1) + (s .* x2);
  y_out(2, :) = -(x1 .* x3) + (r .* x1) - x2;
  y_out(3, :) = (x1 .* x2) - (b .* x3);
end