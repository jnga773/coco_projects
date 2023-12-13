%-------------------------------------%
%     Parameters for Lin's Method     %
%-------------------------------------%
% Set parameters to be on homoclinic line
p1 = 1.0; % CHANGE THIS!!!!!
p2 = 2.0; % CHANGE THIS!!!!!

% Set new parameter vector
data_bcs.p0 = [p1; p2]; % CHANGE THIS!!!!!

data_bcs.equilib_pt = [x1_ss, x2_ss, x3_ss]; % CHANGE THIS!!!!!

% Calculate non-trivial steady states
% DEFINE THIS FUNCTION
[vu, vs1, vs2] = unstable_stable_eigenvectors(data_bcs.equilib_pt, data_bcs.p0);

%----------------------------------%
%     Setup Lin's Method Stuff     %
%----------------------------------%
% Initial distances from the equilibria, along the tangent spaces of the
% unstable and stable manifolds, to the initial points along the corresponding
% trajectory segments.
eps1 = -0.1; % CHANGE THIS!!!!!
eps2 = 0.1;  % CHANGE THIS!!!!!

% Angle for stable vector component
theta0 = 0.5 * pi; % CHANGE THIS!!!!!

% Lin epsilons vector
epsilon0 = [eps1; eps2; theta0];

%--------------------------------------------%
%     Boundary Conditions data Structure     %
%--------------------------------------------%
% Add parameter names to data_bcs
data_bcs.pnames = pnames;

% Normal vector to hyperplane \Sigma (just the y-axis at x=0.5)
data_bcs.normal = [0, 0, 1];  % CHANGE THIS!!!!!

% Intersection point for hyperplane
data_bcs.pt0 = [0.0; 0.44; 0.1]; % CHANGE THIS!!!!!

% Initial time
data_bcs.t0 = 0;

% Unstable Manifold: Initial point
data_bcs.x_init_u = data_bcs.equilib_pt' + eps1 * vu'; % CHANGE THIS!!!!!

% Stable Manifold: Initial point
data_bcs.x_init_s = data_bcs.equilib_pt' + eps2 * (cos(theta0) * vs1' + sin(theta0) * vs2'); % CHANGE THIS!!!!!
