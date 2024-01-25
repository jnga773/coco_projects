%-------------------------------------------------------------------------%
%%               Solving for periodic solutions using ode45              %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.initial_PO;

% Print to console
fprintf('~~~ First Run (ode_isol2po) ~~~\n');
fprintf('Solve for initial solution of periodic orbits with PO toolbox\n');
fprintf('Run name: %s\n', run_new);

%------------------------------------%
%     Calculate Initial Solution     %
%------------------------------------%
data_isol = calculate_initial_PO(p0);

%---------------------------------------------%
%     Initial Periodic Orbit Continuation     %
%---------------------------------------------%
% Set up the COCO problem
prob = coco_prob();

% % The value of 10 for 'NAdapt' implied that the trajectory discretisation
% % is changed adaptively ten times before the solution is accepted.
prob = coco_set(prob, 'coll', 'NTST', 25);
% prob = coco_set(prob, 'cont', 'NAdapt', 10);

% Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Continue periodic orbit from initial solution
% prob = ode_isol2po(prob, 'winfree', func_list{:}, ...
%                    data_isol.t, data_isol.x, pnames, data_isol.p);
prob = ode_isol2po(prob, 'winfree_PO', func_list{:}, ...
                   data_isol.t, data_isol.x, pnames, data_isol.p, ...
                   '-var', eye(2));

% Set variational problem to true
prob = coco_set(prob, 'po', 'var', true);

% Hold the initial condition of solution to variational problem fixed
% Read data and uidx indices
[data, uidx] = coco_get_func_data(prob, 'winfree_PO.po.orb.coll.var', 'data', 'uidx');
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars_var', ...
                     uidx(data.coll_var.v0_idx,:), ...
                     {'s1', 's2', ...
                      's3', 's4'});

coco(prob, run_new, [], 1, {'a', 'omega'}, [-2.0, 2.0]);

%-------------------------------------------------------------------------%
%%                             Testing Stuff                             %%
%-------------------------------------------------------------------------%
%--------------------------------%
%     Read Data and Solution     %
%--------------------------------%
% Find good label to plot
label_plot = 1;

% % Read one of the solutions
chart = coco_read_solution('winfree_PO.po.orb.coll.var', run_new, label_plot, 'chart');
data  = coco_read_solution('winfree_PO.po.orb.coll', run_new, label_plot, 'data');

% Create monodrony matrix
M1 = chart.x(data.coll_var.v1_idx);

fprintf('~~~ Monodromy Matrix ~~~\n');
fprintf('(%.7f, %.7f)\n', M1(1, :));
fprintf('(%.7f, %.7f)\n', M1(2, :));

%------------------------------------------------%
%     Calculate Eigenvalues and Eigenvectors     %
%------------------------------------------------%
% Calculate eigenvalues and eigenvectors
[eigvecs, eigvals] = eig(M1);

% Eigen 1
vec1 = eigvecs(:, 1);
val1 = eigvals(1, 1);
fprintf('vec1  = (%f, %f) \n', vec1);
fprintf('val1  = %f \n\n', val1);

% Eigen 2
vec2 = eigvecs(:, 2);
val2 = eigvals(2, 2);
fprintf('vec2  = (%f, %f) \n', vec2);
fprintf('val2  = %f \n\n', val2);

%-------------------%
%     Test Plot     %
%-------------------%
% plot_test_PO(run_new, label_plot);

%-------------------------------------------------------------------------%
%%                     CALCULATING STUFF FUNCTION LOL                    %%
%-------------------------------------------------------------------------%
function data_out = calculate_initial_PO(param_in)
  % data_out = calculate_initial_PO()
  %
  % Calculates the initial periodic orbit using MATLAB's built-in
  % ode45 to time-integrate a solution.

  %--------------------%
  %     Parameters     %
  %--------------------%
  p0_PO = param_in;

  % Outer (stable) periodic orbit initial vector
  x0_PO =[1.5, 0.0];
  t_PO_max = 2 * pi;

  % Time max
  t_long_max = 500;

  %-------------------------%
  %     Calculate Stuff     %
  %-------------------------%
  % Time arrays
  % t_long = 0.0:0.001:t_long_max;
  t_PO = 0.0:0.001:t_PO_max;

  % Evolve the state to an "steady state" to find oscillating periodic orbit
  % Solve using ode45 to long-time-limit
  [~, x_long] = ode45(@(t, x) winfree(x, p0_PO), [0, t_long_max], x0_PO);

  % Use the final solution from this run ^ as initial condition here
  [~, x_PO] = ode45(@(t, x) winfree(x, p0_PO), t_PO, x_long(end, :)');

  %----------------%
  %     Output     %
  %----------------%
  data_out.t = t_PO;
  data_out.x = x_PO;
  data_out.p = p0_PO;

end
