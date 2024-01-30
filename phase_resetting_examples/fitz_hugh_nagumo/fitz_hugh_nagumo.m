%-------------------------------------------------------------------------%
%%                              Setup Stuff                              %%
%-------------------------------------------------------------------------%
% Clear plots
close all;
% Clear workspace
clear all;
% Clear console
clc;

% Add system equation functions (and other functions) to path
addpath('./functions/');
addpath('./boundary_conditions/');
addpath('./continuation_scripts/');
addpath('./plotting_scripts/');

% Symbolic functions
addpath('./functions/symbolic/');
addpath('./boundary_conditions/symbolic/');

% Figure saving switch
save_figure = true;
% save_figure = false;

%--------------------%
%     COCO Setup     %
%--------------------%
% Parameters
c = 2.5;
a = 0.7;
b = 0.8;
z = -0.4;

p0 = [c; a; b; z];
pnames = {'c'; 'a'; 'b'; 'z'};

% Initial state vector
% x0 = [0.9066; -0.2582];
x0 = [0.2729; 0.5339];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%------------------------%
%     Function Lists     %
%------------------------%
% List of vector field functions
% func_list = {@fhn, @fhn_DFDX, @fhn_DFDP};
[~, func_list] = symbolic_fhm();

%-------------------------------------------------------------------------%
%%                         Initial Continuation                          %%
%-------------------------------------------------------------------------%
% We set up the continuation problem by first continuing the equilibrium
% point x0. The equilibrium point undergoes a Hopf bifurcation, from which
% a family of periodic orbits originate.

% Add continuation scripts to path
addpath('./continuation_scripts/initial_periodic_orbit/');

% List of periodic orbit boundary condition functions
bcs_funcs.bcs_PO_list  = symbolic_bcs_PO();
bcs_funcs.bcs_adj_list = symbolic_bcs_floquet();

%-------------------------------------%
%%     Compute Equilibrium Point     %%
%-------------------------------------%
% We compute and continue the equilibrium point of the model using
% the 'EP' toolbox constructor 'ode_isol2ep'.

% Run name
run_names.initial_EP = 'run01_initial_EP';

% Run continuation script
initial_equilibrium_point;

%------------------------------------%
%%     Continue Hopf To z = -0.8     %
%------------------------------------%
% Continuing from a Hopf bifurcation with 'ode_HB2HB', we vary
% the 'z' parameter to z = -0.8

% Run name
run_names.hopf_move_z = 'run02_move_z';

% Run continuation script
hopf_move_z;

%-----------------------------------------%
%%     Continue New Initial Solution     %%
%-----------------------------------------%
% Reading from the previous solution where z = -0.8, we continue a new 
% solution and vary 'z' and 'c'.

% Run name
run_names.hopf_new_solution = 'run03_hopf_new_solution';

% Run continuation
hopf_new_solution;

%----------------------------------%
%%     Hopf to Periodic Orbit     %%
%----------------------------------%
% Continue a family of periodic orbits emanating from the Hopf
% bifurcation with 'ode_HB2po'.

% Run name
run_names.hopf_to_PO = 'run04_hopf_to_PO';

% Run continuation
hopf_to_PO;

%------------------------------------------%
%%     Compute Initial Periodic Orbit     %%
%------------------------------------------%
% Using previous parameters and MATLAB's ode45 function, we solve for an
% initial solution to be fed in as a periodic orbit solution.

% Run name
run_names.initial_periodic_orbit = 'run05_initial_periodic_orbit';

% Run continuation
initial_periodic_orbit;

%-------------------------------------------------------------------------%
%%               Compute Floquet Bundle at Zero Phase Point              %%
%-------------------------------------------------------------------------%
% Here we compute the stable Floquet bundle of the periodic orbit, as well
% as the perpendicular vector, w.

% Add continuation scripts to path
addpath('./continuation_scripts/floquet_bundle/');

%------------------------------------------------%
%%     Continue the Eigenvalue Until mu_s=1     %%
%------------------------------------------------%
% We now add the adjoint function and Floquet boundary conditions to
% compute the adjoint (left or right idk) eigenvectors and eigenvalues.
% This will give us the perpendicular vector to the tangent of the periodic
% orbit. However, this will only be for the eigenvector corresponding to
% the eigenvalue \mu = 1. Hence, here we continue in \mu (mu_f) until
% mu_f = 1.

% Run name
run_names.compute_floquet_1 = 'run06_compute_floquet_bundle_1_mu';

% Run continuation script
floquet_mu;

%---------------------------------------------%
%%     Continue the Norm of the w vector     %%
%---------------------------------------------%
% Having found the solution (branching point 'BP') corresponding to
% \mu = 1, we can continue in the norm of the vector w (w_norm), until the
% norm is equal to zero. Then we will have the correct perpendicular
% vector.

% Run name
run_names.compute_floquet_2 = 'run07_compute_floquet_bundle_2_w';

% Run continuation script
floquet_wnorm;

%-------------------------------------------------------------------------%
%%                   Phase Response Curve Calculation                    %%
%-------------------------------------------------------------------------%
% We set up the phase resetting problem by creating four segments of the
% periodic orbit, with boundary conditions described in a paper somewhere.

% Add continuation scripts to path
addpath('./continuation_scripts/phase_reset/');

%------------------------%
%     Function Lists     %
%------------------------%
% HARDCODED: Function lists
% seg1_list = {@func_seg1, [], []};
% seg2_list = {@func_seg2, [], []};
% seg3_list = {@func_seg3, [], []};
% seg4_list = {@func_seg4, [], []};

% HARDCODED: Boundary conditions
% bcs_funcs.bcs_seg1_seg2_list = {@bcs_PR_seg1_seg2};
% bcs_funcs.bcs_seg1_seg2_list = {@bcs_PR_seg1_seg2, @bcs_PR_seg1_seg2_du};
% bcs_funcs.bcs_seg1_seg2_list = {@bcs_PR_seg1_seg2, @bcs_PR_seg1_seg2_du, @bcs_PR_seg1_seg2_dudu};

% bcs_funcs.bcs_seg3_list      = {@bcs_PR_seg3};
% bcs_funcs.bcs_seg3_list      = {@bcs_PR_seg3, @bcs_PR_seg3_du};
% bcs_funcs.bcs_seg3_list      = {@bcs_PR_seg3, @bcs_PR_seg3_du, @bcs_PR_seg3_dudu};

bcs_funcs.bcs_seg4_list      = {@bcs_PR_seg4};
% bcs_funcs.bcs_seg4_list      = {@bcs_PR_seg4, @bcs_PR_seg4_du};
% bcs_funcs.bcs_seg4_list      = {@bcs_PR_seg4, @bcs_PR_seg4_du, @bcs_PR_seg4_dudu};

% SYMBOLIC: Function Lists
seg1_list = symbolic_func_seg1();
seg2_list = symbolic_func_seg2();
seg3_list = symbolic_func_seg3();
seg4_list = symbolic_func_seg4();

% SYMBOLIC: Boundary conditions
bcs_funcs.bcs_seg1_seg2_list = symbolic_bcs_PR_seg1_seg2();
bcs_funcs.bcs_seg3_list      = symbolic_bcs_PR_seg3();
% bcs_funcs.bcs_seg4_list      = symbolic_bcs_PR_seg4();

%-------------------------------------------------------%
%%     First Continuation: theta_new and theta_old     %%
%-------------------------------------------------------%
% We compute the first phase resetting curve.

% Run name
run_names.phase_response_curve_1 = 'run08_phase_response_curve_1';

% Run continuation script
phase_reset_1;

%-------------------------------%
%%     Compute Isochrons:      %%
%-------------------------------%
% Run name
run_names.phase_response_curve_2 = 'run09_phase_response_curve_2';

% Run continuation script
% phase_reset_isochron_test;
phase_reset_isochron_all;
