# Stable Manifold Examples

Here are a couple examples for calculating some stable manifolds: a two-dimensional strong-stable manifold of a periodic orbit, and a one-dimensional stable manifold of a saddle equilibrium point. Both of these examples are for the three-dimensional Yamada model of a Q-switched laser.

## periodic_orbit_2D_manifold

We calculate the strong-stable manifold of a stable periodic orbit.

To do this, we compute the Floquet bundle of the periodic orbit using the `'-var', eye(xdim)` options in the `ode_isol2po`function. To see more on how this is done, please look at the `PO_floquet_monodromy` example in `continue_eigenvectors`.


## saddle_1D_manifold

We calculate the one-dimensional stable manifold of a saddle equilibrium point that lives in the "centre" of a stable periodic orbit.

We need to continue the stable eigenvector of the Jacobian to follow the stable manfiold. Unlike the `EP_jacobian_eig` example in `continue_eigenvectors`, we do not do this through applying boundary condition functions. Instead, we use the fact that the eigenvectors are stored by the `EP` toolbox. When getting the function data and index information through
```MATLAB
[data, uidx] = coco_get_func_data(prob, 'xpos.ep', 'data', 'uidx')
```
the eigenvectors of the Jacobian are stored in `data.ep_X`.