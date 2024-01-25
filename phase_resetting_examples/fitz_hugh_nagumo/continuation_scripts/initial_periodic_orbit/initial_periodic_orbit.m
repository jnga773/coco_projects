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
run_old = run_names.hopf_to_PO;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'c=1');
label_old = label_old(1);

% Print to console
fprintf("~~~ Fifth Run (ode_isol2coll) ~~~ \n");
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
prob = coco_set(prob, 'corr', 'TOL', 5e-7);
% Set NTST
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set initial guess to 'coll'
prob = ode_isol2coll(prob, 'initial_PO', func_list{:}, ...
                     data_soln.t, data_soln.x, pnames, data_soln.p);

% Set periodic orbit boundary conditions
[data, uidx] = coco_get_func_data(prob, 'initial_PO.coll', 'data', 'uidx');
maps = data.coll_seg.maps;

% Apply periodic orbit boundary conditions and special phase condition
prob = coco_add_func(prob, 'bcs_po', @bcs_PO, data, 'zero', 'uidx', ...
                     uidx([maps.x0_idx; ...
                           maps.x1_idx; ...
                           maps.p_idx]));

% Run COCO
coco(prob, run_new, [], 1, 'c', [0.99, 1.01]);

%-------------------------------------------------------------------------%
%%                        TESTING PLOTS                                  %%
%-------------------------------------------------------------------------%
% Label for solution plot
label_plot = 1;

% Plot solution
plot_initial_periodic_orbit(run_new, label_plot);
