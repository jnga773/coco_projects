%-------------------------------------%
%     Parameters for Lin's Method     %
%-------------------------------------%
% Run name of approx
data_bcs.label_approx = 1;
% data_bcs.label_approx = 17;

% Read solution
[data_bcs.p0, ~, data_bcs.equilib_pt] = read_approximate_homoclinic_solution(data_bcs.label_approx);

% Set parameters to be on homoclinic line
% p1 = -0.013159568088531;
% p2 = 6.002641613709677;

% Set new parameter vector
% data_bcs.p0 = [p1; p2];
% 
% data_bcs.equilib_pt = [-0.25; -0.37; 0.68];

% Calculate non-trivial steady states
[vu, vs1, vs2] = unstable_stable_eigenvectors(data_bcs.equilib_pt, data_bcs.p0);

%----------------------------------%
%     Setup Lin's Method Stuff     %
%----------------------------------%
% Initial distances from the equilibria, along the tangent spaces of the
% unstable and stable manifolds, to the initial points along the corresponding
% trajectory segments.
eps1 = -0.1;
eps2 = 0.1;

% Angle for stable vector component
theta0 = 0.5 * pi;
% theta0 = pi/3;
% theta0 = pi/2;
% theta0 = 0.5 * pi;
% theta0 = 4 * pi / 10;
% theta0 = 8 * 2 * pi / 50;

% Lin epsilons vector
epsilon0 = [eps1; eps2; theta0];

%--------------------------------------------%
%     Boundary Conditions data Structure     %
%--------------------------------------------%
% Add parameter names to data_bcs
data_bcs.pnames = pnames;

% Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
data_bcs.normal = [0, 0, 1];
% Intersection point for hyperplane
data_bcs.pt0 = [0.0; 0.44; 0.1];

% Initial time
data_bcs.t0 = 0;

% Unstable Manifold: Initial point
data_bcs.x_init_u = data_bcs.equilib_pt' + eps1 * vu';
% Unstable Manifold: Final point
data_bcs.x_final_u = data_bcs.pt0;

% Stable Manifold: Initial point
data_bcs.x_init_s = data_bcs.equilib_pt' + eps2 * (cos(theta0) * vs1' + sin(theta0) * vs2');
% Stable Manifold: Final point
data_bcs.x_final_s = data_bcs.pt0;

% Plot "approximate" homoclinic with steady and unsteady eiegenvectors
plot_homoclinic_manifolds(20, data_bcs.label_approx);
