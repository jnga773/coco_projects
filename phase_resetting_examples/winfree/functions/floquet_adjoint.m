function y_out = floquet_adjoint(u_in, p_in)
  % y_out = floquet_adjoint(u_in, p_in)
  %
  % Adjoing function to calculate the Floquet bundle I guess?

  %---------------%
  %     Input     %
  %---------------%
  % State vector
  x = u_in(1:2, :);

  % Adjoint perpendicular vector (I think)
  w = u_in(3:4, :);

  % Parameters
  parameters = p_in(1:2, :);

  % Jacobian
  J = winfree_DFDX(x, parameters);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Length of u_in
  ll = length(x(1, :));

  % Empty array
  C = zeros(2, ll);

  % The adjoint equation
  % d/dt w = -J^T(\gamma) * w
  for i = 1 : ll
    % Transpose of the Jacobian
    J_transpose = transpose(J(:, :, i));

    % Adjoint equation
    C(:, i) = -J_transpose * w(:, i);

  end

  % Vector field
  F = winfree(x, parameters);

  %----------------%
  %     Output     %
  %----------------%
  y_out(1, :) = F(1, :);
  y_out(2, :) = F(2, :);
  y_out(3, :) = C(1, :);
  y_out(4, :) = C(2, :);

end
