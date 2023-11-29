%-------------------------------------------------------------------------%
%%              Reconstruct an Approximate Homoclinic Loop               %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.approx_homo.continue_homoclinics;
% Which run this continuation continues from
run_old = run_names.approx_homo.high_period;

% Grab the label for the previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

% Print to console
fprintf('~~~ Approximate Homoclinic: Third Run (ode_po2po) ~~~\n');
fprintf('Continue family of periodic orbits approximating homoclinics\n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s\n', label_old, run_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Continue a periodic orbit from a previous periodic orbit
prob = ode_po2po(prob, '', run_old, label_old);

% Assign 'p2' to the set of active continuation parameters and 'po.period'
% to the set of inactive continuation parameters, thus ensuring that the
% latter is fixed during root finding.
prob = coco_xchg_pars(prob, 'p2', 'po.period');
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set number of continuation steps
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Run continuation
coco(prob, run_new, [], 1, {'p1', 'p2', 'po.period'}, p_range);
