function bcs_coco_out = bcs_PR_seg4_symbolic()
  % bcs_coco_out = bcs_PR_seg4_symbolic()
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

  % State-space dimension
  xdim = 2;

  %---------------%
  %     Input     %
  %---------------%
  % Segment 2 - x(0)
  x0_seg2 = sym('x0_seg2', [xdim, 1]);

  % Segment 2 - w(0)
  w0_seg2 = sym('w0_seg2', [xdim, 1]);

  % Segment 3 - x(0)
  x0_seg3 = sym('x0_seg3', [xdim, 1]);

  % Segment 4 - x(0)
  x0_seg4 = sym('x0_seg4', [xdim, 1]);

  % Segment 4 - x(1)
  x1_seg4 = sym('x1_seg4', [xdim, 1]);

  % System parameters
  syms a omega
  p_sys = [a; omega];

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
  uvec = [x0_seg2; w0_seg2;
          x0_seg3;
          x0_seg4; x1_seg4;
          p_sys; p_PR];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Displacement vector
  d_vec = [cos(theta_perturb);
           sin(theta_perturb)];

  % Boundary Conditions - Segment 4
  bcs_seg4_1 = x0_seg4 - x0_seg3 - (A_perturb * d_vec);

  bcs_seg4_2    = dot(x1_seg4 - x0_seg2, w0_seg2);  

  bcs_seg4_3    = norm(x1_seg4 - x0_seg2) - eta;

  % Boundary condition vector
  bcs = [bcs_seg4_1;
         bcs_seg4_2;
         bcs_seg4_3];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './boundary_conditions/symbolic/F_bcs_seg4';

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
