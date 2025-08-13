function y_out = func_seg1(x_in, p_in)
  % y_out = func_seg1(x_in, p_in)
  %
  % Creates a CoCo-compatible function encoding for the first
  % segment of the phase-resetting problem.
  %
  % Segment 1 goes from \gamma_{0} to \gamma_{\vartheta_{n}}.
  %
  % Parameters
  % ----------
  % x_in : array, double
  %     State vector for the periodic orbit (x) and perpendicular
  %     vector (w).
  % p_in : array, double
  %     Array of parameter values
  %
  % Returns
  % -------
  % y_out : array, double
  %     Array of the vector field of the periodic orbit segment
  %     and the corresponding adjoint equation for the perpendicular
  %     vector.

  %============================================================================%
  %                          CHANGE THESE PARAMETERS                           %
  %============================================================================%
  % Original vector field state-space dimension
  xdim       = 2;
  % Original vector field parameter-space dimension
  pdim       = 2;
  % Original vector field function
  field      = @winfree;
  % Original vector field state-space Jacobian
  field_DFDX = @winfree_DFDX;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %-------------------------------%
  %     State-Space Variables     %
  %-------------------------------%
  % State space variables
  x_vec         = x_in(1:xdim, :);
  % Perpendicular vectors
  w_vec         = x_in(xdim+1:2*xdim, :);
  
  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  p_sys         = p_in(1 : pdim, :);
  % Phase resetting parameters
  p_PR          = p_in(pdim+1 : end, :);

  % Phase resetting parameters
  % Integer for period
  % k             = p_PR(1, :);
  % Phase where perturbation starts
  % theta_old     = p_PR(2, :);
  % Phase where segment comes back to \Gamma
  theta_new     = p_PR(3, :);
  % Stable Floquet eigenvalue
  % mu_s          = p_PR(4, :);
  % Distance from pertured segment to \Gamma
  % eta           = p_PR(5, :);
  % Size of perturbation
  % A_perturb     = p_PR(6, :);
  % Angle of perturbation
  % theta_perturb = p_PR(7, :);

  %============================================================================%
  %                           VECTOR FIELD ENCODING                            %
  %============================================================================%
  %----------------------%
  %     Vector Field     %
  %----------------------%
  % Calculate vector field
  vec_field = field(x_vec, p_sys);
  
  % Save to array
  vec_eqn = theta_new .* vec_field;

  %-----------------------------%
  %     Variational Problem     %
  %-----------------------------%
  % Calculate adjoint equations
  % Jacobian at the zero-phase point
  J = field_DFDX(x_vec, p_sys);

  % Cycle through each variable in x1 and calculate
  % adjoint equation components
  for i = 1 : numel(x_vec(1, :))
    % Transpose of Jacobian
    J_transpose(:, :, i) = transpose(J(:, :, i));

    % Calculate some things
    temp(:, :, i) = -theta_new(i) * J_transpose(:, :, i);

    % Save to array
    adj_eqn(:, :, i) = temp(:, :, i) * w_vec(:, i);
  end

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  % Vector field
  y_out(1:xdim, :)        = vec_eqn(:, :);
  % Adjoint equation
  y_out(xdim+1:2*xdim, :) = adj_eqn(:, :);

end
