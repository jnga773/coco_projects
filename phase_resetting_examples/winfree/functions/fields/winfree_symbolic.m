function F_coco_out = winfree_symbolic()
  % F_coco_out = winfree_symbolic()
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
  
  % Symbolic vector field
  F_vec = winfree_symbolic_field(xvec, pvec);

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_winfree';

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
