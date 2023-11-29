% Clear plots
close all;

% Clear workspace
clear all;

% Add system equation functions (and other functions) to path
addpath('./functions');
% Add continuation scripts and functions to path
addpath('./continuation_scripts/');
% Add continuation scripts for approximate homoclinic scripts to path
addpath('./continuation_scripts/homoclinic_approx/');
addpath('./continuation_scripts/homoclinic_approx/plotting_scripts/')
% Add Lins method continuation scripts to path
addpath('./continuation_scripts/lins_method/');
addpath('./continuation_scripts/lins_method/problem_functions/');
% Add plotting scripts to path
addpath('./plotting_scripts/');

% Save figures switch
save_figure = true;
% save_figure = false;

%-------------------------------------------------------------------------%
%%   A Hopf bifurcation from Example 8.3 in Recipes for Continuation     %%
%-------------------------------------------------------------------------%
% We compute a family of periodic orbits emanating from a Hopf bifurcation
% point of the dynamical system
%
% x1' = p1*x1 + x2 + p2*x1^2
% x2' = -x1 + p1*x2 + x2*x3
% x3' = (p1^2 - 1)*x2 - x1 - x3 + x1^2
%
% Panels (c) and (d) show the last periodic orbit obtained in the
% continuation run in state space and as a time history. The time history
% shows a phase of slow dynamics, indicating existence of a nearby
% equilibrium point, followed by a fast excursion. 
%
% Starting with the last periodic orbit, we insert a long segment
% of constant dynamics and rescale the period such that the shape of the
% orbit in phase space should be unchanged if there exists a nearby
% homoclinic orbit. The extended time profile after the initial correction
% step is shown in panel (e). We clearly observe an elongated phase of
% near-constant dynamics. We overlay this new solution (black dot) on top
% of the previous orbit (gray circle) in panel (f). The phase plots,
% including the distribution of mesh points, are virtually identical, which
% supports the assumption that a nearby homoclinic orbit exists.
%
% Continuation of the periodic orbit with high period, while keeping the
% period constant, resulting in an approximation to a homoclinic
% bifurcation curve (g). Each point on this curve corresponds to a terminal
% point along a family of periodic orbits emenating from a Hopf bifurcation
% under variations in p_2. Panel (h) shows selected members of the family
% of high-period orbits.
%
% The homoclinic is also solved using Lin's method in several steps:
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
%       Step Six: With the homoclinic found, we then free then reconstruct
%                 the problem again, and then free the two system parameters
%                 p1 and p2, following the heteroclinic in two parameters.

%-------------------------------------------------------------------------%
%%                              Parameters                               %%
%-------------------------------------------------------------------------%
% Parameter names
pnames = {'p1', 'p2'};

% Initial parameter values
p0 = [-1.0; 6.0];

% Initial state values
x0 = [0.0; 0.0; 0.0];

% List of functions
% func_list = {@marsden, [], []};
func_list = {@marsden, @marsden_DFDX, @marsden_DFDP};

% Parameter range for continuation
p1_range = [-1.0, 1.0];
p2_range = [0.0, 40.0];
p_range = [p1_range, p2_range];

%-------------------------------------------------------------------------%
%%                       Parameter Continuation                          %%
%-------------------------------------------------------------------------%
%--------------------------------%
%%     Initial Continuation     %%
%--------------------------------%
% Run name
run_names.initial_run = 'run01_initial_run';

% Calculate the initial continuation for equilibrium points
initial_continuation;

%----------------------------------%
%%     Approximate Homoclinic     %%
%----------------------------------%
%--------------------------------------------%
%     Continuation from Hopf Bifurcation     %
%--------------------------------------------%
% We obtain an initial solution guess from normal form analysis, shown in
% gray in panel (a). The initial correction step coverges to orbit 1. Panel
% (b) shows the family of periodic orbits of increasing amplitudes that
% seem to approach a homoclinic orbit, indicated by the corner that
% develops in the top left part of the plot and allocates many mesh points
% due to slow dynamics.

% Run name
run_names.approx_homo.PO_from_hopf = 'run02_periodic_orbit_from_hopf';

% Continue a periodic orbit from the Hopf birfurcation with increasing
% period.
approx_homoclinic_hopf_to_periodic_orbit;

%-------------------------------------------%
%     Locate High Period Periodic Orbit     %
%-------------------------------------------%
% Run name
run_names.approx_homo.high_period = 'run03_high_period_periodic_orbit';

% Find locate high period periodic orbit
approx_homoclinic_reconstruct_high_period_po;

%------------------------------------------------%
%     Construction of Approximate Homoclinic     %
%------------------------------------------------%
% Run name
run_names.approx_homo.continue_homoclinics = 'run04_continue_approximate_homoclinics';

% Run continuation
approx_homoclinic_continue_homoclinic;

%-----------------------------------------------------%
%%     Saddle-Node and (maybe) Hopf Bifurcations     %%
%-----------------------------------------------------%
run_names.saddle_nodes = 'run05_saddle_node';
saddle_node_line;

run_names.hopf_bifurcations = 'run06_hopf_line';
hopf_line;

%-----------------------------------------------%
%%     Lin's Method for Finding Homoclinic     %%
%-----------------------------------------------%
% Setup Lin's method stuff
lins_method_setup;

% Solve for unstable manifold
run_names.lins_method.unstable_manifold = 'run07_unstable_manifold';
lins_method_unstable_manifold;

% Solve for stable manifold
run_names.lins_method.stable_manifold = 'run08_stable_manifold';
lins_method_stable_manifold;

% Close Lin gap
run_names.lins_method.close_lingap = 'run09_close_lingap';
lins_method_close_lingap;

% Close distance eps1
run_names.lins_method.close_eps1 = 'run10_close_eps1';
% lins_method_close_eps1;

% Close distance eps2
run_names.lins_method.close_eps2 = 'run11_close_eps2';
% lins_method_close_eps2;

% Continue along family of homoclinics
run_names.lins_method.continue_homoclinics = 'run12_continue_homoclinics';
lins_method_continue_homoclinics;
% lins_method_single_segment;

%-------------------------------------------------------------------------%
%%                             Plot Things                               %%
%-------------------------------------------------------------------------%
% Plot bifurcation diagram
plot_bifurcation_diagram(run_names, save_figure);
