function [data_in, y_out] = bcs(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs(prob_in, data_in, u_in)
  % 
  % COCO compatible encoding for the boundary conditions of the eigenvalues and
  % eigenvectors of the monodromy matrix. Ensures they are eigenvectors and
  % values of the monodromy matrix, and ensures that the eigenvector is
  % normalised.
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with function data.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the following (as imposed by coco_add_func):
  %           u_in(1 : xdim)            - Equilibrium point
  %           u_in(xdim+1 : xdim+pdim)  - System parameters
  %           u_in(xdim+pdim+1 : end-1) - The eigenvector
  %           u_in(end)                 - The eigenvalue
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  % State space and parameter vector dimensions
  xdim = data_in.xdim;
  pdim = data_in.pdim;
  % Jacobian function handle
  DFDX = data_in.dfdxhan;

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Equilibrium point
  x0_ss      = u_in(1 : xdim);
  % System parameters
  parameters = u_in((xdim + 1):(xdim + pdim));
  % Eigenvector
  eig_vec    = u_in((xdim + pdim + 1):end-1);
  % Eigenvalue
  eig_val    = u_in(end);

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Calculate Jacobian matrix
  J = DFDX(x0_ss, parameters);
  % Eigenvalue equations
  eig_eqn = (J * eig_vec) - (eig_val * eig_vec);

  % Unit vector equations
  vec_eqn = (eig_vec' * eig_vec) - 1;

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [eig_eqn;
           vec_eqn];

end