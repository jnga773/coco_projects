function F_coco_out = yamada_symbolic()
  % F_coco_out = yamada_symbolic()
  %
  % Creates a CoCo-compatible function encoding of the
  % Yamada model vector field using MATLAB's 
  % Symbolic Toolbox.
  %
  % Returns
  % -------
  % F_coco_out : array, float
  %     Cell of all of the functions and derivatives.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms G Q I
  syms gam A B a

  % Variable arrays
  xvec = [G; Q; I];
  pvec = [gam; A; B; a];
  
  % Symbolic vector field
  F_vec = yamada_symbolic_field(xvec, pvec);

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_yamada';

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
