function [F_out, F_coco_out] = symbolic_winfree()
  % F_out = symbolic_winfree()
  %
  % Creates a CoCo-compatible function encoding of the
  % Yamada model vector field using MATLAB's 
  % Symbolic Toolbox.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms x1 x2
  syms a omega

  % Variable arrays
  xvec = [x1; x2];
  pvec = [a; omega];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % square root bit
  sqrt_xy = sqrt( (x1 .^ 2) + (x2 .^ 2) );
  % front bit
  first_bit = 1 - sqrt_xy;

  % Vector field components
  F1 = first_bit .* (x1 .* (sqrt_xy - a) + (omega .* x2)) + x2;
  F2 = first_bit .* (x2 .* (sqrt_xy - a) - (omega .* x1)) - x1;

  % Vector field
  F_vec = [F1; F2];

  % CoCo encoding
  filename_out = './functions/symbolic/F_winfree';
  F_coco = sco_sym2funcs(F_vec, {xvec, pvec}, {'x', 'p'}, 'filename', filename_out);

  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

  %----------------%
  %     Output     %
  %----------------%
  F_out = F_vec;
  F_coco_out = func_list;

end