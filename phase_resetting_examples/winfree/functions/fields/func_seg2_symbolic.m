function F_coco_out = func_seg2_symbolic()
  % F_coco_out = func_seg2_symbolic()
  %
  % Creates a CoCo-compatible function encoding for the first
  % segment of the phase-resetting problem.
  %
  % Segment 2 goes from theta_new to gamma_0.

  % State space dimension
  xdim = 2;
  % Symbolic vector field function
  field = @winfree_symbolic_field;

  %---------------%
  %     Input     %
  %---------------%
  % State-space variables
  xvec = sym('x', [xdim, 1]);

  % Adjoint equation variables
  wvec = sym('w', [xdim, 1]);

  % System parameters
  syms a omega
  p_sys = [a; omega];

  % Phase resetting parameters
  syms T k theta_old theta_new
  syms mu_s eta
  syms A_perturb theta_perturb
  syms d_x d_y
  p_PR = [T; k; theta_old; theta_new;
          mu_s; eta;
          A_perturb; theta_perturb;
          d_x; d_y];

  % Total vectors
  uvec = [xvec; wvec];
  pvec = [p_sys; p_PR];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F_vec = field(xvec, p_sys);

  % Vector field equation
  vec_eqn = T * (1 - theta_new) * F_vec;

  % Calculate tranpose of Jacobian at point xvec
  J_T = transpose(jacobian(F_vec, xvec));

  % Adjoint equation
  adj_eqn = -T * (1 - theta_new) * J_T * wvec;

  % Total equation
  F_seg = [vec_eqn; adj_eqn];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_seg2';

  % COCO Function encoding
  F_coco = sco_sym2funcs(F_seg, {uvec, pvec}, {'x', 'p'}, 'filename', filename_out);

  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

  %----------------%
  %     Output     %
  %----------------%
  F_coco_out = func_list;

end