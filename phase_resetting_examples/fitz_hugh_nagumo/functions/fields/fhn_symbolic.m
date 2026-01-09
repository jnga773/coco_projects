function F_coco_out = fhn_symbolic()
  % F_coco_out = fhn_symbolic()
  %
  % Creates a CoCo-compatible function encoding of the FitzHugh-Nagumo
  % model vector field using SymCOCO.
  %
  % Returns
  % -------
  % F_coco_out : array, float
  %     Cell of all of the functions and derivatives.

  %---------------%
  %     Input     %
  %---------------%
  % State-space and parameter variables
  syms x1 x2
  syms c a b z

  % Variable arrays
  x_vec = [x1; x2];
  p_vec = [c; a; b; z];

  % Assume real variables
  assume(x_vec, 'real');
  assume(p_vec, 'real');
  
  % Symbolic vector field
  F_vec = fhn_symbolic_field(x_vec, p_vec);

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco_fhn';

  % COCO Function encoding
  F_coco = sco_sym2funcs(F_vec, {x_vec, p_vec}, {'x', 'p'}, 'filename', filename_out);

  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

  %----------------%
  %     Output     %
  %----------------%
  F_coco_out = func_list;

end
