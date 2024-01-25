%-------------------------------------------------------------------------%
%%               Solving for periodic solutions using ode45              %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.initial_coll;
% Which run this continuation continues from
run_old = run_names.initial_PO;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = 1;

% Print to console
fprintf("~~~ Second Run (ode_isol2coll) ~~~ \n");
fprintf('Solve for initial solution of periodic orbits with PO toolbox\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%------------------------------------%
%     Calculate Initial Solution     %
%------------------------------------%
data_isol = calculate_initial_COLL(run_old, label_old);

%---------------------------------------------%
%     Initial Periodic Orbit Continuation     %
%---------------------------------------------%
% Set up the COCO problem
prob = coco_prob();

% % The value of 10 for 'NAdapt' implied that the trajectory discretisation
% % is changed adaptively ten times before the solution is accepted.
prob = coco_set(prob, 'coll', 'NTST', 25);
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off bifurcation detections
% prob = coco_set(prob, 'po', 'bifus', 'off');

% Set tolerance
% prob = coco_set(prob, 'corr', 'TOL', 5e-1);

% Turn off MXCL?
% prob = coco_set(prob, 'coll', 'MXCL', false);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Continue periodic orbit from initial solution
% prob = ode_isol2coll(prob, 'winfree', func_list{:}, ...
%                      data_isol.t, data_isol.x, pnames, data_isol.p);
prob = ode_isol2coll(prob, 'initial_PO', func_list{:}, ...
                     data_isol.t, data_isol.x, pnames, data_isol.p, ...
                     '-var', eye(2));

% Hold the initial condition of solution to variational problem fixed
% Read data and uidx indices
[data, uidx] = coco_get_func_data(prob, 'initial_PO.coll.var', 'data', 'uidx');
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars_var', ...
                     uidx(data.coll_var.v0_idx,:), ...
                     {'s1', 's2', ...
                      's3', 's4'});

% Set periodic orbit boundary conditions
[data, uidx] = coco_get_func_data(prob, 'initial_PO.coll', 'data', 'uidx');
maps = data.coll_seg.maps;

% Apply periodic orbit boundary conditions and special phase condition
prob = coco_add_func(prob, 'bcs_po', @bcs_PO, data, 'zero', 'uidx', ...
                     uidx([maps.x0_idx; ...
                           maps.x1_idx; ...
                           maps.p_idx]));

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
chart = coco_read_solution('initial_PO.coll.var', run_new, label_plot, 'chart');
data  = coco_read_solution('initial_PO.coll', run_new, label_plot, 'data');

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
plot_test_PO(run_new, label_plot);

%-------------------------------------------------------------------------%
%%                     CALCULATING STUFF FUNCTION LOL                    %%
%-------------------------------------------------------------------------%
function data_out = calculate_initial_COLL(run_in, label_in)
  % data_out = calculate_initial_PO()
  %
  % Calculates the initial periodic orbit using MATLAB's built-in
  % ode45 to time-integrate a solution.

  %-------------------%
  %     Read Data     %
  %-------------------%
  [sol, data] = po_read_solution('winfree_PO', run_in, label_in);

  % State space solution
  xbp_read = sol.xbp;
  % Time solution
  tbp      = sol.tbp;
  % Period
  T        = sol.T;
  % Parameters
  p0       = sol.p;

  %-------------------------%
  %     Calculate Stuff     %
  %-------------------------%
  % Need to find the point where e1 . F(x(t)) = 0, that is
  % the maximum of the first component.
  [~, max_idx] = max(xbp_read(:, 1));

  % Shift everything around
  if max_idx > 1
    % x_first = x(max_idx:end, :);
    % x_second = x(2:max_idx, :);
    % x_out = [x_first; x_second];
    x_out = [xbp_read(max_idx:end, :); xbp_read(2:max_idx, :)];
  end

  %----------------%
  %     Output     %
  %----------------%
  data_out.t = tbp;
  data_out.T = T;
  data_out.x = x_out;
  data_out.p = p0;

end
