function y_out = VAR(u_in, p_in)
  % y_out = VAR(u_in, p_in)
  %
  % Creates a CoCo-compatible function encoding for the adjoint
  % equation that computes the Floquet bundle.
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
  % Original vector field state-space Jacobian
  field_DFDX = @fhn_DFDX;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %-------------------------------%
  %     State-Space Variables     %
  %-------------------------------%
  % State vector
  x_vec = u_in(1 : xdim, :);
  % Adjoint perpendicular vector (I think)
  w_vec = u_in(xdim+1 : 2*xdim, :);
  
  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  p_sys = p_in(1:pdim, :);

  % Floquet eigenvalue
  mu_s  = p_in(pdim+1, :);
  % Norm w-vector
  wnorm = p_in(pdim+2, :);

  %============================================================================%
  %                           VECTOR FIELD ENCODING                            %
  %============================================================================%
  %----------------------%
  %     Vector Field     %
  %----------------------%
  % Vector field
  vec_field = field(x_vec, p_sys);

  % Jacobian
  J = field_DFDX(x_vec, p_sys);

  % Vector field equations
  vec_eqn = vec_field;

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
    temp(:, :, i) = -J_transpose(:, :, i);

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
