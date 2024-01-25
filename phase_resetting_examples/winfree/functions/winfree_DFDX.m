function J_out = winfree_DFDX(x_in, p_in)
  % J_out = winfree_DFDX(x_in, p_in)
  %
  % COCO encoding of the state-space Jacobian of the Winfree model
  % vector field.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the state-space variables from x_in
  x = x_in(1, :);
  y = x_in(2, :);

  % Grab the parameter-space variables from p_in
  a = p_in(1, :);
  w = p_in(2, :);

  % square root bit
  sqrt_xy = sqrt( (x .^ 2) + (y .^ 2) );

  %----------------%
  %     Output     %
  %----------------%
  % The Jacobian
  J_out = zeros(2, 2, numel(x));

  J_out(1, 1, :) = ((x .^ 2) .* ((2 * a) - 3 * sqrt_xy + 2) + (y .^ 2) .* (a - sqrt_xy + 1) - (a .* sqrt_xy) - (w .* x.* y)) ./ sqrt_xy;

  J_out(1, 2, :) = ((x .* y) .* (a - 2 * sqrt_xy + 1) + w .* (sqrt_xy - (x .^ 2) - 2 * (y .^ 2)) + sqrt_xy) ./ sqrt_xy;


  J_out(2, 1, :) = ((x .* y) .* (a - 2 * sqrt_xy + 1) + w .* (-sqrt_xy + 2 * (x .^ 2) + (y .^ 2)) - sqrt_xy) ./ sqrt_xy;

  
  J_out(2, 2, :) = ((x .^ 2) .* (a - sqrt_xy + 1) + (y .^ 2) .* (2 * a - 3 * sqrt_xy + 2) - a .* sqrt_xy + (w .* x .* y)) ./ sqrt_xy;

end