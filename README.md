# COCO Tutorial Examples
Here are a bunch of different example problems and how to solve them using the [Continuation Core and Toolboxes (COCO)](https://sourceforge.net/projects/cocotools/) software. Some of these examples and tutorials come from the book *Recipes for Continuation* by Harry Dankowicz and Frank Schilder, and some of the examples come from the toolbox documentation.

All of the code is extensively commented, with most of the defined functions having doc strings too.

If you have any questions about this, please email me: [j.ngaha@aucland.ac.nz](mailto:j.ngaha@auckland.ac.nz).

Here is a break down on the included examples.

## Lin's Method Examples

### EtoP_lorenz
This is an example of a heteroclinic E-to-P connection in the Lorenz system of equations, as described in Section 10.2.2 in *Recipes for Continuation*.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 3-dimensional system with three system parameters.

### heteroclinic_huxley
The is an example of an equilibrium point heteroclinic connection, described by some model discussed in a book by Huxley. This example can be found in Section 3 of *The Trajectory Collocation Toolbox* documentation for COCO.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 2-dimensional system with two system parameters.

### homoclinic_coco
This is an example of a homoclinic orbit, described by some model discused in a book by Marsden. This example can be found in Section 6 of *The Periodic Orbit Toolbox* documentation for COCO.

This is an example of approximating homoclinic orbits in a 3-dimensional system as large-period periodic orbits using the `po` toolbox. We also use Lin's method using the `coll` toolbox to solve for the homoclinic orbit.

### homoclinic_strogatz
This is an example of a homoclinic orbit, in a similar system to the Hopf normal form as found in Section 8.4 in *Nonlinear Dynamics and Chaos* by Steven H. Strogatz.

This is an example of using Lin's method using the `coll` toolbox to solve for the heteroclinic in a 2-dimensional system with one system parameter.


