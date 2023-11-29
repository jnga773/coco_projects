# homoclinic_coco

We compute a family of periodic orbits emanating from a Hopf bifurcation
point of the dynamical system:

$$x_{1}' = p_{1} x_{1} + x_{2} + p_{2} x_{1}^{2} ,$$

$$x_{2}' = -x_{1} + p_{1} x_{2} + x_{2} x_{3} ,$$

$$x_{3}' = x_{2} (p_{1}^{2} - 1) - x_{1} - x_{3} + x_{1}^{2} .$$

The homoclinic can be approximated as a large-period periodic orbit in a couple steps:

1. Find the Hopf bifurcation
   
   We initialise the problem with `./continuation_scripts/initial_continuation/` by following the equilibrium point using the `ep` toolbox constructor `ode_isol2ep`. The Hopf bifurcation is found with label `HB`.

2. Continue periodic orbits from the Hopf bifurcation

   With the Hopf bifurcation found, we continue a family of periodic orbits emanating from this point with the constructor `ode_HB2po`, by freeing one of the system parameters, `p1`, and the period of the orbit with parameter `'po.period`.

3. Insert artificial time segment

   With a large period periodic orbit found, we can insert a long time segment, artificially increasing the period even more. A solution is then verified with the zero-dimensional continuation with constructor `ode_isol2po`.

4. Follow 'homoclinic' in two parameters

   Having found a very very large period periodic orbit which closely approximates a homoclinic orbit, we follow this object in two parameters with the constructor `ode_po2po` by freeing the two parameters `p1` and `p2`.

The homoclinic is solved using Lin's method in several steps:

1. Construct the problem
   
   The problem itself is constructed as two collocation segments in `./continuation_scripts/lins_method_unstable_manifold.m`, with two calls to the COCO constructor `ode_isol2coll`. The initial conditions, parameters, and other important inputs are first calculated in  `./continuation_scripts/lins_method_setup.m`, and saved to the data structure `data_bcs`.

2. Append the boundary conditions
   
   The boundary conditions for the unstable and stable manifolds, found as functions in `./continuation_scripts/problem_functions/` are then appended with the glue_conditions() function. The system parameters of the two segments are then "glued" together with `coco_add_glue`, i.e., we tell COCO that they are the same parameters. We then add the \epsilon spacings (`eps1`, `eps2`) and periods (`T1` and `T2`) of the two segments as system parameters, and also add the parameters `seg_u` and `seg_s`, representing the distance between the plane $\Sigma$ (defined in `lins_method_setup`) and the end points of the unstable and stable manifolds, respectively.

3. Grow unstable manifold

   We free the parameter seg_u, allowing the unstable manifold to grow until it hits the plane $\Sigma$, which is defined as a label `DelU`.

4. Grow stable manifold
   
   We reconstruct the COCO problem with `ode_coll2coll`, re-append the boundary conditions, and then free `seg_s`, growing the stable manifold until it starts on the plane $\Sigma$, corresponding to the label `DelS`.

5. Close the Lin gap
  
   We reconstruct the problem again, and then calculate the Lin gap vector, and initial distance, using the function `find_lingap_vector()`. The Lin gap boundary condition is then added with `glue_lin_conditions()`, and the parameter `lingap` is freed, closing the Lin gap until the unstable and stable manifolds connect.

6. Follow in two-parameters

   With the homoclinic found, we then free then reconstruct the problem again, and then free the two system parameters `p1` and `p2`, following the heteroclinic in two parameters.
