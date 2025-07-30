function F_coco_out = func_seg4_symbolic()
  % F_coco_out = func_seg4_symbolic()
  %
  % Creates a CoCo-compatible function encoding for the fourth
  % segment of the phase-resetting problem.
  %
  % Segment 3 goes from gamma_0 to theta_old.

  % State space dimension
  xdim = 2;
  % Symbolic vector field function
  field = @winfree_symbolic_field;

  %---------------%
  %     Input     %
  %---------------%
  % State-space variables
  xvec = sym('x', [xdim, 1]);

  % System parameters
  syms a omega
  p_sys = [a; omega];

  % Phase resetting parameters
  syms k theta_old theta_new
  syms mu_s eta
  syms A_perturb theta_perturb
  p_PR = [k; theta_old; theta_new;
          mu_s; eta;
          A_perturb; theta_perturb];

  % Total vectors
  uvec = xvec;
  pvec = [p_sys; p_PR];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F_vec = field(xvec, p_sys);

  % Vector field equations
  vec_eqn = k * F_vec;

  % Total equation
  F_seg = vec_eqn;

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_seg4';

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