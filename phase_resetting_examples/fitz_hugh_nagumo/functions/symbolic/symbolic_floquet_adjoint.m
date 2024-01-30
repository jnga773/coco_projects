function F_coco_out = symbolic_floquet_adjoint()
  % F_coco_out = symbolic_floquet_adjoint()
  %
  % Creates a CoCo-compatible function encoding of the
  % Fitzh-Hugh-Nagumo vector field and adjoint equation
  % using MATLAB's Symbolic Toolbox.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms x1 x2
  syms c a b z
  % Adjoint equaiton variables
  syms w1 w2
  syms mu_s w_norm

  % State space vector
  xvec = [x1; x2];
  % System parameters vector
  psys = [c; a; b; z];
  % Adjoint space vector
  wvec = [w1; w2];

  % Total vectors
  uvec = [xvec; wvec];
  pvec = [psys; mu_s; w_norm];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  [F_vec, ~] = symbolic_fhm();

  % Calculate tranpose of Jacobian at point xvec
  J_T = transpose(jacobian(F_vec, xvec));

  % Adjoint equation
  adj_eqn = -J_T * wvec;

  % Total equation
  F_adj = [F_vec; adj_eqn];

  % CoCo-compatible encoding
  filename_out = './functions/symbolic/F_adjoint';
  F_coco = sco_sym2funcs(F_adj, {uvec, pvec}, {'x', 'p'}, 'filename', filename_out);

  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

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