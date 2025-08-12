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
  % For the hardcoded version, and the actual functions that
  % will be coco_add_func call will include the following
  % u-vector components:
  %          * u_in(1:2) - Initial point of the periodic orbit,
  %          * u_in(3:4) - Final point of the periodic orbit,
  %          * u_in(5L6) - Parameters.
  %
  % Output
  % ----------
  % bcs_coco_out : cell of function handles
  %     List of CoCo-ified symbolic functions for the boundary conditions
  %     Jacobian, and Hessian.

  %============================================================================%
  %                          CHANGE THESE PARAMETERS                           %
  %============================================================================%
  % State-space dimension
  xdim = 2;
  pdim = 2;
  % Symbolic vector field function
  field = @winfree_symbolic_field;

  %============================================================================%
  %                              INPUT PARAMETERS                              %
  %============================================================================%
  %------------------------------------%
  %     Input: State-Space Vectors     %
  %------------------------------------%
  % Initial point of the periodic orbit
  x_init = sym('x', [xdim, 1]);
  % Final point of the periodic orbit
  x_final = sym('x_final', [xdim, 1]);

  %---------------------------%
  %     Input: Parameters     %
  %---------------------------%
  % System parameters
  p_sys = sym('p', [pdim, 1]);

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  % Vector field
  F_vec = field(x_init, p_sys);

  % Periodic boundary conditions
  bcs1 = x_init - x_final;
  % First component of the vector field is zero (phase condition)
  bcs2 = F_vec(1);

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %-----------------------%
  %     Total Vectors     %
  %-----------------------%
  % Combined vector
  u_vec   = [x_init; x_final; p_sys];
  
  % Boundary condition vector
  bcs_vec = [bcs1; bcs2];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_bcs_PO';

  % COCO Function encoding
  bcs_coco = sco_sym2funcs(bcs_vec, {u_vec}, {'u'}, 'filename', filename_out);

  % Function to "CoCo-ify" function outputs: [data_in, y_out] = f(prob_in, data_in, u_in)
  cocoify = @(func_in) @(prob_in, data_in, u_in) deal(data_in, func_in(u_in));

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {cocoify(bcs_coco('')), cocoify(bcs_coco('u')), cocoify(bcs_coco({'u', 'u'}))};

  bcs_coco_out = func_list;

end