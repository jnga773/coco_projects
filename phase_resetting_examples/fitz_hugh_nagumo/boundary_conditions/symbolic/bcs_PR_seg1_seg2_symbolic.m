function bcs_coco_out = bcs_PR_seg1_seg2_symbolic()
  % bcs_coco_out = bcs_PR_seg1_seg2_symbolic()
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

  % State-space dimension
  xdim = 2;

  %---------------%
  %     Input     %
  %---------------%
  % Segment 1 - x(0)
  x0_seg1 = sym('x', [xdim, 1]);

  % Segment 1 - w(0)
  w0_seg1 = sym('w0_seg1', [xdim, 1]);

  % Segment 2 - x(0)
  x0_seg2 = sym('x0_seg2', [xdim, 1]);

  % Segment 2 - w(0)
  w0_seg2 = sym('w0_seg2', [xdim, 1]);

  % Segment 1 - x(1)
  x1_seg1 = sym('x1_seg1', [xdim, 1]);

  % Segment 1 - w(1)
  w1_seg1 = sym('w1_seg1', [xdim, 1]);

  % Segment 2 - x(1)
  x1_seg2 = sym('x1_seg2', [xdim, 1]);

  % Segment 2 - w(1)
  w1_seg2 = sym('w1_seg2', [xdim, 1]);

  % System parameters
  syms c a b z
  p_sys = [c; a; b; z];

  % Phase resetting parameters
  syms T k mu_s eta
  syms theta_old theta_new
  syms theta_perturb A_perturb
  syms d_x d_y
  p_PR = [T; k; mu_s; eta;
          theta_old; theta_new;
          theta_perturb; A_perturb;
          d_x; d_y];

  % Combined vector
  uvec = [x0_seg1; w0_seg1;
          x0_seg2; w0_seg2;
          x1_seg1; w1_seg1;
          x1_seg2; w1_seg2;
          p_sys; p_PR];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F_vec = fhn_symbolic_field();

  % Boundary Conditions - Segments 1 and 2
  bcs_seg12_1   = x0_seg1 - x1_seg2;
  bcs_seg12_2   = x1_seg1 - x0_seg2;
  bcs_seg12_3   = F_vec(1);

  % Adjoint Boundary Conditions - Segments 1 and 2
  a_bcs_seg12_1 = w0_seg1 - w1_seg2;
  a_bcs_seg12_2 = (mu_s * w0_seg2) - w1_seg1;
  a_bcs_seg12_3 = norm(w0_seg2) - 1;

  % Boundary condition vector
  bcs = [bcs_seg12_1; bcs_seg12_2; bcs_seg12_3;
         a_bcs_seg12_1; a_bcs_seg12_2; a_bcs_seg12_3];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './boundary_conditions/symbolic/F_bcs_seg1_seg2';

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
