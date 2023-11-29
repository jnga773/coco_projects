%-------------------------------------------------------------------------%
%%                Stage I: Continue from Hopf bifurcation                %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
% Run name
run_new = run_names.hopf_bifurcation;

% Print to console
fprintf("~~~ First Run (ode_isol2po) ~~~ \n");
fprintf('Continue Periodic Orbit from Hopf Bifurcation \n');
fprintf('Run name: %s \n', run_new);

%-------------------------------------%
%     Calculate Periodic Solution     %
%-------------------------------------%
% Real and imaginary parts of eigenvectors
v_re = [-(20 / 9) * sqrt(38 / 1353), (2 / 9) * sqrt(38 / 1353), 1];
v_im = [-(19 / 9) * sqrt(5 / 123), -(35 / 9) * sqrt(5 / 123), 0];

% Equilibrium branch for the Hopf bifurcation
eq = [-sqrt(b * (r - 1)), -sqrt(b * (r - 1)), r - 1];

% Frequency
om = 4 * sqrt(110 / 19);

% Period time thing
dt = 2 * pi / 100;
t_max = 2 * pi;
t0 = (0:dt:t_max)' / om;

% Initial periodic orbit solution
x0 = repmat(eq, size(t0)) + 0.01 * ((cos(om * t0) * v_re) - (sin(om * t0) * v_im));

%------------------------------------------%
%     Continuation from Periodic Orbit     %
%------------------------------------------%
% Initialize continuation problem structure with the same number of
% intervals as in previous run.
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set step sizes
prob = coco_set(prob, 'cont', 'h_min', 0.5);
prob = coco_set(prob, 'cont', 'h0', 0.1);
prob = coco_set(prob, 'cont', 'h_max', 0.1);

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set 'var' (whatever that is) to true
% prob = coco_set(prob, 'cont', 'var', true);

% Prob set NTST
prob = coco_set(prob, 'cont', 'NTST', 20);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Continue periodic orbit from initial solution
prob = ode_isol2po(prob, '', func_list{:}, t0, x0, pnames, p0);
% prob = ode_isol2po(prob, '', func_list{:}, t0, x0, pnames, p0, '-var', eye(3));

% prob = ode_isol2coll(prob, '', func_list{:}, t0, x0, pnames, p0);

% Run COCO
coco(prob, run_new, [], 1, 'r', [24, 25]);

%-------------------------------------------------------------------------%
%%                             Testing Stuff                             %%
%-------------------------------------------------------------------------%
%--------------------------------%
%     Read Data and Solution     %
%--------------------------------%
% Find good label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EP');
label_plot = sort(label_plot);
label_plot = label_plot(2);

% [data sol] = coco_read_solution(’’, ’runHopf’, 6);
% M = reshape(sol.x(data.ubp_idx), data.u_shp);
% M1 = M(data.M1_idx,:);
% [v, d] = eig(M1);
% ind = find(abs(diag(d))<1);
% vec0 = -v(:,ind);
% lam0 = d(ind,ind);

lams = coco_bd_val(run_new, label_plot, 'eigs');
fprintf('lams(1) = %s\n', lams(1));
fprintf('lams(2) = %s\n\n', lams(2));
