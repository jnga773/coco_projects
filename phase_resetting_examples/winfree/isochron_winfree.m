% Clear plots
close('all');

% Clear workspace
clear;

% Add equation/functions to path
addpath('./functions/');
addpath('./boundary_conditions/');
addpath('./continuation_scripts/');
addpath('./plotting_scripts/');

% Save figures switch
% save_figure = true;
save_figure = false;

%-------------------------------------------------------------------------%
%%               WINFREE MODEL (Phase Resetting Isochrons)               %%
%-------------------------------------------------------------------------%
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
% Set up the list of functions and parameters
% func_list = {@winfree, [], []};
func_list = {@winfree, @winfree_DFDX, @winfree_DFDP};

% Parameter names
pnames = {'a', 'omega'};

% Initial parameter values
p0 = [a; omega];

% Initial state values
x0 = [1; 0];

% % Parameter ranges
% a_range = [0.0, 0.25];
% omega_range = [5.0, 11.0];
% p_range = [A_range, gamma_range];

%-------------------------------------------------------------------------%
%%                         Initial Continuation                          %%
%-------------------------------------------------------------------------%
% We set up the continuation problem by first continuing the equilibrium
% point x0. The equilibrium point undergoes a Hopf bifurcation, from which
% a family of periodic orbits originate.

% Add continuation scripts to path
addpath('./continuation_scripts/initial_periodic_orbit/');

%--------------------------------%
%%     Initial Continuation     %%
%--------------------------------%
% Find initial equilibrium points along line \gamma = 0.08
run_names.initial_PO = 'run01_initial_periodic_orbit_PO';
initial_periodic_orbit_PO;

% Second test run
run_names.initial_coll = 'run02_initial_periodic_orbit_coll';
initial_periodic_orbit;

%-------------------------------------------------------------------------%
%%               Compute Floquet Bundle at Zero Phase Point              %%
%-------------------------------------------------------------------------%
% Here we compute the stable Floquet bundle of the periodic orbit, as well
% as the perpendicular vector, w.

% Add continuation scripts to path
addpath('./continuation_scripts/compute_floquet_bundle/');

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
run_names.compute_floquet_1 = 'run02_compute_floquet_bundle_1_mu';
% Run continuation script
compute_floquet_at_zero_phase_mu;

%--------------------------------------------------------------------%
%%     Compute Floquet Bundle at Zero Phase Point (with w_norm)     %%
%--------------------------------------------------------------------%
% Having found the solution (branching point 'BP') corresponding to
% \mu = 1, we can continue in the norm of the vector w (w_norm), until the
% norm is equal to zero. Then we will have the correct perpendicular
% vector.

% Run name
run_names.compute_floquet_2 = 'run03_compute_floquet_bundle_2_w';
% Run continuation script
compute_floquet_at_zero_phase_w;

%-------------------------------------------------------------------------%
%%                   Phase Response Curve Calculation                    %%
%-------------------------------------------------------------------------%
% We set up the phase resetting problem by creating four segments of the
% periodic orbit, with boundary conditions described in a paper somewhere.

%--------------------------------------------%
%%     First Phase Restting Computation     %%
%--------------------------------------------%
% We compute the first phase resetting curve by freeing A and theta_new.

% Run name
run_names.phase_response_curve_1 = 'run04_phase_response_curve_1';
% Run continuation script
phase_reset_1;

%--------------------------------------------%
%%     First Phase Restting Computation     %%
%--------------------------------------------%
% We compute the first phase resetting curve by freeing theta_old and theta_new.

% Run name
run_names.phase_response_curve_2 = 'run05_phase_response_curve_2';
% Run continuation script
phase_reset_2;
