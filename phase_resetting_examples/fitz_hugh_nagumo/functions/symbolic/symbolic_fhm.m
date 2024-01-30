function [F_out, F_coco_out] = symbolic_fhm()
  % F_out = symbolic_fhm()
  %
  % Creates a CoCo-compatible function encoding of the
  % Fitzh-Hugh-Nagumo vector field using MATLAB's 
  % Symbolic Toolbox.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms x1 x2
  syms c a b z

  % Variable arrays
  xvec = [x1; x2];
  pvec = [c; a; b; z];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F1 = c * (x2 + x1 - ((1/3) * (x1 ^ 3)) + z);
  F2 = (-1 ./ c) * (x1 - a + (b * x2));
  F_vec = [F1; F2];

  % CoCo encoding
  filename_out = './functions/symbolic/F_fhm';
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