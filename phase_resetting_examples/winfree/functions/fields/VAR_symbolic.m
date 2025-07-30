function F_coco_out = fhn_VAR_symbolic()
  % F_coco_out = fhn_VAR_symbolic()
  %
  % Creates a CoCo-compatible function encoding for the adjoint
  % equation that computes the Floquet bundle.

  % State space dimension
  xdim = 2;
  % Vector field
  field = @winfree_symbolic_field;

  %---------------%
  %     Input     %
  %---------------%
  % State-space variables
  xvec = sym('x', [xdim, 1]);

  % Adjoint equation variables
  wvec = sym('w', [xdim, 1]);

  % System parameters
  syms a omega
  p_sys = [a; omega];

  % Phase resetting parameters
  syms mu_s w_norm

  % Total vectors
  uvec = [xvec; wvec];
  pvec = [p_sys; mu_s; w_norm];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F_vec = field(xvec, p_sys);

  % Vector field equations
  F_eqn = F_vec;

  % Calculate tranpose of Jacobian at point xvec
  J_T = transpose(jacobian(F_vec, xvec));

  % Adjoint equation
  adj_eqn = -J_T * wvec;

  % Total equation
  F_seg = [F_eqn; adj_eqn];

  % CoCo-compatible encoding
  filename_out = './functions/symcoco/F_VAR';
  F_coco = sco_sym2funcs(F_seg, {uvec, pvec}, {'x', 'p'}, 'filename', filename_out);

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};
  
  % Output
  F_coco_out = func_list;

end
