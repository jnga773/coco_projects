function bcs_coco_out = symbolic_bcs_PR_seg1_seg2()
  % bcs_coco_out = symbolic_bcs_PR_seg1_seg2()
  %
  % Boundary conditions for segments 1 and 2 of the phase reset
  % segments:
  %                        x1(0) - x2(1) = 0 ,
  %                        x1(1) - x2(0) = 0 ,
  %                        e1 . F(x1(0)) = 0 ,
  % and the adjoint boundary conditions:
  %                        x1(0) - x2(1) = 0 ,
  %                        x1(1) - x2(0) = 0 ,
  %                        e1 . F(x1(0)) = 0 ,
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
  syms x1 x2 x3 x4 x5 x6 x7 x8
  % Adjoint vector variables
  syms w1 w2 w3 w4 w5 w6 w7 w8
  % System parameters
  syms c a b z
  % Phase resetting parameters
  syms k mu_s eta theta_old theta_new theta_perturb A d_x d_y

  % Segment 1 - x(0)
  x0_seg1 = [x1; x2];
  % Segment 1 - w(0)
  w0_seg1 = [w1; w2];
  % Segment 2 - x(0)
  x0_seg2 = [x3; x4];
  % Segment 2 - w(0)
  w0_seg2 = [w3; w4];
  % Segment 1 - x(1)
  x1_seg1 = [x5; x6];
  % Segment 1 - w(1)
  w1_seg1 = [w5; w6];
  % Segment 2 - x(1)
  x1_seg2 = [x7; x8];
  % Segment 2 - w(1)
  w1_seg2 = [w7; w8];
  % System parameters
  p_sys   = [c; a; b; z];
  p_PR    = [k; mu_s; eta; theta_old; theta_new; theta_perturb; A; d_x; d_y];

  % Combined vector
  uvec = [x0_seg1; w0_seg1; x0_seg2; w0_seg2;
          x1_seg1; w1_seg1; x1_seg2; w1_seg2;
          p_sys; p_PR];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Identity matrix
  ones_matrix = eye(2);
  % First component unit vector
  e1 = ones_matrix(1, :);

  % Vector field
  [F_vec, ~] = symbolic_fhm();

  % Boundary Conditions - Segments 1 and 2
  bcs_seg12_1   = x0_seg1 - x1_seg2;
  bcs_seg12_2   = x1_seg1 - x0_seg2;
  bcs_seg12_3   = e1 * F_vec;

  % Adjoint Boundary Conditions - Segments 1 and 2
  a_bcs_seg12_1 = w0_seg1 - w1_seg2;
  a_bcs_seg12_2 = (mu_s * w0_seg2) - w1_seg1;
  a_bcs_seg12_3 = norm(w0_seg2) - 1;

  % Boundary condition vector
  bcs = [bcs_seg12_1; bcs_seg12_2; bcs_seg12_3;
         a_bcs_seg12_1; a_bcs_seg12_2; a_bcs_seg12_3];

  % CoCo-compatible encoding
  filename_out = './boundary_conditions/symbolic/F_bcs_seg1_seg2';
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
