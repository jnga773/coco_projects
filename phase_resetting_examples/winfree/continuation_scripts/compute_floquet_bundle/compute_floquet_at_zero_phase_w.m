%-------------------------------------------------------------------------%
%%          Compute Floquet Bundle at Zero Phase Point (w_norm)          %%
%-------------------------------------------------------------------------%
% Having found the solution (branching point 'BP') corresponding to
% \mu = 1, we can continue in the norm of the vector w (w_norm), until the
% norm is equal to zero. Then we will have the correct perpendicular
% vector.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.compute_floquet_2;
% Which run this continuation continues from
run_old = run_names.compute_floquet_1;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'BP');
label_old = label_old(1);

% Print to console
fprintf("~~~ Third Run (ode_BP2bvp) ~~~ \n");
fprintf('Calculate Floquet bundle (w_norm) \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%------------------------------------%
%     Setup Floquet Continuation     %
%------------------------------------%
% Set up the COCO problem
prob = coco_prob();

% % % Continue bvp from previous branching point
% % prob = ode_BP2bvp(prob, '', run_old, label_old);


% Continue coll from previous branching point
prob = ode_BP2coll(prob, 'adjoint', run_old, label_old);

% Read function data and u-vector indices
[data, uidx] = coco_get_func_data(prob, 'adjoint.coll', 'data', 'uidx');
maps = data.coll_seg.maps;

% Apply periodic orbit boundary conditions
prob = coco_add_func(prob, 'bcs_po', @bcs_PO, data, 'zero', 'uidx', ...
                     uidx([maps.x0_idx(1:2); ...
                           maps.x1_idx(1:2); ...
                           maps.p_idx(1:2)]));

% Apply adjoing boundary conditions
prob = coco_add_func(prob, 'bcs_adjoint', @bcs_floquet, data, 'zero', 'uidx', ...
                     uidx([maps.x0_idx(3:4); ...
                           maps.x1_idx(3:4); ...
                           maps.p_idx(3:4)]));
% Run COCO
coco(prob, run_new, [], 1, {'w_norm', 'mu_f'} , [0, 1.0]);
