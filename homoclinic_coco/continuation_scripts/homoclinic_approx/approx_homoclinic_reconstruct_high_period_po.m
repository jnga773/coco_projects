%-------------------------------------------------------------------------%
%%         Locate a High-Period Periodic Orbit from Previous Run         %%
%-------------------------------------------------------------------------%
% We approximate a homoclinic orbit by finding a periodic orbit that has a
% large period. The closer you are to an equilibrium point, the longer you
% spend then, and hence you have a super duper large period.

% We obtain an initial solution guess by extending the duration spent near
% an equilibrium point for a periodic orbit found in the previous run.
% The call to coco_xchg_pars constrains the interval length, while
% releasing the second problem parameter.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.approx_homo.high_period;
% Which run this continuation continues from
run_old = run_names.approx_homo.PO_from_hopf;

% Read solution of previous run with largest period.
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

% Print to console
fprintf('~~~ Approximate Homoclinic: Second Run (ode_isol2po) ~~~\n');
fprintf('Find reconstructed high-period periodic orbit approximating a homoclinic connection\n');
fprintf('Run name: %s\n', run_new);
fprintf('Continuing from point %d in run: %s\n', label_old, run_old);

%-------------------------------------%
%     Read Data from Previous Run     %
%-------------------------------------%
% Find minimum point corresponding to equilibrium point, and insert
% large time segment.
po_data = insert_large_time_segment(run_old, label_old);

%------------------------------------------%
%     Continuation from Periodic Orbit     %
%------------------------------------------%
% Continuation with a zero-dimensional atlas algorithm can now be
% used to locate a periodic orbit with period equal to its initial
% value, i.e., to [scale] times the largest period found in the previous
% run.

% Initialize continuation problem structure with the same number of
% intervals as in previous run.
prob = coco_prob();
prob = coco_set(prob, 'coll', 'NTST', po_data.NTST);

% Turn off bifucation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% The value of 10 for 'NAdapt' implied that the trajectory discretisation
% is changed adaptively ten times before the solution is accepted.
NAdapt = 20;
prob = coco_set(prob, 'cont', 'NAdapt', NAdapt);

% Continue periodic orbit from initial solution
prob = ode_isol2po(prob, 'homo', func_list{:}, ...
                   po_data.t_sol, po_data.x_sol, pnames, po_data.p0);

% Add instance of equilibrium point to find and follow the actual 
% equilibrium point
prob = ode_isol2ep(prob, 'x0', func_list{:}, ...
                   po_data.x0, po_data.p0);

% Glue parameters together
[data1, uidx1] = coco_get_func_data(prob, 'homo.po.orb.coll', 'data', 'uidx');
[data2, uidx2] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

prob = coco_add_glue(prob, 'shared_parameters', ...
                     uidx1(data1.coll_seg.maps.p_idx), uidx2(data2.ep_eqn.p_idx));


% Assign 'p2' to the set of active continuation parameters and 'po.period'
% to the set of inactive continuation parameters, thus ensuring that the
% latter is fixed during root finding.
prob = coco_xchg_pars(prob, 'p2', 'homo.po.period');

coco(prob, run_new, [], 0, {'p1', 'homo.po.orb.coll.err_TF', 'homo.po.period'});
