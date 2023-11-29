%-------------------------------------------------------------------------%
%%          Continuation from Hopf Bifurcation to Periodic Orbit         %%
%-------------------------------------------------------------------------%
% %------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.approx_homo.PO_from_hopf;
% Which run this continuation continues from
run_old = run_names.initial_run;

% Label for Hopf bifurcation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

% Print to console
fprintf('~~~ Approximate Homoclinic: First Run (ode_HB2po) ~~~\n');
fprintf('Continue periodic orbits from a Hopf bifurcation\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s\n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Set up COCO problem
prob = coco_prob();

% Turn off bifurcation detections
% prob = coco_set(prob, 'po', 'bifus', 'off');

% Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 5e-2);
% prob = coco_set(prob, 'cont', 'h0', 5e-2);
% prob = coco_set(prob, 'cont', 'h_max', 1e-1);

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 200;
% prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Continue from branching point
prob = ode_HB2po(prob, '', run_old, label_old);

% Run COCO continuation
coco(prob, run_new, [], 1, {'p1', 'po.period'}, p1_range);

%-------------------------------------------------------------------------%
%%                               Test Plot                               %%
%-------------------------------------------------------------------------%
% % Read solution of previous run with largest period, in this case LABEL=142
% label_max = coco_bd_labs(bd2, 'EP');
% label_max = max(label_max);

% % Grab the label of the run with the highest period
% label_max = coco_bd_labs(bd6, 'EP');
% label_max = max(label_max);

% % Grab the label where A_pump is the maximum
% [~, idx] = max(coco_bd_col(bd6, 'A_pump'));
% label_max = coco_bd_col(bd6, 'LAB');
% label_max = label_max(idx);

%{
% Quick test plot
plot_high_period_time;
% plot_2D_increasing_period;
plot_3D_increasing_period;
%}
