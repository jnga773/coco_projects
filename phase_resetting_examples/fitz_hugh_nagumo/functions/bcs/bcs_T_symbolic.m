function bcs_coco_out = bcs_T_symbolic()
  % bcs_coco_out = bcs_PO_symbolic()
  %
  % Boundary conditions for the segment period, T = 1.0.
  %
  % Output
  % ----------
  % bcs_coco_out : cell of function handles
  %     List of CoCo-ified symbolic functions for the boundary conditions
  %     Jacobian, and Hessian.

  % State-space dimension
  xdim = 3;

  %---------------%
  %     Input     %
  %---------------%
  % Period of the segment
  syms T

  % Combined vector
  uvec = [T];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Boundary condition vector
  bcs = T - 1.0;

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_bcs_T';

  % COCO Function encoding
  bcs_coco = sco_sym2funcs(bcs, {uvec}, {'u'}, 'filename', filename_out);

  % Function to "CoCo-ify" function outputs: [data_in, y_out] = f(prob_in, data_in, u_in)
  cocoify = @(func_in) @(prob_in, data_in, u_in) deal(data_in, func_in(u_in));

  % List of functions
  func_list = {cocoify(bcs_coco('')), cocoify(bcs_coco('u')), cocoify(bcs_coco({'u', 'u'}))};

  %----------------%
  %     Output     %
  %----------------%
  bcs_coco_out = func_list;

end