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

% Indices for unstable eigenvalue
unstable_index = diag(eigval) > 0;
% Indices for stable eigenvalue
stable_index   = diag(eigval) < 0;

% Unstable eigenvector
vu = eigvec(:, unstable_index);
% Stable eigenvector
vs = eigvec(:, stable_index);

% Unstable eigenvalue
lu = eigval(unstable_index, unstable_index);
% Stable eigenvalue
ls = eigval(stable_index, stable_index);

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

%---------------------------------------%
%     Boundary Conditions: Unstable     %
%---------------------------------------%
% Append boundary conditions to continue the unstable eigenvalues and eigenvectors
prob = coco_add_func(prob, 'bcs_eig_unstable', @boundary_conditions_eig, [], ...
                     'zero', 'uidx', ...
                     [uidx(maps.x_idx); ...
                      uidx(maps.p_idx)], ...
                     'u0', [vu; lu]);

% Get u-vector indices from this coco_add_func call, including the extra
% indices from the added "vu" and "lu".
uidx_eigu = coco_get_func_data(prob, 'bcs_eig_unstable', 'uidx');

% Grab eigenvector and value indices from u-vector
vu_idx = [numel(uidx_eigu) - 2; numel(uidx_eigu) - 1];
lu_idx = numel(uidx_eigu);

% Define active parameters for unstable eigenvector and eigenvalue
prob = coco_add_pars(prob, 'eig_unstable', ...
                     [uidx_eigu(vu_idx); uidx_eigu(lu_idx)], ...
                     {'vu_1', 'vu_2', 'lu'}, ...
                     'active');

%-------------------------------------%
%     Boundary Conditions: Stable     %
%-------------------------------------%
% Append boundary conditions to continue the unstable eigenvalues and eigenvectors
prob = coco_add_func(prob, 'bcs_eig_stable', @boundary_conditions_eig, [], ...
                     'zero', 'uidx', ...
                     [uidx(maps.x_idx); ...
                      uidx(maps.p_idx)], ...
                     'u0', [vs; ls]);

% Get u-vector indices from this coco_add_func call, including the extra
% indices from the added "vu" and "lu".
uidx_eigs = coco_get_func_data(prob, 'bcs_eig_stable', 'uidx');

% Grab eigenvector and value indices from u-vector
vs_idx = [numel(uidx_eigs) - 2; numel(uidx_eigs) - 1];
ls_idx = numel(uidx_eigs);

% Define active parameters for unstable eigenvector and eigenvalue
prob = coco_add_pars(prob, 'eig_stable', ...
                     [uidx_eigs(vs_idx); uidx_eigs(ls_idx)], ...
                     {'vs_1', 'vs_2', 'ls'}, ...
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
