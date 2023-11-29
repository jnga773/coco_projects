function [data_in, y_out] = boundary_conditions_eig(prob_in, data_in, u_in)
  % [data_in, y_out] = boundary_conditions_eig(prob_in, data_in, u_in)
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
  %          * u_in(1:9)   - The monodromy matrix,
  %          * u_in(10:12) - The stable Floquet vector (vec_floquet),
  %          * u_in(13)    - The stable Floquet multiplier (lam_floquet).
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Monodromy matrix indices
  v1_idx      = u_in(1:9);
  % Eigenvector
  % vec_floquet = u_in(end-3:end-1);
  vec_floquet = u_in(10:12);
  % Eigenvalue
  % lam_floquet = u_in(end);
  lam_floquet = u_in(13);

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Reshape indices for monodromy matrix 
  M1 = reshape(v1_idx, 3, 3);

  % fprintf('~~~ Monodromy Matrix ~~~\n');
  % fprintf('(%.7f, %.7f, %.7f)\n', M1(1, :));
  % fprintf('(%.7f, %.7f, %.7f)\n', M1(2, :));
  % fprintf('(%.7f, %.7f, %.7f)\n\n', M1(3, :));

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Eigenvalue equations
  eig_eqn = (M1 * vec_floquet) - (lam_floquet * vec_floquet);

  % Unit vector equations
  vec_eqn = (vec_floquet' * vec_floquet) - 1;

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [eig_eqn;
           vec_eqn];

end