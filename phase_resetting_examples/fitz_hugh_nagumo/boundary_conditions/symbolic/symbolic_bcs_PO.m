function bcs_coco_out = symbolic_bcs_PO();
  % bcs_coco_out = symbolic_bcs_PO()
  % 
  % Boundary conditions for a periodic orbit,
  %                           x(1) - x(0) = 0 ,
  % in the 'coll' toolbox with the zero phase condition where:
  %                         e . F(x(0)) = 0,
  % that is, the first component of the vector field at t=0 is zero.
  %
  % Output
  % ----------
  % bcs_coco_out : cell of function handles
  %     List of CoCo-ified symbolic functions for the boundary conditions
  %     Jacobian, and Hessian.

  %---------------%
  %     Input     %
  %---------------%
  % State space variables
  syms x1 x2 x3 x4
  % Parameter variables
  syms c a b z

  % Initial point of the periodic orbit
  x_init  = [x1; x2];
  % Final point of the periodic orbit
  x_final = [x3; x4];
  % System parameters
  pvec    = [c; a; b; z];

  % Combined vector
  uvec = [x_init; x_final; pvec];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Identity matrix
  ones_matrix = eye(2);
  % First component unit vector
  e1 = ones_matrix(1, :);

  % Vector field
  [F_vec, ~] = symbolic_fhm();

  % Periodic boundary conditions
  bcs1 = x_final - x_init;
  % First component of the vector field is zero (phase condition)
  bcs2 = e1 * F_vec;

  % Boundary condition vector
  bcs = [bcs1; bcs2];

  % CoCo-compatible encoding
  filename_out = './boundary_conditions/symbolic/F_bcs_PO';
  bcs_coco = sco_sym2funcs(bcs, {uvec}, {'u'}, 'filename', filename_out);

  % Function to "CoCo-ify" function outputs: [data_in, y_out] = f(prob_in, data_in, u_in)
  cocoify = @(func_in) @(prob_in, data_in, u_in) deal(data_in, func_in(u_in));

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {cocoify(bcs_coco('')), cocoify(bcs_coco('u')), cocoify(bcs_coco({'u', 'u'}))};

  % Output
  bcs_coco_out = func_list;

end
