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
  %                          CHANGE THESE PARAMETERS                           %
  %============================================================================%
  % Original vector field state-space dimension
  xdim  = 2;
  % Original vector field parameter-space dimension
  pdim  = 4;
  % Original vector field symbolic function
  field = @fhn_symbolic_field;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  p_sys = sym('p', [pdim, 1], 'real');

  % Phase resetting parameters
  syms k theta_old theta_new
  syms T_PO mu_s eta
  % Peturbation vector
  d_vec = sym('d', [xdim, 1], 'real');
  
  % All phase resetting parameters
  p_PR = [k; theta_old; theta_new;
          T_PO; mu_s; eta;
          d_vec];

  % Assume real variables
  assume(p_PR, 'real');

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  %----------------------------------%
  %     Phase Boundary Condition     %
  %----------------------------------%
  % Force the two phases to be equal
  bcs_phase = theta_old - theta_new;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Combined vector
  uvec = [p_sys; p_PR];

  % Boundary conditions vector
  bcs =  [bcs_phase];

  % Filename for output functions
  filename_out = './functions/symcoco_bcs_isochron_phase';

  % COCO Function encoding
  bcs_coco = sco_sym2funcs(bcs, {uvec}, {'u'}, 'filename', filename_out);

  % Function to "CoCo-ify" function outputs: [data_in, y_out] = f(prob_in, data_in, u_in)
  cocoify = @(func_in) @(prob_in, data_in, u_in) deal(data_in, func_in(u_in));

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {cocoify(bcs_coco('')), cocoify(bcs_coco('u')), cocoify(bcs_coco({'u', 'u'}))};

  bcs_coco_out = func_list;

end
