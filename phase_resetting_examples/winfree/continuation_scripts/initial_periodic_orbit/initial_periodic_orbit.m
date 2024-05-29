%-------------------------------------------------------------------------%
%%                      Compute Singlular Amplitude                      %%
%-------------------------------------------------------------------------%
% Using previous parameters and MATLAB's ode45 function, we solve for an
% initial solution to be fed in as a periodic orbit solution.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.initial_periodic_orbit;
% Which run this continuation continues from
run_old = run_names.initial_periodic_orbit_PO;

% Continuation point
label_old = 1;

% Print to console
fprintf("~~~ Initial Periodic Orbit: Second Run (initial_periodic_orbit.m) ~~~ \n");
fprintf('Find new periodic orbit \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Calculate Solution     %
%----------------------------%
% Calculate dem tings
data_soln = calculate_periodic_orbit(run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set tolerance
% prob = coco_set(prob, 'corr', 'TOL', 5e-7);

% Set NTST mesh
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdapt
prob = coco_set(prob, 'coll', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', 'off');

% Step PtMX steps
prob = coco_set(prob, 'cont', 'PtMX', 20);

% Set initial guess to 'coll'
prob = ode_isol2coll(prob, 'initial_PO', funcs.field{:}, ...
                     data_soln.t, data_soln.x, pnames, data_soln.p);

% Add equilibrium points for non trivial steady states
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

% Glue parameters
prob = glue_parameters(prob, bcs_funcs.bcs_PO);

% Set saved solution
prob = coco_add_event(prob, 'PO_PT', 'a', 0.0);

% Run COCO
coco(prob, run_new, [], 1, {'a', 'omega'});

%-------------------------------------------------------------------------%
%%                        TESTING PLOTS                                  %%
%-------------------------------------------------------------------------%
% Label for solution plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'PO_PT');
label_plot = label_plot(1);

% Plot solution
plot_test_PO(run_new, label_plot, save_figure);

% Save periodic orbit data to ./data/ to be used as base plots later on
save_initial_PO_data(run_new, label_plot);
plot_initial_periodic_orbit(save_figure);

%-------------------------------------------------------------------------%
%%                     CALCULATING STUFF FUNCTION LOL                    %%
%-------------------------------------------------------------------------%
function data_out = calculate_periodic_orbit(run_in, label_in)
  % data_out = calculate_periodic_orbit(run_in, label_in)
  %
  % Calculates initial periodic solution using ode45

  %------------------%
  %     Read Data    %
  %------------------%
  % Read previous solution
  [sol, ~] = po_read_solution('', run_in, label_in);

  % Initial period
  T_sol    = sol.T;
  % Parameters
  p_sol    = sol.p;
  % Read time data
  tbp      = sol.tbp;
  % Read state space solution
  xbp_read = sol.xbp;

  %----------------------------%
  %     Calculate Solution     %
  %----------------------------%
  % Need to find the point where e1 . F(x(t)) = 0, that is
  % the maximum of the first component.
  [~, max_idx] = max(xbp_read(:, 1));

  % Shift everything around
  if max_idx > 1
    x0 = [xbp_read(max_idx:end, :); xbp_read(2:max_idx, :)];
    t0 = [tbp(max_idx:end) - tbp(max_idx); tbp(2:max_idx) + (tbp(end) - tbp(max_idx))];
  end

  %----------------%
  %     Output     %
  %----------------%
  data_out.p      = p_sol;
  data_out.t      = t0;
  data_out.x      = x0;

end

function prob_out = glue_parameters(prob_in, bcs_PO_in)
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
  % Read index data for periodic orbit segment
  [data, uidx] = coco_get_func_data(prob, 'initial_PO.coll', 'data', 'uidx');

  % Read index data for equilibrium points
  [data1, uidx1] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');

  % Index mapping
  maps     = data.coll_seg.maps;
  maps1    = data1.ep_eqn;

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Apply periodic orbit boundary conditions and special phase condition
  prob = coco_add_func(prob, 'bcs_po', bcs_PO_in{:}, data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(1:data.xdim); ...
                             maps.x1_idx(1:data.xdim); ...
                             maps.p_idx(1:data.pdim)]));

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx), uidx1(maps1.p_idx));

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end

function save_initial_PO_data(run_in, label_in)
  % save_initial_PO_data(run_in, label_in)
  %
  % Reads periodic orbit solution data from COCO solution, calculates the
  % one-dimensional stable manifold of the "central" saddle point 'q', and
  % saves the data to './data/initial_PO.mat'.

  % Data matrix filename
  filename_out = './data/initial_PO.mat';

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Periodic orbit solution
  sol_PO = coll_read_solution('initial_PO', run_in, label_in);
  xbp_PO = sol_PO.xbp;
  p_PO   = sol_PO.p;

  % Equilibrium point solutions
  sol_0  = ep_read_solution('x0', run_in, label_in);
  x0     = sol_0.x;

  %-------------------%
  %     Save Data     %
  %-------------------%
  save(filename_out, 'x0', 'xbp_PO', 'p_PO');

end