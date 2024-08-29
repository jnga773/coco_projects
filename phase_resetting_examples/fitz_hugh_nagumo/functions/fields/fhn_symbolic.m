function F_coco_out = fhn_symbolic()
  % F_coco_out = fhn_symbolic()
  %
  % Creates a CoCo-compatible function encoding of the
  % Yamada model vector field using MATLAB's 
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
  
  % Symbolic vector field
  F_vec = fhn_symbolic_field(xvec, pvec);

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_fhn';

  % COCO Function encoding
  F_coco = sco_sym2funcs(F_vec, {xvec, pvec}, {'x', 'p'}, 'filename', filename_out);

  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

  %----------------%
  %     Output     %
  %----------------%
  F_coco_out = func_list;

end
