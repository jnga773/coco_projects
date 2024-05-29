function y_out = func_seg4(x_in, p_in)
  % y_out = func_seg1(u_in, p_in)
  %
  % COCO 'ode' toolbox encoding for the vector field corresponding to
  % segment 4 of the phase resetting curve.
  %
  % Segment 4 goes from theta_old to theta_new.
  %
  % Input
  % ----------
  % x_in : array, float
  %     State vector for the periodic orbit (x) and perpendicular
  %     vector (w).
  % p_in : array, float
  %     Array of parameter values
  %
  % Output
  % ----------
  % y_out : array, float
  %     Array of the vector field of the periodic orbit segment
  %     and the corresponding adjoint equation for the perpendicular
  %     vector.

  % Original vector field dimensions (CHANGE THESE)
  xdim = 2;
  pdim = 2;
  % Original vector field function
  field      = @winfree;
  field_DFDX = @winfree_DFDX;

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Array of state-space variables
  x_vec        = x_in(1:xdim, :);

  % System parameters
  p_system     = p_in(1:pdim, :);

  % Phase resetting parameters
  % Period of the segment
  T             = p_in(pdim+1, :);
  % Integer for period
  k             = p_in(pdim+2, :);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%  
  % Calculate vector field
  vec_field = field(x_vec, p_system);
  
  % Save to array
  vec_eqn = k .* T .* vec_field;

  %----------------%
  %     Output     %
  %----------------%
  % Vector field
  y_out(1:xdim, :) = vec_eqn(:, :);

end
