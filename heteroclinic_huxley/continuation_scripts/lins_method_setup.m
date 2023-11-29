%-------------------------------------------------------------------------%
%%                          Setup Lin's Method                           %%
%-------------------------------------------------------------------------%
%-------------------------------------%
%     Parameters for Lin's Method     %
%-------------------------------------%
% Parameter vector
p0 = [p1; p2];

% Equilibria points
x0_u = [0; 0];
x0_s = [1.0; 0.0];

% Unstale and stable eigevectors from Jacobian
% [vu, vec_stavsble] = find_jacobian_eigenvectors(x0_1, p0);
[vu, vs] = unstable_stable_eigenvectors(p0);

% Plot the state-space diagram without continuation
% plot_state_space(p0);

%----------------------------------%
%     Setup Lin's Method Stuff     %
%----------------------------------%
% Initial distances from the equilibria, along the tangent spaces of the
% unstable and stable manifolds, to the initial points along the corresponding
% trajectory segments.
eps1 = 0.1;
eps2 = 0.05;

% Lin epsilons vector
epsilon0 = [eps1; eps2];

%--------------------------------------------%
%     Boundary Conditions data Structure     %
%--------------------------------------------%
% Add parameter names to data_bcs
data_bcs.pnames = pnames;

% Store the stable and unstable equilibria points into data_bcs
data_bcs.unstable_equilib_pt = x0_u;
data_bcs.stable_equilib_pt   = x0_s;

% Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
data_bcs.normal = [1, 0];
% Intersection point for hyperplane
% data_bcs.pt0 = [0.5; 0.17668];
data_bcs.pt0 = [0.6; 0.175];

% Initial time
data_bcs.t0 = 0;
% Initial parameters
data_bcs.p0 = p0;

% Unstable Manifold: Initial point
data_bcs.x_init_u = x0_u' + eps1 * vu';
% Unstable Manifold: Final point
data_bcs.x_final_u = data_bcs.pt0;

% Stable Manifold: Initial point
data_bcs.x_init_s = x0_s' + eps2 * vs';
% Stable Manifold: Final point
data_bcs.x_final_s = data_bcs.pt0;
