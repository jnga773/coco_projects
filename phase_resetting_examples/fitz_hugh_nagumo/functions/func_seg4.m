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

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Array of state-space variables
  x_vec        = x_in(1:2, :);

  % System parameters
  p_system     = p_in(1:4, :);

  % Phase resetting parameters
  % Integer for period
  k             = p_in(5, :);
  % Stable Floquet eigenvalue
  mu_s          = p_in(6, :);
  % Phase where perturbation starts
  theta_old     = p_in(7, :);
  % Phase where segment comes back to \Gamma
  theta_new     = p_in(8, :);
  % Angle of perturbation
  theta_perturb = p_in(9, :);
  % Distance from pertured segment to \Gamma
  eta           = p_in(10, :);
  % Size of perturbation
  A             = p_in(11, :);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%  
  % Calculate vector field
  vec_field = fhn(x_vec, p_system);
  
  % Save to array
  vec_eqn = k .* vec_field;

  %----------------%
  %     Output     %
  %----------------%
  % Vector field
  y_out(1, :) = vec_eqn(1, :);
  y_out(2, :) = vec_eqn(2, :);

end
