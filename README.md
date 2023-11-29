# COCO Tutorial Examples
Here are a bunch of different example problems and how to solve them using the [Continuation Core and Toolboxes (COCO)](https://sourceforge.net/projects/cocotools/) software. Some of these examples and tutorials come from the book *Recipes for Continuation* by Harry Dankowicz and Frank Schilder, and some of the examples come from the toolbox documentation.

All of the code is extensively commented, with most of the defined functions having doc strings too.

If you have any questions about this, please email me: [j.ngaha@aucland.ac.nz](mailto:j.ngaha@auckland.ac.nz).

Here is a break down on the included examples.

## Lin's Method Examples

### EtoP_lorenz
This is an example of a heteroclinic E-to-P connection in the Lorenz system of equations, as described in Section 10.2.2 in *Recipes for Continuation*.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 3-dimensional system with three system parameters.

This is also an example on how to compute Floquet bundles directly by first computing the monodromy matrix. The monodromy matrix is computer by setting up a variational problem in the `po` toolbox with the option
```matlab
% Create COCO problem structure
prob = coco_prob();
% Turn of bifurcation detection (this won't work otherwise)
prob = coco_set(prob, 'po', 'bifus', 'off');
% Set up periodic orbit problem with appended variational problem
prob = ode_HB2po(prob, '', previous_run_identifier_string, previous_solution_label, ...
                   '-var', eye(3));
% Hold the initial condition of solution to variational problem fixed
% Read data and uidx indices
[data, uidx] = coco_get_func_data(prob, 'hopf_po.po.orb.coll.var', 'data', 'uidx');
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars', ...
                     uidx(data.coll_var.v0_idx,:), ...
                     {'s1', 's2', 's3', ...
                      's4', 's5', 's6', ...
                      's7', 's8', 's9'});
```
The initial guess for the monodromy matrix is the identity matrix, and corresponds to the `data.coll_var.v0_idx` indices of the solution vector `u`. The monodromy matrix solution then corresponds to the `data.coll_var.v1_idx` indices.

### heteroclinic_huxley
The is an example of an equilibrium point heteroclinic connection, described by some model discussed in a book by Huxley. This example can be found in Section 3 of *The Trajectory Collocation Toolbox* documentation for COCO.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 2-dimensional system with two system parameters.

### homoclinic_coco
This is an example of a homoclinic orbit, described by some model discused in a book by Marsden. This example can be found in Section 6 of *The Periodic Orbit Toolbox* documentation for COCO.

This is an example of approximating homoclinic orbits in a 3-dimensional system as large-period periodic orbits using the `po` toolbox. We also use Lin's method using the `coll` toolbox to solve for the homoclinic orbit.

**At the moment the two-parameter continuation via Lin's method doesn't follow the entire range. I still need to figure out what's wrong**

### homoclinic_strogatz
This is an example of a homoclinic orbit, in a similar system to the Hopf normal form as found in Section 8.4 in *Nonlinear Dynamics and Chaos* by Steven H. Strogatz.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 2-dimensional system with one system parameter.


