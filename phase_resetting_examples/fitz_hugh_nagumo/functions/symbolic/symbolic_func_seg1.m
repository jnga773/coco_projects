function F_coco_out = symbolic_func_seg1()
  % F_coco_out = symbolic_func_seg1()
  %
  % Creates a CoCo-compatible function encoding for the first
  % segment of the phase-resetting problem.
  %
  % Segment 1 goes from gamma_0 to theta_new.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms x1 x2
  syms c a b z
  % Adjoint equation variables
  syms w1 w2
  % Phase resetting parameters
  syms k mu_s eta theta_old theta_new theta_perturb A d_x d_y

  % State space vector
  xvec = [x1; x2];
  % System parameters vector
  psys = [c; a; b; z];
  % Adjoint space vector
  wvec = [w1; w2];

  % Total vectors
  uvec = [xvec; wvec];
  pvec = [psys; k; mu_s; eta; theta_old; theta_new; theta_perturb; A; d_x; d_y];

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
  F_seg = theta_new * [F_vec; adj_eqn];

  % CoCo-compatible encoding
  filename_out = './functions/symbolic/F_seg1';
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