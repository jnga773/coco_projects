# COCO Tutorial Examples
Here are a bunch of different example problems and how to solve them using the [Continuation Core and Toolboxes (COCO)](https://sourceforge.net/projects/cocotools/) software. Some of these examples and tutorials come from the book *Recipes for Continuation* by Harry Dankowicz and Frank Schilder, and some of the examples come from the toolbox documentation.

All of the code is extensively commented, with most of the defined functions having doc strings too.

Here is a break down on the included examples.

## Lin's Method Examples

Here are some example systems that make use of Lin's method to solve for homoclinic orbits and heteroclinic connections. If you have any questions about this, please email me: [j.ngaha@auckland.ac.nz](mailto:j.ngaha@auckland.ac.nz).

Here is an outline of the method used to implement Lin's method.

1. Define initial conditions for the unstable and stable manifolds, `x_init_u` and
   `x_init_s`, the intersection plane $\Sigma$ with the normal vector `normal`
   and intersection point `pt0`, and initial $\epsilon$ values, `eps1` and `eps2`. These are saved to
   the data structure `data_bcs` in the script `lins_method_setup.m`.

2. Construct instances of the `coll` toolbox for the unstable and stable manifolds, with
   ```matlab
   % Create COCO problem structure
   prob = coco_prob();
   % Construct instance of unstable manifold, with conditions pre-defined in data_bcs
   prob = ode_isol2coll(prob, 'unstable', list_of_functions{:}, ...
                        data_bcs.t0, data_bcs.x_init_u, data_bcs.p0);
   % Construct instance of stable manifold, with conditions pre-defined in data_bcs
   prob = ode_isol2coll(prob, 'stable', list_of_functions{:}, ...
                        data_bcs.t0, data_bcs.x_init_s, data_bcs.p0);
   % Apply boundary conditions, glue parameters, and add events with the following function
   prob = glue_conditions(prob, data_bcs, epsilon0);
   ```

3. Further continuations are built using the `ode_coll2coll` constructor:
   ```matlab
   % Create COCO problem structure
   prob = coco_prob();
   % Reconstruct unstable manifold from previous solution
   prob = ode_coll2coll(prob, 'unstable', previous_run_string_identifier, previous_solution_label);
   % Reconstruct stable manifold from previous solution
   prob = ode_coll2coll(prob, 'stable', previous_run_string_identifier, previous_solution_label);
   % Extract stored deviation values (eps1 and eps2) from previous solution
   [data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
   epsilon = chart.x(data.epsilon_idx);
   % Apply boundary conditions, glue parameters, and add events with the following function
   prob = glue_conditions(prob, data_bcs, epsilon0);
   ```

4. When closing the Lin gap, we need to add the Lin gap conditions. The Lin gap vector and initial 
   distance are calculated with the `find_lingap_vector()` function, and saved to the `data_lins`
   data structure.
   ```matlab
   prob = previous code...
   % Calculate the Lin gap vector, and initial distance.
   data_lins = find_lingap_vector(previous_run_string_identifier, previous_solution_label);
   % Extract Lin gap distance
   lingap = data_lins.lingap;
   % Apply Lin conditions
   prob = glue_lingap_conditions(prob, data_lins, lingap);
   ```

Example template code can be found in the `./template_lins_method_scripts/` directory. You will need to change the code in most of the files to work with your specific system. Lines you definitely need to check have an extra comment mentioning this.

### EtoP_lorenz
This is an example of a heteroclinic E-to-P connection in the Lorenz system of equations, as described in Section 10.2.2 in *Recipes for Continuation*.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 3-dimensional system with three system parameters.

This is also an example on how to compute **Floquet bundles** directly by first computing the **monodromy matrix**. The monodromy matrix is computed by setting up a variational problem in the `po` toolbox with
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
[data, uidx] = coco_get_func_data(prob, 'po.orb.coll.var', 'data', 'uidx');
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

<ins>**At the moment the two-parameter continuation via Lin's method doesn't follow the entire range. I still need to figure out what's wrong**</ins>

### homoclinic_strogatz
This is an example of a homoclinic orbit, in a similar system to the Hopf normal form as found in Section 8.4 in *Nonlinear Dynamics and Chaos* by Steven H. Strogatz.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 2-dimensional system with one system parameter.


