# EtoP_lorenz

We compute a heteroclinic E-to-P connection in the Lorenz dynamical system

$$x' = -s x + s y,$$

$$y' = -x z + r x - y ,$$

$$z' = x y - b z .$$

The heteroclinic is solved using Lin's method in several steps:

1. Construct the problem
   
   The problem itself is constructed as two collocation segments in `./continuation_scripts/lins_method_unstable_manifold.m`, with two calls to the COCO constructor `ode_isol2coll`. The initial conditions, parameters, and other important inputs are first calculated in  `./continuation_scripts/lins_method_setup.m`, and saved to the data structure `data_bcs`.

2. Append the boundary conditions
   
   The boundary conditions for the unstable and stable manifolds, found as functions in `./continuation_scripts/problem_functions/` are then appended with the glue_conditions() function. The system parameters of the two segments are then "glued" together with `coco_add_glue`, i.e., we tell COCO that they are the same parameters. We then add the \epsilon spacings (`eps1`, `eps2`) and periods (`T1` and `T2`) of the two segments as system parameters, and also add the parameters `seg_u` and `seg_s`, representing the distance between the plane $\Sigma$ (defined in `lins_method_setup`) and the end points of the unstable and stable manifolds, respectively.

3. Grow unstable manifold

   We free the parameter seg_u, allowing the unstable manifold to grow until it hits the plane $\Sigma$, which is defined as a label `DelU`.

4. Grow stable manifold
   
   We reconstruct the COCO problem with `ode_coll2coll`, re-append the boundary conditions, and then free `seg_s`, growing the stable manifold until it starts on the plane $\Sigma$, corresponding to the label `DelS`.

5. Sweep family of periodic orbits

   We reconstruct the COCO problem with `ode_coll2coll`, re-append the boundary conditions, and then free `eps2`, sweeping through a family of periodic orbits where the stable manifold starts on the plane $\Sigma$.

6. Close the Lin gap
  
   We choose the solution from Step Five that starts closest to the end point of the unstable manifold, using the function `find_lingap_vector()`. With this solution chosen, we then close the Lin gap by freeing the parameter `lingap`.

7. Follow in two parameters

   With the heteroclinic found, we then free then reconstruct the problem again, and then free the two system parameters `p1` and `p2`, following the heteroclinic in two parameters.