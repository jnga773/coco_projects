function bcs_coco_out = bcs_PO_symbolic()
  % bcs_coco_out = bcs_PO_symbolic()
  %
  % Symbolic COCO encoding of the boundary conditions of
  % the periodic orbit with the zero-phase condition.
  %
  % Boundary conditions for a periodic orbit,
  %                           x(1) - x(0) = 0 ,
  % in the 'coll' toolbox with the zero phase condition where:
  %                         e1 . F(x(0)) = 0,
  % that is, the first component of the vector field at t=0 is zero.
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
  % Initial point of the periodic orbit
  x_init = sym('x', [xdim, 1]);

  % Final point of the periodic orbit
  x_final = sym('x_final', [xdim, 1]);

  % System parameters
  syms gam A B a
  p_sys = [gam; A; B; a];

  % Combined vector
  uvec = [x_init;
          x_final;
          p_sys];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F_vec = yamada_symbolic_field(x_init, p_sys);

  % Periodic boundary conditions
  bcs1 = x_init - x_final;
  % First component of the vector field is zero (phase condition)
  bcs2 = F_vec(1);

  % Boundary condition vector
  bcs = [bcs1; bcs2];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_bcs_PO';

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