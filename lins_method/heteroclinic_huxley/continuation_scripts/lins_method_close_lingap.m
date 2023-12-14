%-------------------------------------------------------------------------%
%%                           Close the Lin Gap                           %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.close_lingap;
% Which run this continuation continues from
run_old = run_names.stable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelS');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Third Run (ode_coll2coll) ~~~ \n");
fprintf('Close the Lin Gap on the Sigma Plane \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Set PtMX steps
PtMX = 200;
% prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct first instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);

% Extract stored deviations of heteroclinic trajectory end points from corresponding equilibria
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = glue_conditions(prob, data_bcs, epsilon);  

% Calculate Lin gap vector and initial value of lingap
data_lins = find_lingap_vector(run_old, label_old);
lingap = data_lins.lingap0;

% Apply Lin's conditions
prob = glue_lingap_conditions(prob, data_lins, lingap);

% Run COCO
% Free parameters: lingap - The distance between final point of unstable trajectory
%                           and initial point of stable trajectory.
%                  T1     - Period for unstable segment to reach \Sigma plane.
%                  T2     - Period for stable segment to reach \Sigma plane.
%                  seg_s  - Distance of initial point of stable trajectory
%                           to point on \Sigma plane.
%                  p1     - System parameter.

coco(prob, run_new, [], 1, {'lingap', 'T1', 'T2', 'seg_s', 'p1'}, [0, lingap]);
% coco(prob, run_new, [], 1, {'lingap', 'T1', 'T2', 'p1', 'seg_s'});

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% Find good label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
label_plot = label_plot(1);

%--------------%
%     Plot     %
%--------------%
plot_run_i(run_new, label_plot, 5, p0, save_figure);

%--------------------------%
%     Print to Console     %
%--------------------------%
[sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
[sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% 
% fprintf('Print Start and End Points to Console\n');
fprintf('Unstable starting point = (%.3f, %.3f)\n', sol1.xbp(1, :));
fprintf('Unstable ending point   = (%.3f, %.3f)\n', sol1.xbp(end, :));
fprintf('Stable starting point   = (%.3f, %.3f)\n', sol2.xbp(1, :));
fprintf('Stable ending point     = (%.3f, %.3f)\n', sol2.xbp(end, :));
