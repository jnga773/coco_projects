function bcs_coco_out = bcs_VAR_symbolic()
  % bcs_coco_out = bcs_VAR_symbolic()
  %
  % Symbolic COCO encoding of the adjoint equations needed to calculate
  % the Floquet multipliers:
  %                  d/dt w = -J^{T} w    .
  % The boundary conditions we require are the eigenvalue equations and that
  % the norm of w is equal to 1:
  %                   w(1) = \mu_{f} w(0) ,                         (1)
  %                norm(w) = w_norm       .                         (2)
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

  %============================================================================%
  %                              INPUT PARAMETERS                              %
  %============================================================================%
  %--------------------------------------%
  %     Input: Adjoint-Space Vectors     %
  %--------------------------------------%
  % Initial adjoint perpindicular vector
  w_init = sym('w_init', [xdim, 1]);
  % Final adjoint perpindicular vector
  w_final = sym('w_final', [xdim, 1]);

  %---------------------------%
  %     Input: Parameters     %
  %---------------------------%
  % Adjoint parameters
  syms mu_s w_norm

  % Floquet parameters
  p_flo   = [mu_s; w_norm];

  % Combined vector
  uvec    = [w_init;
             w_final;
             p_flo];

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  % Adjoint boundary conditions
  bcs_adjt_1 = w_final - (mu_s * w_init);
  bcs_adjt_2 = (w_init' * w_init) - w_norm;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %-----------------------%
  %     Total Vectors     %
  %-----------------------%
  % Combined vector
  u_vec   = [w_init, w_final, p_flo];

  % Boundary conditions vector
  bcs_vec = [bcs_adjt_1; bcs_adjt_2];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_bcs_VAR';

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