%-------------------------------------------------------------------------%
%%                Test Run Continuing Stable Floquet Stuff               %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.test_run;
% Which run this continuation continues from
run_old = run_names.initial_run;

% Continuation point
label_old = 1;

% Print to console
fprintf("~~~ Second Run (ode_po2po) ~~~ \n");
fprintf('Test run to continue periodic orbit and follow Floquet bundle \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%-----------------------------------%
%     Calculate Floquet vectors     %
%-----------------------------------%
[vec_s, val_s] = calc_stable_floquet(run_old, label_old);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% % Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Prob set NTST
% prob = coco_set(prob, 'cont', 'NTST', 50);

% Set NPR to save every 50 steps
% prob = coco_set(prob, 'cont', 'NPR', 50);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct instance of 'po' toolbox for periodic orbit continuing from
% previous solution
prob = ode_po2po(prob, 'winfree', run_old, label_old, '-var', eye(2));

%----------------------------------------%
%     Eigenvalue Boundary Conditions     %
%----------------------------------------%
% Data and index array for periodic orbit segment
[data_p, uidx_p] = coco_get_func_data(prob, 'winfree.po.orb.coll', 'data', 'uidx');
% Data and index array for fundamental solution associated with orbit
[data_f, uidx_f] = coco_get_func_data(prob, 'winfree.po.orb.coll.var', 'data', 'uidx');

% Grab the indices from the data sections
maps_p = data_p.coll_seg.maps;
maps_f = data_f.coll_var;

% Apply the boundary conditions for the eigenvalues and eigenvectors of the
% monodromy matrix
prob = coco_add_func(prob, 'bcs_eigen', @boundary_conditions_eig, data_f, ...
                    'zero', 'uidx', ...
                    [uidx_f(maps_f.v1_idx(:, 1)); ...
                     uidx_f(maps_f.v1_idx(:, 2))], ...
                    'u0', [vec_s; val_s]);

% Get u-vector indices from this coco_add_func call, including the extra
% indices from the added "vec_floquet" and "lam_floquet".
uidx_eig = coco_get_func_data(prob, 'bcs_eigen', 'uidx');

% Grab eigenvector and value indices from u-vector [vec_floquet, lam_floquet]
data_out.vec_floquet_idx = uidx_eig(end-2:end-1);
data_out.lam_floquet_idx = uidx_eig(end);

%------------------------%
%     Add Parameters     %
%------------------------%
% Add parameters for each component of the monodromy matrix
prob = coco_add_pars(prob, 'pars', ...
                     uidx_f(maps_f.v0_idx,:), ...
                     {'s1', 's2'; ...
                      's3', 's4'});

% Define active parameters for stable Floquet
prob = coco_add_pars(prob, 'par_floquet_eig', ...
                     [data_out.vec_floquet_idx; data_out.lam_floquet_idx], ...
                     {'floquet_vec1', 'floquet_vec2', 'floquet_lam'}, ...
                     'active');

% Save data structure to be called later with coco_get_func_data 
prob = coco_add_slot(prob, 'apply_bcs', @coco_save_data, data_out, 'save_full');

%------------------%
%     Run COCO     %
%------------------%
bdtest = coco(prob, run_new, [], 1, {'a', 'omega'}, [-2.0, 2.0]);

%-------------------------------------------------------------------------%
%%                             Testing Stuff                             %%
%-------------------------------------------------------------------------%
%--------------------------------%
%     Read Data and Solution     %
%--------------------------------%
% Find good label to plot
label_plot = 1;

% Grab Floquet vector, value, and the initial epsilon parameters
[data, chart] = coco_read_solution('apply_bcs', run_new, label_plot);
vec0 = chart.x(data.vec_floquet_idx);
lam0 = chart.x(data.lam_floquet_idx);

%-------------------------------------------------------------------------%
%%                     CALCULATING STUFF FUNCTION LOL                    %%
%-------------------------------------------------------------------------%
