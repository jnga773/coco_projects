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

%-----------------------------------------------------------------------%
%%             FITZ-HUGH-NAGUMO (Phase Resetting Isochrons)            %%
%-----------------------------------------------------------------------%
% Doing an exmaple from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.

%--------------------%
%     Parameters     %
%--------------------%
% Parameters
c = 2.5;
a = 0.7;
b = 0.8;
z = -0.4;

%--------------------%
%     COCO Setup     %
%--------------------%
p0 = [c; a; b; z];
pnames = {'c'; 'a'; 'b'; 'z'};

% Initial state vector
x0 = [0.9066; -0.2582];
% x0 = [0.2729; 0.5339];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
% funcs.field = {@fhn, @fhn_DFDX, @fhn_DFDP};
funcs.field = fhn_symbolic();

% Boundary conditions: Periodic orbit
% bcs_funcs.bcs_PO = {@bcs_PO};
bcs_funcs.bcs_PO = bcs_PO_symbolic();

% Boundary conditions: Period
% bcs_funcs.bcs_T = {@bcs_T};
bcs_funcs.bcs_T = bcs_T_symbolic();

%-------------------------------------------------------------------------%
%%                         Initial Continuation                          %%
%-------------------------------------------------------------------------%
% We set up the continuation problem by first continuing the equilibrium
% point x0. The equilibrium point undergoes a Hopf bifurcation, from which
% a family of periodic orbits originate.

% Add continuation scripts to path
addpath('./continuation_scripts/initial_periodic_orbit/');
addpath('./plotting_scripts/initial_periodic_orbit/');

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
run_names.follow_hopf = 'run02_follow_hopf';

% Run continuation script
follow_hopf;

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

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Adjoint equations: Functions (for floquet_mu and floquet_wnorm)
% funcs.floquet = {@floquet_adjoint};
funcs.floquet = floquet_adjoint_symbolic();

% Boundary conditions: Floquet multipliers
% bcs_funcs.bcs_floquet = {@bcs_floquet};
bcs_funcs.bcs_floquet = bcs_floquet_symbolic();

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

%-----------------------------------------------------------------------%
%%                 Phase Response - Compute Isochrons                  %%
%-----------------------------------------------------------------------%
% We set up the phase resetting problem by creating four segments of the
% periodic orbit, with boundary conditions described in a paper somewhere.

% Add continuation scripts to path
addpath('./continuation_scripts/isochrons/');
addpath('./plotting_scripts/isochrons/');

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Phase Reset Segment 1: Functions
funcs.seg1 = {@func_seg1};
% funcs.seg1 = func_seg1_symbolic();

% Phase Reset: Segment 2
funcs.seg2 = {@func_seg2};
% funcs.seg2 = func_seg2_symbolic();

% Phase Reset: Segment 3
funcs.seg3 = {@func_seg3};
% funcs.seg3 = func_seg3_symbolic();

% Phase Reset: Segment 4
funcs.seg4 = {@func_seg4};
% funcs.seg4 = func_seg4_symbolic();

% Boundary conditions: Segments 1 and 2
bcs_funcs.bcs_seg1_seg2 = {@bcs_PR_seg1_seg2};
% bcs_funcs.bcs_seg1_seg2 = bcs_PR_seg1_seg2_symbolic();

% Boundary conditions: Segment 3
bcs_funcs.bcs_seg3 = {@bcs_PR_seg3};
% bcs_funcs.bcs_seg3 = bcs_PR_seg3_symbolic();

% Boundary conditions: Segment 4
bcs_funcs.bcs_seg4 = {@bcs_PR_seg4};
% bcs_funcs.bcs_seg4 = bcs_PR_seg4_symbolic();

%------------------------------------------------%
%%     Continue Along the Periodic Orbit     %%
%------------------------------------------------%
% We compute the first phase resetting curve.
% Run name
run_names.isochron_initial = 'run07_isochron_initial';

% Run continuation script
isochron_initial;

%------------------------%
%%     Compute PTC      %%
%------------------------%
% % Run name
% run_names.isochron_test = 'run08_isochron_test';
% % Run continuation script
% isochron_test;

% Run name
run_names.isochron_multi = 'run08_isochron_multi';
% Run continuation script
isochron_multi;

%-------------------------------------------------------------------------%
%%                   Phase Response Curve Calculation                    %%
%-------------------------------------------------------------------------%
% We set up the phase resetting problem by creating four segments of the
% periodic orbit, with boundary conditions described in a paper somewhere.

% Add continuation scripts to path
addpath('./continuation_scripts/phase_reset/');
addpath('./plotting_scripts/phase_reset/');

%------------------------------------------------------%
%%     First Continuation: Perturbation Amplitude     %%
%------------------------------------------------------%
% We compute the first phase resetting curve.

% Run name
run_names.phase_reset_perturbation = 'run07_PTC_perturbation';

% Run continuation script
phase_reset_1_perturbation;

%------------------------%
%%     Compute PTC      %%
%------------------------%
% Run name
run_names.PTC_single = 'run06_PTC_single';

% Run continuation script
PTC_single;

% Run name
% run_names.PTC_multi = 'run06_PTC_scan';

% Run continuation script
% PTCS_scan;

