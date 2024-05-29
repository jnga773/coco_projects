% Clear plots
close('all');

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');
addpath('./boundary_conditions/');
addpath('./continuation_scripts/');
addpath('./plotting_scripts/');

% Symbolic functions
addpath('./functions/symbolic/');
addpath('./boundary_conditions/symbolic/');

% Save figures switch
save_figure = true;
% save_figure = false;

%-----------------------------------------------------------------------%
%%              WINFREE MODEL (Phase Resetting Isochrons)              %%
%-----------------------------------------------------------------------%
% Doing an exmaple from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.

%--------------------%
%     Parameters     %
%--------------------%
% Set parameters to the same thing as in the paper
a = 0;
omega = -0.5;

%--------------------%
%     COCO Setup     %
%--------------------%
% Parameter names
pnames = {'a', 'omega'};

% Initial parameter values
p0 = [a; omega];

% Initial state values
x0 = [0; 0];

% % Parameter ranges
a_range = [-2.0, 2.0];
omega_range = [-5.0, 5.0];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-----------------------------------------------------------------------%
%%                           Function Lists                            %%
%-----------------------------------------------------------------------%
%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
% funcs.field = {@winfree, @winfree_DFDX, @winfree_DFDP};
% funcs.field = {@winfree, @winfree_DFDX};
funcs.field = winfree_symbolic();

% Boundary conditions: Periodic orbit
% bcs_funcs.bcs_PO = {@bcs_PO};
bcs_funcs.bcs_PO = bcs_PO_symbolic();

% Boundary conditions: Period
% bcs_funcs.bcs_T = {@bcs_T};
bcs_funcs.bcs_T = bcs_T_symbolic();

%-----------------------------------------------------------------------%
%%                        Initial Continuation                         %%
%-----------------------------------------------------------------------%
% We set up the continuation problem by first continuing the equilibrium
% point x0. The equilibrium point undergoes a Hopf bifurcation, from which
% a family of periodic orbits originate.

% Add continuation scripts to path
addpath('./continuation_scripts/initial_periodic_orbit/');
addpath('./plotting_scripts/initial_periodic_orbit/');

%--------------------------------------------%
%%     Initial Continuation: PO Toolbox     %%
%--------------------------------------------%
% Find initial equilibrium points along line \gamma = 0.08
run_names.initial_periodic_orbit_PO = 'run01_initial_periodic_orbit_PO';

% Run continution script
initial_periodic_orbit_PO;

%----------------------------------------------%
%%     Initial Continuation: COLL Toolbox     %%
%----------------------------------------------%
% Second test run
run_names.initial_periodic_orbit = 'run02_initial_periodic_orbit';

% Run continution script
initial_periodic_orbit;

%-----------------------------------------------------------------------%
%%              Compute Floquet Bundle at Zero Phase Point             %%
%-----------------------------------------------------------------------%
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

%----------------------------------------------------------------%
%%     Compute Floquet Bundle at Zero Phase Point (with mu)     %%
%----------------------------------------------------------------%
% We now add the adjoint function and Floquet boundary conditions to
% compute the adjoint (left or right idk) eigenvectors and eigenvalues.
% This will give us the perpendicular vector to the tangent of the periodic
% orbit. However, this will only be for the eigenvector corresponding to
% the eigenvalue \mu = 1. Hence, here we continue in \mu (mu_f) until
% mu_f = 1.

% Run name
run_names.compute_floquet_1 = 'run03_floquet_mu';

% Run continuation script
floquet_mu;

%--------------------------------------------------------------------%
%%     Compute Floquet Bundle at Zero Phase Point (with w_norm)     %%
%--------------------------------------------------------------------%
% Having found the solution (branching point 'BP') corresponding to
% \mu = 1, we can continue in the norm of the vector w (w_norm), until the
% norm is equal to zero. Then we will have the correct perpendicular
% vector.

% Run name
run_names.compute_floquet_2 = 'run04_floquet_wnorm';

% Run continuation script
floquet_wnorm;

%-----------------------------------------------------------------------%
%%                 Phase Response - Compute Isochrons                  %%
%-----------------------------------------------------------------------%
% We set up the phase resetting problem by creating four segments of the
% periodic orbit, with boundary conditions described in a paper somewhere.
% We then calculate the isochrons of the system.

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

