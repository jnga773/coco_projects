%-----------------------------------------------------------------------------%
%%                      BOUNDARY CONDITIONS (SEPARATE)                       %%
%-----------------------------------------------------------------------------%
function bcs_coco_out = symbolic_bcs_floquet()
  % bcs_coco_out = symbolic_bcs_floquet()
  %
  % Boundary conditions for the Floquet multipliers with the adjoint equation
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

  %---------------%
  %     Input     %
  %---------------%
  % State space variables
  syms w1 w2 w3 w4
  % Parameter variables
  syms mu_s w_norm

  % Initial point of the periodic orbit
  w_init  = [w1; w2];
  % Final point of the periodic orbit
  w_final = [w3; w4];
  % System parameters
  pvec    = [mu_s; w_norm];

  % Combined vector
  uvec = [w_init; w_final; pvec];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Adjoint boundary conditions
  bcs1 = w_final - (mu_s * w_init);
  bcs2 = (w_init' * w_init) - w_norm;

  % Boundary condition vector
  bcs = [bcs1; bcs2];

  % CoCo-compatible encoding
  filename_out = './boundary_conditions/symbolic/F_bcs_floquet';
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
