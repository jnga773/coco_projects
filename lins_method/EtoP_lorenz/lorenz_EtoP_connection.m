% Clear plots
close all;

% Clear workspace
clear;

% Add system equation functions (and other functions) to path
addpath('./functions');
% Add continuation scripts to path
addpath('./continuation_scripts/');
% Add Lin's method continuation scripts and functions to path
addpath('./continuation_scripts/lins_method/');
addpath('./continuation_scripts/lins_method/problem_functions/');
% Add plotting scripts to path
addpath('./plotting_scripts/');

% Save figures switch
% save_figure = true;
save_figure = false;

%-------------------------------------------------------------------------%
%%                  LORENTZ MODEL (Heteroclinic Orbit)                   %%
%-------------------------------------------------------------------------%
% This is a rewrite of the example in Section 10.2.2 of "Recipes for
% Continuation" by Harry Dankowicz and Frank Schilder. In the book they use
% the older 'po' and 'coll' toolboxes. Here, I have rewritten them using the
% newer 'po' and 'coll' tollboxes from the 'ode' toolbox.
%
% We solve for an E-to-P heteroclinic connection using Lin's method.

% The heteroclinic is solved using Lin's method in several steps:
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
%      Step Five: We reconstruct the COCO problem with ode_coll2coll, re-append
%                 the boundary conditions, and then free eps2, sweeping
%                 through a family of periodic orbits where the stable manifold
%                 starts on the plane \Sigma.
%       Step Six: We choose the solution from Step Five that starts closest to the
%                 end point of the unstable manifold, using the function
%                 find_lingap_vector(). With this solution chosen, we then
%                 close the Lin gap by freeing the parameter "lingap".
%     Step Seven: Finally, we reconstruct the problem again and free two of
%                 the system parameters, s and r, and follow the heteroclinic
%                 connection in two parameters.

%--------------------%
%     Parameters     %
%--------------------%
% Some parameters and stuff
s = 10;
b = 8 / 3;
r = 470 / 19;

% Initial parameter array
p0 = [s; r; b];

% Parameter namesS
pnames = {'s', 'r', 'b'};

% Parameter range
r_range = [20, 30];

%---------------------------%
%     List of Functions     %
%---------------------------%
% func_list = {@lorenz, [], [], [], []};
% func_list = {@lorenz, @lorenz_DFDX, @lorenz_DFDP, [], []};
func_list = {@lorenz, @lorenz_DFDX, @lorenz_DFDP, @lorenz_DFDXDX, @lorenz_DFDXDP};

%-------------------------------------------------------------------------%
%%                           COCO Continuation                           %%
%-------------------------------------------------------------------------%
%--------------------------------%
%%     Initial Continuation     %%
%--------------------------------%
% Initial equilibrium point continuation
run_names.initial_continuation = 'run01_initial_continuation';
initial_continuation;

% Branching point continuation
run_names.branching_point = 'run02_branching_point';
branching_point;

%------------------------------------------------%
%%     Periodic Orbit from Hopf Bifurcation     %%
%------------------------------------------------%
% Grow family of periodic orbits from Hopf bifurcation
run_names.hopf_bifurcation = 'run03_hopf_bifurcation_PO';
hopf_bifurcation_periodic_orbit;

%----------------------------------%
%%     Grow Unstable Manifold     %%
%----------------------------------%
% Grow unstable manifold
run_names.unstable_manifold = 'run04_unstable_manifold';
grow_unstable_manifold;

%--------------------------------%
%%     Grow Stable Manifold     %%
%--------------------------------%
% Grow stable manifold
run_names.stable_manifold = 'run04_stable_manifold';
grow_stable_manifold;

%-----------------------------------------------------%
%%     Sweep Family of Orbits in Stable Manifold     %%
%-----------------------------------------------------%
% Sweep family of orbits
run_names.sweep_orbits = 'run05_sweep_orbits';
sweep_family_of_orbits;

%-------------------------%
%%     Close Lin Gap     %%
%-------------------------%
run_names.close_lingap = 'run06_close_lingap';
close_lingap;

%--------------------------------------%
%%     Two-Parameter Continuation     %%
%--------------------------------------%
run_names.continue_heteroclinics = 'run07_continue_heteroclinics';
continue_heteroclinics;
