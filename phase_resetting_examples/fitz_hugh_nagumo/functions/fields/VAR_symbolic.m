function F_coco_out = VAR_symbolic()
  % F_coco_out = VAR_symbolic()
  %
  % Creates a CoCo-compatible function encoding for the adjoint
  % equation that computes the Floquet bundle.
  %
  % Returns
  % -------
  % F_coco_out : cell of function handles
  %    List of CoCo-encoded symbolic functions for the segment 1 vector field,
  %    and its Jacobians and Hessians.

  %============================================================================%
  %                          CHANGE THESE PARAMETERS                           %
  %============================================================================%
  % Original vector field state-space dimension
  xdim  = 2;
  % Original vector field parameter-space dimension
  pdim  = 4;
  % Original vector field symbolic function
  field = @fhn_symbolic_field;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %-------------------------------%
  %     State-Space Variables     %
  %-------------------------------%
  % State-space variables
  x_vec = sym('x', [xdim, 1]);
  % Adjoint equation variables
  w_vec = sym('w', [xdim, 1]);

  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  p_sys = sym('p', [pdim, 1]);

  % Phase resetting parameters
  syms mu_s w_norm

  %============================================================================%
  %                           VECTOR FIELD ENCODING                            %
  %============================================================================%
  %----------------------%
  %     Vector Field     %
  %----------------------%
  % Vector field
  F_vec = field(x_vec, p_sys);

  % Vector field equations
  vec_eqn = F_vec;

  %-----------------------------%
  %     Variational Problem     %
  %-----------------------------%
  % Calculate tranpose of Jacobian at point xvec
  J_T = transpose(jacobian(F_vec, x_vec));

  % Adjoint equation
  adj_eqn = -J_T * w_vec;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %-----------------------%
  %     Total Vectors     %
  %-----------------------%
  % Total vectors
  u_vec = [x_vec, w_vec];
  p_vec = [p_sys; mu_s; w_norm];
  
  % Total equation
  F_seg = [vec_eqn; adj_eqn];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_VAR';

  % COCO Function encoding
  F_coco = sco_sym2funcs(F_seg, {u_vec, p_vec}, {'x', 'p'}, 'filename', filename_out);

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

  F_coco_out = func_list;

end
