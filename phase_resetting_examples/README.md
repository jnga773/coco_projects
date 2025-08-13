# Phase Resetting Examples

Here we have two example phase resetting systems: the Winfree and the FitzHugh-Nagumo model. Both models are two-dimensional, but the code is written to also easily support three-dimensional systems. Anything more requires a little more rewriting.

Pretty much all of the files are thoroughly commented throughout the script, and I think all of the functions have fairly descriptive docstrings. If you find a better way to compute/organise this, please let me know haha, but this works for me :)

There are three (or four) computation files in each folder:
- `find_periodic_orbit.m`: Computes the initial periodic orbit from a family of orbits emanating from a Hopf bifurcation.
- `initial_periodic_orbit.m`: Computes the initial periodic orbit via numerical integration, then solves the variational adjoint problem.
- `PTC.m`: Computes phase transition curves (PTCs) using the phase resetting problem structure.
- `isochrons.m`: Computes isochrons of the periodic orbit using the phase resetting problem structure.
  
The boundary conditions and vector field encodings are written in regular Matlab, and also with SymCOCO, which allows for the symbolic encoding of the functions, Jacobians, and Hessians. Supply COCO with these files makes things much faster, and SymCOCO takes care of actually figuring out the Jacobians etc.

## Phase Resetting Method Outline
Here is a very rough outline of the method used to calculate this phase resetting stuff.

1. Step One: Find a periodic orbit ("Initial Periodic Orbit")
   
   Either computer a periodic orbit from a Hopf bifurcation using `ode_HB2po` (as in the `find_initial_periodic_orbit.m` script), or numerically integrate using `ode45` for some set parameters. This will have some initial phase condition, but for phase resetting, we need `x1(0) = max(x1)`. Rotate the periodic orbit to fit this condition, and confirm the solution to the BVP using `ode_isol2coll`.

2. Step Two: Compute the adjoint variational problem of the stable Floquet direction ("Floquet Bundle")
   
   We set this up as a BVP using the `COLL` toolbox, with `ode_isol2coll`. The initial solution is computed in the `calc_initial_solution_VAR.m` function using data from the previous step. This computation is done in two steps: first, we continue in the stable eigenvalue `mu_s`, until `mu_s = 1.0`; then we switch branches, and compute in the norm of the stable eigenvector `wnorm`, until `wnorm = 1.0`.

3. Step Three: Compute phase resetting stuff ("PTCs" or "Isochrons")
   
   Using the final solution from the adjoint variational problem, we can compute the initial solution to the phase resetting problem (`calc_initial_solution_PR.m`). We split the four segments of the phase resetting problem into four separate `COLL` segments, with `ode_isol2coll`. We also continue the equilibrium point which lives "inside" the periodic orbit with `ode_ep2ep`. This segment is also used in the boundary condition functions to determine the dimensions of the state-space `xdim`, parameter space `pdim`, and the base vector fields `fhan`.

## Code Structure
The structure of each example folder is as follows:

- `continuation_scripts`: Contains all the Matlab function files for different continuation steps. It contains the following functions:
  - `glue_parameters_PO.m` - Glues the parameters of the `PO` and `EP` toolbox calls in the "Initial Periodic Orbit" run.
  - `apply_boundary_conditions_PO.m` - Glues parameters between segments, and applied periodic orbit boundary conditions in the "Initial Periodic Orbit" runs.
  - `apply_boundary_conditions_VAR.m` - Applies boundary conditions to the adjoing variational problem in the "Floquet Bundle" runs.
  - `apply_boundary_conditions_PR.m` - Glues parameters between segments, and applies the various boundary conditions on the phase resetting segments.
  - `calc_initial_solution_ODE45.m` - Numerically integrates a solution using `ode45` up to a single period, which is then input as an initial solution to the `ode_isol2po` call.
  - `calc_initial_solution_PO.m` - Reads the COCO solutions from the `'PO'` toolbox run, rotates the periodic orbit so that the first point is the max of the x1-coordinate, and outputs the initial solution to a data structure. This is then fed into the `ode_isol2coll` call.
  - `calc_initial_solution_VAR.m` - Reads the solution from the rotated periodic orbit `COLL` run, and sets up the initial solution for the variational adjoint problem.
  - `calc_initial_solution_PR.m` - Reads the solution from the last "Floquet Bundle" run, and sets up the initial solution and parameters for the phase reset runs. There is an `isochron` flag which changes some of the parameters depending on if you want polar or euclidean coordinates.
  - `run_PR_continuation.m` - Once the first phase resetting run is set up (with the `ode_isol2coll` calls), the code block for each run is essentially the same. To tidy things up, I mushed it all into this one function.
- `functions`: Contains all of the COCO compatible encodings of the boundary conditions (`bcs`), vector fields (`fields`), and the output files from SymCOCO (`symcoco`)
- `plotting_scripts`: A collection of scripts used to plot and visualise some of the computations.


## Things to Change for Other Systems
This phase resetting code is written to be fairly generic. To make this work for your system, however, there are a few things you need to change in the code:

- Symbolic boundary conditions in `functions/bcs/`:
  - `xdim`: The state-space dimension of the original vector field,
  - `pdim`: The parameter-space dimension of the original vector field,
  - `field`: The symbolic encoding of the original vector field.
- Hard-coded **and** symbolic vector fields in `functions/fields`:
  - `xdim`: The state-space dimension of the original vector field,
  - `pdim`: The parameter-space dimension of the original vector field,
  - `field`: The symbolic or hard-coded encoding of the original vector field,
  - `field_DFDX`: The hard-coded encoding of the original state-space Jacobian.
- Obviously the hard-coded vector fields `XXX`, `XXX_DFDX`, and `XXX_DFDP`, e.g. `winfree_DFDX` or `fhn_DFDP`.
- Also, the parameters, paramter names for the specific periodic orbit you're looking for in `initial_periodic_orbit.m`, and at the start of `PTC.m` and `isochron.m`.
- The perturbation vector in`bcs_PR.m` and `bcs_PR_symbolic.m` is defined in polar co-ordinates: $d = (\cos(\theta), \sin(\theta)$ for 2D and $d = (\cos(\theta) \sin(\phi), \sin(\theta) \sin(\phi), \cos(\phi))$ for 3D. If you have a higher dimension, or want a specific arrangement, you will have to change this.
  
  This code is written to support up to 3-dimensional problems only. Anything more will require more components for $d$. These are defined in `continuation_scripts/calc_initial_solution_PR.m`, so you will have to adapt that file too.

The order of the phase-resetting parameters is important, as that is how they are defined in all of the boundary condition functions. If you want to change them around, make sure the order is the same in `calc_initial_solution_PR.m` as well as the boundary conditions.

There may be more, so look out for Matlab's error codes.