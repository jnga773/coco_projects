%-------------------------------------------------------------------------%
%%                 Periodic Orbit from Hopf Bifurcation                  %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.hopf_bifurcation;
% Which run this continuation continues from
run_old = run_names.branching_point;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

% Print to console
fprintf('~~~ Periodic Orbits from Hopf (ode_HB2po) ~~~\n');
fprintf('Continue periodic orbits originating from Hopf bifurcation\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Set up COCO problem
prob = coco_prob();

% Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 0.5);
prob = coco_set(prob, 'cont', 'h0', 0.1);
prob = coco_set(prob, 'cont', 'h_max', 0.1);

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set 'var' (whatever that is) to true
prob = coco_set(prob, 'cont', 'var', true);
prob = coco_set(prob, 'coll', 'var', true);
prob = coco_set(prob, 'po', 'var', true);

% Prob set NTST
prob = coco_set(prob, 'cont', 'NTST', 50);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Continue from branching point
prob = ode_HB2po(prob, 'hopf_po', run_old, label_old, '-var', eye(3));

% Hold the initial condition of solution to variational problem fixed
% Read data and uidx indices
[data, uidx] = coco_get_func_data(prob, 'hopf_po.po.orb.coll.var', 'data', 'uidx');
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars', ...
                     uidx(data.coll_var.v0_idx,:), ...
                     {'s1', 's2', 's3', ...
                      's4', 's5', 's6', ...
                      's7', 's8', 's9'});

% Run COCO continuation
coco(prob, run_new, [], 1, 'r', [24, 25]);

%-------------------------------------------------------------------------%
%%                             Testing Stuff                             %%
%-------------------------------------------------------------------------%
%--------------------------------%
%     Read Data and Solution     %
%--------------------------------%
% Find good label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EP');
label_plot = sort(label_plot);
label_plot = label_plot(2);

% Read one of the solutions
chart = coco_read_solution('hopf_po.po.orb.coll.var', run_new, label_plot, 'chart');
data  = coco_read_solution('hopf_po.po.orb.coll', run_new, label_plot, 'data');

% Create monodrony matrix
M1 = chart.x(data.coll_var.v1_idx);

fprintf('~~~ Monodromy Matrix ~~~\n');
fprintf('(%.7f, %.7f, %.7f)\n', M1(1, :));
fprintf('(%.7f, %.7f, %.7f)\n', M1(2, :));
fprintf('(%.7f, %.7f, %.7f)\n\n', M1(3, :));

%------------------------------------------------%
%     Calculate Eigenvalues and Eigenvectors     %
%------------------------------------------------%
% Calculate eigenvalues and eigenvectors
[v, d] = eig(M1);

% Find index for stable eigenvector? < 1
ind = find(abs(diag(d)) < 1);

% Stable eigenvector
vec0 = -v(:, ind);
% Stable eigenvalue (Floquet thingie)
lam0 = d(ind, ind);

% Do all the same but with the function I defined
% [vec0, lam0] = calculate_stable_floquet(run_new, label_plot);

fprintf('\n~~~ Eigenvector and Eigenvalue ~~~\n');
fprintf('vec0 (numeric)  = (%f, %f, %f) \n', vec0);
fprintf('lam0 (numeric)  = %s \n\n', lam0);
