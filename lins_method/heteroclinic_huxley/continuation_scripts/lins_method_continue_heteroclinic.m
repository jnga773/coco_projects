%-------------------------------------------------------------------------%
%%                     Parametrise the Heteroclinic                      %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.continue_heteroclinic;
% Which run this continuation continues from
run_old = run_names.close_eps2;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS2');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Sixth Run (ode_coll2coll) ~~~ \n");
fprintf('Continue constrained segments to find parametrisation of homoclinic \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Set step sizes
h = 1e-2;
prob = coco_set(prob, 'cont', 'h_min', h);
prob = coco_set(prob, 'cont', 'h'    , h);
prob = coco_set(prob, 'cont', 'h_max', h);

% Set upper bound of continuation steps in each direction along solution
PtMX = 300;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Extract stored deviations of heteroclinic trajectory end points from corresponding equilibria
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = glue_conditions(prob, data_bcs, epsilon);            

% Read Linsgap data structure
data_lins = coco_read_solution('lins_data', run_old, label_old);

% Extract stored lingap value from previous run
[data, chart] = coco_read_solution('bcs_lingap', run_old, label_old);
lingap = chart.x(data.lingap_idx);

% Apply Lin's conditions
prob = glue_lingap_conditions(prob, data_lins, lingap);

% Run COCO
% Free parameters: p1    - System parameter.
%                  p2    - System parameter.
%                  T1    - Period for unstable segment to reach \Sigma plane.
%                  T2    - Period for stable segment to reach \Sigma plane.
%                  seg_u - Distance of final point of unstable trajectory
%                          to point on \Sigma plane.

coco(prob, run_new, [], 1, {'p1', 'p2', 'T1', 'T2', 'seg_u'});
% coco(prob, run_new, [], 1, {'p1', 'p2'}, [0.25 0.75]);
