# EtoP_lorenz

We compute a heteroclinic E-to-P connection in the Lorenz dynamical system

$$x' = -s x + s y,$$

$$y' = -x z + r x - y ,$$

$$z' = x y - b z .$$

The heteroclinic is solved using Lin's method in several steps:

1. Find the Hopb bifurcation
   
   Using the `ep` toolbox, we continue the origin as an equilibrium point with respect to the system paremeter $r$, with COCO problem `ode_isol2ep` in `./continuation_scripts/initial_continuation.m`. A branching point is detected in this run, and continued from in `./continuation_scripts/branching_point.m` with the constructor `ode_BP2ep`, yielding a Hopf bifurcation with label `HB`.

2. Continue family of periodic orbits emanating from the Hopf bifurcation

   A family of periodic orbtis is computed from the Hopf bifurcation using the `po` toolbox, with constructor `ode_HB2po`. As we will calculate an E-to-P connection, we need to calculate the stable Floquet vector of the periodic orbit. We do this by computing the **monodromy matrix** of the periodic orbit as a variational problem. This achieved with the following code:
   ```MATLAB
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

3. Construct the problem
   
   The problem itself is constructed as two collocation segments in `./continuation_scripts/lins_method_unstable_manifold.m`, with two calls to the COCO constructor `ode_isol2coll`, and a periodic-orbit-to-periodic-orbit call with `ode_po2po`:
   ```MATLAB
   % Create COCO problem structure
   prob = coco_prob();
   % Turn of bifurcation detection (this won't work otherwise)
   prob = coco_set(prob, 'po', 'bifus', 'off');
   % Continue from periodic orbit solution
   prob = ode_po2po(prob, '', previous_run_identifier_string, previous_solution_label, ...
                  '-var', eye(3));
   % Create trajectory segment for unstable manifold
   prob = ode_isol2coll(prob, 'unstable', func_list{:}, ...
                        data_bcs.t0, data_bcs.x_init_u, data_bcs.p0);
   % Create trajectory segment for stable manifold
   prob = ode_isol2coll(prob, 'stable', func_list{:}, ...
                        data_bcs.t0, data_bcs.x_init_s, data_bcs.p0);
   % Also add parameters for variational problem as above
   prob = coco_add_pars(prob, ...)
   ```
   
   The initial conditions, parameters, and other important inputs are first calculated in  `./continuation_scripts/lins_method_setup.m`, and saved to the data structure `data_bcs`.

4. Append the boundary conditions
   
   The boundary conditions for the unstable and stable manifolds, found as functions in `./continuation_scripts/problem_functions/` are then appended with the glue_conditions() function. The system parameters of the two segments are then "glued" together with `coco_add_glue`, i.e., we tell COCO that they are the same parameters. We then add the \epsilon spacings (`eps1`, `eps2`) and periods (`T1` and `T2`) of the two segments as system parameters, and also add the parameters `seg_u` and `seg_s`, representing the distance between the plane $\Sigma$ (defined in `lins_method_setup`) and the end points of the unstable and stable manifolds, respectively.

5. Grow unstable manifold

   We free the parameter seg_u, allowing the unstable manifold to grow until it hits the plane $\Sigma$, which is defined as a label `DelU`.

6. Grow stable manifold
   
   We reconstruct the COCO problem with `ode_coll2coll`, re-append the boundary conditions, and then free `seg_s`, growing the stable manifold until it starts on the plane $\Sigma$, corresponding to the label `DelS`.

7. Sweep family of periodic orbits
   
   We reconstruct the COCO problem with `ode_coll2coll`, re-append the boundary conditions, and then free `eps2`, sweeping through a family of periodic orbits where the stable manifold starts on the plane $\Sigma$.

8. Close the Lin gap
    
   We choose the solution from Step Five that starts closest to the end point of the unstable manifold, using the function `find_lingap_vector()`. With this solution chosen, we then close the Lin gap by freeing the parameter `lingap`.

9. Follow in two parameters
    
   With the heteroclinic found, we then free then reconstruct the problem again, and then free the two system parameters `p1` and `p2`, following the heteroclinic in two parameters.