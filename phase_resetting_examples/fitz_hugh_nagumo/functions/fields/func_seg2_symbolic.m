function F_coco_out = func_seg2_symbolic()
  % F_coco_out = func_seg2_symbolic()
  %
  % Creates a CoCo-compatible function encoding for the second
  % segment of the phase-resetting problem.
  %
  % Segment 2 goes from \gamma_{\vartheta_{n}} to \gamma_{0}.
  %
  % Returns
  % -------
  % F_coco_out : cell of function handles
  %    List of CoCo-encoded symbolic functions for the segment 2 vector field,
  %    and its Jacobians and Hessians.

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
  %-------------------------------%
  %     State-Space Variables     %
  %-------------------------------%
  % State-space variables
  x_vec = sym('x', [xdim, 1]);
  % Adjoint equation variables
  w_vec = sym('w', [xdim, 1]);

  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  p_sys = sym('p', [pdim, 1]);

  % Phase resetting parameters
  syms k theta_old theta_new
  syms T_PO mu_s eta
  % Peturbation vector
  d_perturb = sym('d', [xdim, 1]);
  
  % All phase resetting parameters
  p_PR = [k; theta_old; theta_new;
          T_PO; mu_s; eta;
          d_perturb];

  %============================================================================%
  %                           VECTOR FIELD ENCODING                            %
  %============================================================================%
  %----------------------%
  %     Vector Field     %
  %----------------------%
  % Vector field
  F_vec = field(x_vec, p_sys);

  % Vector field equation
  vec_eqn = T_PO * (1 - theta_new) * F_vec;

  %-----------------------------%
  %     Variational Problem     %
  %-----------------------------%
  % Calculate tranpose of Jacobian at point x_vec
  J_T = transpose(jacobian(F_vec, x_vec));

  % Adjoint equation
  adj_eqn = -T_PO * (1 - theta_new) * J_T * w_vec;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  %-----------------------%
  %     Total Vectors     %
  %-----------------------%
  % Total vectors
  u_vec = [x_vec, w_vec];
  p_vec = [p_sys; p_PR];
  
  % Total equation
  F_seg = [vec_eqn; adj_eqn];

  %-----------------%
  %     SymCOCO     %
  %-----------------%
  % Filename for output functions
  filename_out = './functions/symcoco/F_seg2';

  % COCO Function encoding
  F_coco = sco_sym2funcs(F_seg, {u_vec, p_vec}, {'x', 'p'}, 'filename', filename_out);

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {F_coco(''), ...
               F_coco('x'), F_coco('p'), ...
               F_coco({'x', 'x'}), F_coco({'x', 'p'}), F_coco({'p', 'p'})};

  F_coco_out = func_list;

end