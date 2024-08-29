# continue_eigenvectors

Here are two examples in `COCO` for continuing eigenvectors of the Jacobian or the Monodromy matrix.

## EP_jacobian_eig

We compute and continue the eigenvectors of the Jacobian evaluated at some stationary point. Here is a brief outline of the method used to add the eigenvectors and eigenvalues as part of the extended continuation problem.

1. We first compute the eigenvalues and eigenvectors using the in-built `eig` function, and will apply these as the initial solutions to the eigenvector boundary conditions.

2. The boundary conditions are then applied with the `bcs_eig()` function, added as a monitor function. For the unstable eigenvector:
   ```MATLAB
   prob = coco_add_func(prob, 'bcs_eig_unstable', @bcs_eig, [], ...
                        'zero', 'uidx', ...
                        [INDICES_OF_EQUILIBRIUM_POINT, INDICES_OF_PARAMETERS], ...
                        'u0', [unstable_vector_in, unstable_value_in]);
   ```

3. The components of the eigenvector and the eigenvalue are then added as active parameters:
   ```MATLAB
   % Read indices from added monitor function
   uidx_eigu = coco_get_func_data(prob, 'bcs_eig_unstable', 'uidx');
   % Get corresponding indices for eigenvector and eigenvalue
   vu_idx = [numel(uidx_eigu) - 3; numel(uidx_eigu) - 2; numel(uidx_eigu) - 1];
   lu_idx = numel(uidx_eigu);
   % Add as parameters
   prob = coco_add_pars(prob, 'par_eig_unstable', ...
                        [uidx_eigu(data_out.vu_idx); uidx_eigu(data_out.lu_idx)], ...
                        {'vu_1', 'vu_2', 'lu'});)
   ```

4. Repeat steps 2 and 3 for the other eigenvectors and eigenvalues.

5. Carry on with continuation.

## PO_floquet_monodromy

Here we compute and continue part of the Floquet bundle of a periodic orbit. This can be used, for example, to calculate stable/unstable manifolds of periodic orbits. Here is a brief outline of the method used to add the eigenvectors and eigenvalues as part of the extended continuation problem.