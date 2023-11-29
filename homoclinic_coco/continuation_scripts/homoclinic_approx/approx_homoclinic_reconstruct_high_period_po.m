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

% Read solution with maximum period
[sol, data] = coll_read_solution('po.orb', run_old, label_old);

% Evaluate vector field at basepoints
f = marsden(sol.xbp', repmat(sol.p, [1, size(sol.xbp, 1)]));

% Extract the discretisation points corresponding to the minimum value of
% the norm of the vector field along the longest-period periodic orbit.
% Find basepoint closest to equilibrium
f_norm = sqrt(sum(f .* f, 1)); f_norm = f_norm';
[~, idx] = min(f_norm);
fprintf('\n');
fprintf('idx = %d \n', idx);

% Then insert a time segment that is a large multiple of the orbit
% period immediately following the discretisation point.
scale = 1000;
T = sol.T;

fprintf('Maximum Period from run ''%s'', T = %f \n', run_new, T);
fprintf('Scaled period is T'' = %d x %f = %f \n', scale, T, scale * T);

% Crank up period by factor scale
t0 = [sol.tbp(1:idx,1);
      T * (scale - 1) + sol.tbp(idx+1:end,1)];
% t0 = sol.tbp;

% Read state and parameters from solution
x0 = sol.xbp;
p0 = sol.p;

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
prob = coco_set(prob, 'coll', 'NTST', data.coll.NTST);

% Turn off bifucation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% The value of 10 for 'NAdapt' implied that the trajectory discretisation
% is changed adaptively ten times before the solution is accepted.
NAdapt = 20;
prob = coco_set(prob, 'cont', 'NAdapt', NAdapt);

% Continue periodic orbit from initial solution
prob = ode_isol2po(prob, '', func_list{:}, t0, x0, pnames, p0);

% Assign 'p2' to the set of active continuation parameters and 'po.period'
% to the set of inactive continuation parameters, thus ensuring that the
% latter is fixed during root finding.
prob = coco_xchg_pars(prob, 'p2', 'po.period');

coco(prob, run_new, [], 0, {'p1', 'po.orb.coll.err_TF', 'po.period'});
