# Phase Resetting Examples

Here we have two example phase resetting systems: the Winfree and the FitzHugh-Nagumo model. Both models are two-dimensional, but the code is written to also easily support three-dimensional systems. Anything more requires a little more rewriting.

Pretty much all of the files are thoroughly commented throughout the script, and I think all of the functions have fairly descriptive docstrings. If you find a better way to compute/organise this, please let me know haha, but this works for me :)

There are three (or four) computation files in each folder:
- `find_periodic_orbit.m`: Computes the initial periodic orbit from a family of orbits emanating from a Hopf bifurcation.
- `initial_periodic_orbit.m`: Computes the initial periodic orbit via numerical integration, then solves the variational adjoint problem.
- `PTC.m`: Computes phase transition curves (PTCs) using the phase resetting problem structure.
- `isochrons.m`: Computes isochrons of the periodic orbit using the phase resetting problem structure.

## Phase Resetting Method Outline
Here is a very rough outline of the method used to calculate this phase resetting stuff.

1. Step One: Find a periodic orbit ("Initial Periodic Orbit")
   
   Either computer a periodic orbit from a Hopf bifurcation using `ode_HB2po` (as in the `find_initial_periodic_orbit.m` script), or numerically integrate using `ode45` for some set parameters. This will have some initial phase condition, but for phase resetting, we need `x1(0) = max(x1)`. Rotate the periodic orbit to fit this condition, and confirm the solution to the BVP using `ode_isol2coll`.

2. Step Two: Compute the adjoint variational problem of the stable Floquet direction ("Floquet Bundle")
   
   We set this up as a BVP using the `COLL` toolbox, with `ode_isol2coll`. The initial solution is computed in the `calc_initial_solution_VAR.m` function using data from the previous step. This computation is done in two steps: first, we continue in the stable eigenvalue `mu_s`, until `mu_s = 1.0`; then we switch branches, and compute in the norm of the stable eigenvector `wnorm`, until `wnorm = 1.0`.

3. Step Three: Compute phase resetting stuff ("PTCs" or "Isochrons")
   
   Using the final solution from the adjoint variational problem, we can compute the initial solution to the phase resetting problem (`calc_initial_solution_PR.m`). We split the four segments of the phase resetting problem into four separate `COLL` segments, with `ode_isol2coll`. 

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
