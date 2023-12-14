# COCO Tutorial Examples
Here are a bunch of different example problems and how to solve them using the [Continuation Core and Toolboxes (COCO)](https://sourceforge.net/projects/cocotools/) software. Some of these examples and tutorials come from the book *Recipes for Continuation* by Harry Dankowicz and Frank Schilder, and some of the examples come from the toolbox documentation.

All of the code is extensively commented, with most of the defined functions having doc strings too.

Here is a break down on the included examples.

## lins_method_examples

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