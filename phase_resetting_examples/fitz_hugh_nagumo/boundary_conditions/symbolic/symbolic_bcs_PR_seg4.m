function bcs_coco_out = symbolic_bcs_PR_seg4()
  % bcs_coco_out = bcs_PR_seg4()
  %
  % Boundary conditions for segment four of the phase reset
  % segments:
  %                x4(0) - x3(0) - A d_r = 0 ,
  %              (x4(1) - x2(0)) . w2(0) = 0 ,
  %             | x4(1) - x2(0) | - \eta = 0 .
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
  syms w1 w2
  % System parameters
  syms c a b z
  % Phase resetting parameters
  syms k mu_s eta theta_old theta_new theta_perturb A d_x d_y

  % Segment 2 - x(0)
  x0_seg2    = [x1; x2];
  % Segment 2 - w(0)
  w0_seg2    = [w1; w2];
  % Segment 3 - x(0)
  x0_seg3    = [x3; x4];
  % Segment 4 - x(0)
  x0_seg4    = [x5; x6];
  % Segment 4 - x(1)
  x1_seg4    = [x7; x8];
  % System parameters
  p_sys   = [c; a; b; z];
  p_PR    = [k; mu_s; eta; theta_old; theta_new; theta_perturb; A; d_x; d_y];

  % Combined vector
  uvec = [x0_seg2; w0_seg2; x0_seg3; x0_seg4; x1_seg4; p_sys; p_PR];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Displacement vector
  d_vec = [A * cos(theta_perturb); A * sin(theta_perturb)];
  % d_vec = [d_x; d_y];

  % Boundary Conditions - Segment 4
  bcs_seg4_1    = x0_seg4 - x0_seg3 - (A * d_vec);
  % bcs_seg4_1    = x0_seg4 - x0_seg3 - d_vec;
  bcs_seg4_2    = dot(x1_seg4 - x0_seg2, w0_seg2);
  bcs_seg4_3    = norm(x1_seg4 - x0_seg2) - eta;

  % Boundary condition vector
  bcs = [bcs_seg4_1;
         bcs_seg4_2;
         bcs_seg4_3];

  % CoCo-compatible encoding
  filename_out = './boundary_conditions/symbolic/F_bcs_seg4';
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
