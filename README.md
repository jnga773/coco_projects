# COCO Tutorial Examples
Here are a bunch of different example problems and how to solve them using the [Continuation Core and Toolboxes (COCO)](https://sourceforge.net/projects/cocotools/) software. Some of these examples and tutorials come from the book *Recipes for Continuation* by Harry Dankowicz and Frank Schilder, and some of the examples come from the toolbox documentation.

All of the code is extensively commented, with most of the defined functions having doc strings too. If you have any questions about this, please email me: [j.ngaha@auckland.ac.nz](mailto:j.ngaha@auckland.ac.nz).

Here is a brief summary of the included examples.

## continue_eigenvectors

An example of calculating and continuing eigenvectors of two different types:
1. The unstable and stable eigenvectors and eigenvalues of the Jacobian at some equilibrium point, using the `ep` and `coll` toolboxes (`EP_jacobian_eig`)
2. Floquet bundle / eigenvectors of the monodromy matrix of a periodic orbit using the `po` and `coll` toolboxes (`PO_floquet_eig`)


## lins_method_examples

Here are some example systems that make use of Lin's method to solve for homoclinic orbits and heteroclinic connections in various two- or three-dimensional systems using the `po`, `ep`, and `coll` toolboxes.

## phase_resetting_examples

Some examples for the computation of phase resetting of stable periodic orbits. The two examples here are both planar/two-dimensional examples, where phase transition curves (PTCs) and isochrons are computed.

## stable_manifolds

Here are example calculations of stable manifolds. Both examples are for the 3D Yamada model system of equations. One example calculates the 1D stable manifold of a saddle equilibrium point, and the other calculates the 2D strong stable manifold of a stable periodic orbit.