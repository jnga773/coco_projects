% Clear plots
close all;

% Clear workspace
clear;

% Add system equation functions (and other functions) to path
addpath('./functions');
% Add Lin's method continuation scripts and functions to path
addpath('./continuation_scripts/');
addpath('./continuation_scripts/problem_functions/');
% Add plotting scripts to path
addpath('./plotting_scripts/');

% Save figures?
save_figure = true;
% save_figure = false;

%-------------------------------------------------------------------------%
%%               Predator-Prey Model from Strogatz Book                  %%
%-------------------------------------------------------------------------%
% We compute a family of periodic orbits emanating from a Hopf bifurcation
% point of the dynamical system
%
% x' = y,
% y' = mu y + x - x^2 + xy .

% The homoclinic is solved using Lin's method in several steps:
%       Step One: The problem itself is constructed as two collocation
%                 segments in ./continuation_scripts/lins_method_unstable_manifold.m,
%                 with two calls to the COCO constructor [ode_isol2coll].
%                 The initial conditions, parameters, and other important
%                 inputs are first calculated in 
%                 ./continuation_scripts/lins_method_setup.m, and saved
%                 to the data structure [data_bcs].
%       Step Two: The boundary conditions for the unstable and stable
%                 manifolds, found as functions in ./continuation_scripts/problem_functions/
%                 are then appended with the glue_conditions() function.
%                 The system parameters of the two segments are then "glued"
%                 together, i.e., we tell COCO that they are the same
%                 parameters. We then add the \epsilon spacings (eps1, eps2) and
%                 periods (T1 and T2) of the two segments as system parameters,
%                 and also add the parameters seg_u and seg_s, representing
%                 the distance between the plane \Sigma (defined in lins_method_setup)
%                 and the end points of the unstable and stable manifolds, respectively.
%     Step Three: We free the parameter seg_u, allowing the unstable manifold to grow
%                 until it hits the plane \Sigma, which is defined as a label
%                 "DelU".
%      Step Four: We reconstruct the COCO problem with ode_coll2coll, re-append
%                 the boundary conditions, and then free seg_s, growing the
%                 stable manifold until it starts on the plane \Sigma,
%                 corresponding to the label DelS.
%      Step Five: We reconstruct the problem again, and then calculate the
%                 Lin gap vector, and initial distance, using the function
%                 find_lingap_vector(). The Lin gap boundary condition is then
%                 added with glue_lin_conditions(), and the parameter "lingap"
%                 is freed, closing the Lin gap until the unstable and stable
%                 manifolds connect.
%       Step Six: We reconstruct the COCO problem with ode_coll2coll, re-append
%                 the boundary conditions, and then free eps1, growing the
%                 unstable manifold until it starts closer to the equilibrium
%                 point.
%     Step Seven: We reconstruct the COCO problem with ode_coll2coll, re-append
%                 the boundary conditions, and then free eps2, growing the
%                 stable manifold until it ends closer to the equilibrium
%                 point.

%--------------------%
%     Parameters     %
%--------------------%
% Parameter names
pnames = 'mu';

% Initial values for parameters
mu = -0.8645;

% Parameter vector
p0 = mu;

% Range for parameter sweeps
p_range = [-2.0; 2.0];

% Equilibria points
x0 = [0; 0];

% % Plot the state-space diagram without continuation
% plot_state_space(p0);

% List of functions
func_list = {@func, [], []};
% func_list = {@func, @func_DFDX, @func_DFDP};

%-------------------------------------------------------------------------%
%%                Solve for Homoclinic Using Lin's Method                %%
%-------------------------------------------------------------------------%
% Setup problem
lins_method_setup;

% Grow unstable manifold
run_names.unstable_manifold = 'run1_unstable_manifold';
lins_method_unstable_manifold;

% Grow stable manifold
run_names.stable_manifold = 'run2_stable_manifold';
lins_method_stable_manifold;

% Close Lin gap
run_names.close_lingap = 'run3_close_lingap';
lins_method_close_lingap;

% Close distance eps1
run_names.close_eps1 = 'run4_close_eps1';
lins_method_close_eps1;

% Close distance eps2
run_names.close_eps2 = 'run5_close_eps2';
lins_method_close_eps2;

