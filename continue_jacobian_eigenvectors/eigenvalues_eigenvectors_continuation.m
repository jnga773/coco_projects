% Clear plots
close all;

% Clear workspace
clear;

% Add system equation functions (and other functions) to path
addpath('./functions');

%-------------------------------------------------------------------------%
%%               Predator-Prey Model from Strogatz Book                  %%
%-------------------------------------------------------------------------%
% We compute a family of periodic orbits emanating from a Hopf bifurcation
% point of the dynamical system
%
% x' = y,
% y' = mu y + x - x^2 + xy .

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

% List of functions
% func_list = {@func, [], []};
func_list = {@func, @func_DFDX, @func_DFDP};

%-------------------------------------------------------------------------%
%%         Setup Equilibrium Point Continuation with Eigenvectors        %%
%-------------------------------------------------------------------------%
%--------------------------------%
%     Calculate Eigenvectors     %
%--------------------------------%
% Calculate Jacobian of equilibrium point
J_dFdX = func_DFDX(x0, p0);

% Calculate unstable eigenvectors and eigenvalues
[eigvec, eigval] = eig(J_dFdX);

% Eigenvectors
vec1 = eigvec(:, 1);
vec2 = eigvec(:, 2);

% Eigenvalues
lam1 = eigval(1, 1);
lam2 = eigval(2, 2);

%----------------------------%
%     Setup COCO Problem     %
%----------------------------%
% Create COCO problem structure
prob = coco_prob();

% Create construction of equilibrium continuation
prob = ode_isol2ep(prob, 'x0', func_list{:}, x0, pnames, p0);

% Extract toolbox data and indices for the equilibrium point
[data, uidx] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

% Extract indices
maps = data.ep_eqn;

%--------------------------------------%
%     Boundary Conditions: Eigen-1     %
%--------------------------------------%
% Append boundary conditions to continue the unstable eigenvalues and eigenvectors
prob = coco_add_func(prob, 'bcs_eig1', @boundary_conditions_eig, [], ...
                     'zero', 'uidx', ...
                     [uidx(maps.x_idx); ...
                      uidx(maps.p_idx)], ...
                     'u0', [vec1; lam1]);

% Get u-vector indices from this coco_add_func call, including the extra
% indices from the added "vu" and "lu".
uidx_eigu = coco_get_func_data(prob, 'bcs_eig1', 'uidx');

% Grab eigenvector and value indices from u-vector
vu_idx = [numel(uidx_eigu) - 2; numel(uidx_eigu) - 1];
lu_idx = numel(uidx_eigu);

% Define active parameters for unstable eigenvector and eigenvalue
prob = coco_add_pars(prob, 'par_eig1', ...
                     [uidx_eigu(vu_idx); uidx_eigu(lu_idx)], ...
                     {'vec1_1', 'vec1_2', 'lam1'}, ...
                     'active');

%--------------------------------------%
%     Boundary Conditions: Eigen-1     %
%--------------------------------------%
% Append boundary conditions to continue the unstable eigenvalues and eigenvectors
prob = coco_add_func(prob, 'bcs_eig2', @boundary_conditions_eig, [], ...
                     'zero', 'uidx', ...
                     [uidx(maps.x_idx); ...
                      uidx(maps.p_idx)], ...
                     'u0', [vec2; lam2]);

% Get u-vector indices from this coco_add_func call, including the extra
% indices from the added "vu" and "lu".
uidx_eigs = coco_get_func_data(prob, 'bcs_eig2', 'uidx');

% Grab eigenvector and value indices from u-vector
vs_idx = [numel(uidx_eigs) - 2; numel(uidx_eigs) - 1];
ls_idx = numel(uidx_eigs);

% Define active parameters for unstable eigenvector and eigenvalue
prob = coco_add_pars(prob, 'par_eig2', ...
                     [uidx_eigs(vs_idx); uidx_eigs(ls_idx)], ...
                     {'vec2_1', 'vec2_2', 'lam2'}, ...
                     'active');

%--------------------------------%
%     Parameter Continuation     %
%--------------------------------%
% The unstable eigenvalue and eigenvector components will be columns
% 'lu', 'vu_1', and 'vu_2' in the bd array.
% The stable eigenvalue and eigenvector components will be columns
% 'ls', 'vs_1', and 'vs_2' in the bd array.

% Calculate continuation
bd = coco(prob, 'test_run', [], 1, 'mu', p_range);
