function F_coco_out = symbolic_func_seg4()
  % F_coco_out = symbolic_func_seg4()
  %
  % Creates a CoCo-compatible function encoding for the fourth
  % segment of the phase-resetting problem.
  %
  % Segment 3 goes from gamma_0 to theta_old.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms x1 x2
  syms c a b z
  % Phase resetting parameters
  syms k mu_s eta theta_old theta_new theta_perturb A d_x d_y

  % State space vector
  xvec = [x1; x2];
  % System parameters vector
  psys = [c; a; b; z];

  % Total vectors
  uvec = xvec;
  pvec = [psys; k; mu_s; eta; theta_old; theta_new; theta_perturb; A; d_x; d_y];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  [F_vec, ~] = symbolic_fhm();

  % Total equation
  F_seg = k * F_vec;

  % CoCo-compatible encoding
  filename_out = './functions/symbolic/F_seg4';
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