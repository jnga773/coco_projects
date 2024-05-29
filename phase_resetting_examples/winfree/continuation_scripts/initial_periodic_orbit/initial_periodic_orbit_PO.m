%-------------------------------------------------------------------------%
%%               Solving for periodic solutions using ode45              %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.initial_periodic_orbit_PO;

% Print to console
fprintf("~~~ Initial Periodic Orbit: First Run (initial_periodic_orbit_PO.m) ~~~ \n");
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
prob = coco_set(prob, 'coll', 'NTST', 30);

% Set adaptive t mesh
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set upper bound of continuation steps in each direction along solution
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Continue periodic orbit from initial solution
prob = ode_isol2po(prob, '', funcs.field{:}, ...
                   data_isol.t, data_isol.x, pnames, data_isol.p);

% Add segment for EP continuations
prob = ode_isol2ep(prob, 'x0', funcs.field{1}, ...
                   [0.0; 0.0], data_isol.p);

% Glue parameters
prob = glue_parameters(prob);

% Set saved solution
prob = coco_add_event(prob, 'PO_PT', 'a', 0.0);

% Run continuation
coco(prob, run_new, [], 1, {'a', 'omega'}, [-2.0, 2.0]);

%-------------------------------------------------------------------------%
%%                             Testing Stuff                             %%
%-------------------------------------------------------------------------%
% Label for solution plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'PO_PT');
label_plot = label_plot(1);

% Test plot
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

function prob_out = glue_parameters(prob_in)
  % prob_out = glue_parameter(prob_in)
  %
  % Glue the parameters of the EP segments and PO segment together 
  % (as they're all the same anyway)

  %---------------%
  %     Input     %
  %---------------%
  % Input continuation problem structure
  prob = prob_in;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read index data periodic orbit segment
  [data, uidx] = coco_get_func_data(prob, 'po.orb.coll', 'data', 'uidx');

  % Read index data equilibrium points
  [data1, uidx1] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

  % Index mapping
  maps = data.coll_seg.maps;
  % maps_var = data_var.coll_var;
  maps1 = data1.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx), uidx1(maps1.p_idx));

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end