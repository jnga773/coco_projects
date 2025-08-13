function y_out = func_seg4(x_in, p_in)
  % y_out = func_seg1(u_in, p_in)
  %
  % Creates a CoCo-compatible function encoding for the fourth
  % segment of the phase-resetting problem.
  %
  % Segment 4 goes from \gamma_{\vartheta_{o}} + A d to \gamma_{\vartheta_{n}}.
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
  pdim       = 4;
  % Original vector field function
  field      = @fhn;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %-------------------------------%
  %     State-Space Variables     %
  %-------------------------------%
  % Array of state-space variables
  x_vec         = x_in(1:xdim, :);
  
  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  p_sys         = p_in(1 : pdim, :);
  % Phase resetting parameters
  p_PR          = p_in(pdim+1 : end, :);

  % Phase resetting parameters
  % Integer for period
  k             = p_PR(1, :);
  % Phase where perturbation starts
  % theta_old     = p_PR(2, :);
  % Phase where segment comes back to \Gamma
  % theta_new     = p_PR(3, :);
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
  vec_eqn = k .* vec_field;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  % Vector field
  y_out(1:xdim, :) = vec_eqn(:, :);

end
