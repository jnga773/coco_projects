%-------------------------------------------------------------------------%
%%                        Hopf to Periodic Orbit                         %%
%-------------------------------------------------------------------------%
% Continue a family of periodic orbits emanating from the Hopf
% bifurcation with 'ode_HB2po'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.hopf_to_PO;
% Which run this continuation continues from
run_old = run_names.follow_hopf_z;

% Continuation point
% label_old = sort(coco_bd_labs(coco_bd_read(run_old), 'HB'));
% label_old = label_old(3);
label_old = coco_bd_labs(coco_bd_read(run_old), 'H_PT');

% Print to console
fprintf("~~~ Initial Periodic Orbit: fourth Run (hopf_to_PO.m) ~~~ \n");
fprintf('Periodic orbits from Hopf bifurcation \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------%
%     Calculate Things     %
%--------------------------%
% Read previous solution
sol = ep_read_solution('', run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set NTST mesh 
prob = coco_set(prob, 'coll', 'NTST', 60);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set PtMX steps
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Set frequency of saved solutions
prob = coco_set(prob, 'cont', 'NPR', 10);

% Continue from Hopf bifurcation
prob = ode_HB2po(prob, '', run_old, label_old);

% Follow non trivial solutions
prob = ode_isol2ep(prob, 'x0',   funcs.field{:}, ...
                   x0, sol.p);

% Glue parameters
prob = glue_parameters(prob);

% Add saved point for periodic orbit calculation
prob = coco_add_event(prob, 'PO_PT', 'c', 1.0);

% Run COCO
bd_PO = coco(prob, run_new, [], 1, {'c', 'z'}, [0.0, 2.0]);

%-------------------------------------------------------------------------%
%%                            Testing Things                             %%
%-------------------------------------------------------------------------%
% Solution to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'PO_PT'));
label_plot = label_plot(1);

% Create plots
plot_hopf_to_PO_solution(run_new, label_plot);

%-------------------------------------------------------------------------%
%%                               FUNCTIONS                               %%
%-------------------------------------------------------------------------%
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
