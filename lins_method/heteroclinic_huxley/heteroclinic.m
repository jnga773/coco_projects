% Clear plots
close all;

% Clear workspace
clear;

% Add system equation functions (and other functions) to path
addpath('./functions');
% Add continuation scripts and functions to path
addpath('./continuation_scripts/');
addpath('./continuation_scripts/problem_functions/');
% Add plotting scripts to path
addpath('./plotting_scripts/');

% Save figures switch
save_figure = true;
% save_figure = false;

%-------------------------------------------------------------------------%
%%                  Huxley Model (Heteroclinic Orbit)                    %%
%-------------------------------------------------------------------------%
% Following the model from the COLL-Tutorial.pdf document from COCO, in
% Section 3, with vector field:
%       d/dt x1(t) = x2 ,
%       d/dt x2(t) = (p2 x2) - x1 (1 - x2) - (x1 - p1) ,
% where x1 and x2 are the state space variables, and p1 and p2 are the system
% parameters.
%
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
%     Step Eight: With the heteroclinic found, we then free then reconstruct
%                 the problem again, and then free the two system parameters
%                 p1 and p2, following the heteroclinic in two parameters.

%----------------------------%
%     Initialise Problem     %
%----------------------------%
% Parameter names
pnames = {'p1', 'p2'};

% Initial values for parameters
p1 = 0.5;
p2 = 0.0;

% Parameter vector
p0 = [p1; p2];

% Equilibria points
x0_u = [0; 0];
x0_s = [1.0; 0.0];

% List of functions
% func_list = {@huxley, [], []};
func_list = {@huxley, @huxley_DFDX, []};

%-------------------------------------------------------------------------%
%%               Calculate Heteroclinic Using Lin's Method               %%
%-------------------------------------------------------------------------%
% Setup Lins Method
lins_method_setup;

%-------------------------------------%
%     Solve for Unstable Manifold     %
%-------------------------------------%
% Run name
run_names.unstable_manifold = 'run01_unstable_manifolds';
% Run continuation
lins_method_unstable_manifold;

%-----------------------------------%
%     Solve for Stable Manifold     %
%-----------------------------------%
% Run name
run_names.stable_manifold = 'run02_stable_manifold';
% Run continuation
lins_method_stable_manifold;

%---------------------------%
%     Close the Lin Gap     %
%---------------------------%
% Run name
run_names.close_lingap = 'run03_close_gap';
% Run continuation
lins_method_close_lingap;

%-----------------------------%
%     Close Distance eps1     %
%-----------------------------%
% Run name
run_names.close_eps1 = 'run04_close_eps1';
% Run continuation
lins_method_close_eps1;

%-----------------------------%
%     Close Distance eps2     %
%-----------------------------%
% Run name
run_names.close_eps2 = 'run05_close_eps2';
% Run continuation
lins_method_close_eps2;

%--------------------------------------%
%     Parametrise the Heteroclinic     %
%--------------------------------------%
% Run name
run_names.continue_heteroclinic = 'run6_heteroclinic';
% Run continuation
lins_method_continue_heteroclinic;

%-------------------------------------------------------------------------%
%%                       Plot Bifurcation Diagram                        %%
%-------------------------------------------------------------------------%
plot_bifurcation_diagram(run_names.continue_heteroclinic, save_figure);
