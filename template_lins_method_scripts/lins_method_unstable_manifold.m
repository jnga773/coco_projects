%-------------------------------------------------------------------------%
%%           Solve for Unstable Manifold towards data_bcs.pt0            %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.lins_method.unstable_manifold;

% Print to console
fprintf("~~~ Lin's Method: First Run (ode_isol2coll) ~~~ \n");
fprintf('Continue unstable trajectory segment until we hit Sigma plane \n');
fprintf('Run name: %s  \n', run_new);

%--------------------------------------%
%     Initialise Problem Structure     %
%--------------------------------------%
% Construct instance of huxley continuation problem from initial data.
prob = coco_prob();

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_isol2coll(prob, 'unstable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_u, data_bcs.p0);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', func_list{:}, ...
                     data_bcs.t0, data_bcs.x_init_s, data_bcs.p0);

% Construct instance of 'ep' tool box to follow stationary point
prob = ode_isol2ep(prob, 'x0', func_list{:}, data_bcs.equilib_pt, ...
                   data_bcs.p0);

% Glue that shit together, haumi ;)
prob = glue_conditions(prob, data_bcs, epsilon0);

% Run COCO
coco(prob, run_new, [], 1, {'seg_u', 'T1', 'p1'});
% coco(prob, run_new, [], 1, {'seg_u', 'p1'});
