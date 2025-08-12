function bcs_coco_out = bcs_isochron_phase_symbolic()
  % bcs_coco_out = bcs_isochron_phase_symbolic()
  %
  % Boundary conditions for the isochron, that is:
  %            \theta_old - \theta_new = 0 .
  %
  % Output
  % ----------
  % bcs_coco_out : cell of function handles
  %     List of CoCo-ified symbolic functions for the boundary conditions
  %     Jacobian, and Hessian.

  %============================================================================%
  %                              INPUT PARAMETERS                              %
  %============================================================================%
  %---------------------------%
  %     Input: Parameters     %
  %---------------------------%
  % System parameters
  syms a omega
  p_sys = [a; omega];

  % Phase resetting parameters
  syms T k theta_old theta_new
  syms mu_s eta
  syms d_x d_y
  p_PR = [T; k; theta_old; theta_new;
          mu_s; eta;
          d_x; d_y];

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  %----------------------------------%
  %     Phase Boundary Condition     %
  %----------------------------------%
  % Force the two phases to be equal
  bcs_isochron = theta_old - theta_new;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Combined vector
  uvec = [p_sys; p_PR];

  % Boundary conditions vector
  bcs =  [bcs_isochron];

  % Filename for output functions
  filename_out = './functions/symcoco/F_bcs_isochron_phase';

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
