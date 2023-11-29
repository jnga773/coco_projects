%-------------------------------------------------------------------------%
%%                        Setup Lin's Method Data                        %%
%-------------------------------------------------------------------------%
% Calculate non-trivial steady states
[~, vu, vs] = unstable_stable_eigenvectors(p0);

% Parameters
p0_L = p0;

%----------------------------------%
%     Setup Lin's Method Stuff     %
%----------------------------------%
% Initial distances from the equilibria, along the tangent spaces of the
% unstable and stable manifolds, to the initial points along the corresponding
% trajectory segments.
eps1 = 0.1;
eps2 = 0.05;

% Initial distances from the equilibria, along the tangent spaces of the
% unstable and stable manifolds, to the initial points along the corresponding
% trajectory segments.
eps1 = 0.2;
eps2 = 0.2;

% Lin epsilons vector
epsilon0 = [eps1; eps2];

%--------------------------------------------%
%     Boundary Conditions data Structure     %
%--------------------------------------------%
% Add parameter names to data_bcs
data_bcs.pnames = pnames;

% Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
data_bcs.normal = [0, 1];
% Intersection point for hyperplane
data_bcs.pt0 = [0.5; 0.2];

% Store the stable and unstable equilibria points into data_bcs
data_bcs.equilib_pt = x0;

% Initial time
data_bcs.t0 = 0;
% Initial parameters
data_bcs.p0 = p0_L;

% Unstable Manifold: Initial point
data_bcs.x_init_u = x0' + eps1 * vu';
% Unstable Manifold: Final point
data_bcs.x_final_u = data_bcs.pt0;

% Stable Manifold: Initial point
data_bcs.x_init_s = x0' + eps2 * vs';
% Stable Manifold: Final point
data_bcs.x_final_s = data_bcs.pt0;
