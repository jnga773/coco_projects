%=========================================================================%
%                       HUXLEY MODEL (Lin's Method)                       %
%=========================================================================%
% Following the model from the COLL-Tutorial.pdf document from COCO, in
% Section 3, with vector field:
%       d/dt x1(t) = x2 ,
%       d/dt x2(t) = (p2 x2) - x1 (1 - x2) - (x1 - p1) ,
% where x1 and x2 are the state space variables, and p1 and p2 are the system
% parameters.
%
% Starting with the last periodic orbit, we insert a long segment
% of constant dynamics and rescale the period such that the shape of the
% orbit in phase space should be unchanged if there exists a nearby
% homoclinic orbit. The extended time profile after the initial correction
% step is shown in panel (e). We clearly observe an elongated phase of
% near-constant dynamics. We overlay this new solution (black dot) on top
% of the previous orbit (gray circle) in panel (f). The phase plots,
% including the distribution of mesh points, are virtually identical, which
% supports the assumption that a nearby homoclinic orbit exists.
%
% Continuation of the periodic orbit with high period, while keeping the
% period constant, resulting in an approximation to a homoclinic
% bifurcation curve (g). Each point on this curve corresponds to a terminal
% point along a family of periodic orbits emenating from a Hopf bifurcation
% under variations in p_2. Panel (h) shows selected members of the family
% of high-period orbits.
%
% The homoclinic is also solved using Lin's method in several steps:
%       Step One: The problem itself is constructed as two collocation
%                 segments with two calls to the COCO constructor
%                 [ode_isol2coll].
%                 The initial conditions, parameters, and other important
%                 inputs are first calculated in 
%                 ./continuation_scripts/lins_method_setup.m, and saved
%                 to the data structure [data_bcs].
%       Step Two: The boundary conditions for the unstable and stable
%                 manifolds, found as functions in ./boundary_conditions/
%                 are then appended with the glue_conditions() function.
%                 The system parameters of the two segments are then
%                 "glued" together, i.e., we tell COCO that they are the
%                 same parameters. We then add the \epsilon spacings
%                 (eps1, eps2) and periods (T1 and T2) of the two segments
%                 as system parameters, and also add the parameters seg_u
%                 and seg_s, representing the distance between the plane
%                 \Sigma (defined in lins_method_setup) and the end points
%                 of the unstable and stable manifolds, respectively.
%     Step Three: We free the parameter seg_u, allowing the unstable
%                 manifold to grow until it hits the plane \Sigma,
%                 which is defined as a label "DelU".
%      Step Four: We reconstruct the COCO problem with ode_coll2coll,
%                 re-append the boundary conditions, and then free seg_s,
%                 growing the stable manifold until it starts on the plane
%                 \Sigma, corresponding to the label DelS.
%      Step Five: We reconstruct the problem again, and then calculate the
%                 Lin gap vector, and initial distance, using the function
%                 find_lingap_vector(). The Lin gap boundary condition is
%                 then added with glue_lin_conditions(), and the parameter
%                 "lingap" is freed, closing the Lin gap until the unstable
%                 and stable manifolds connect.
%       Step Six: With the homoclinic found, we then free then reconstruct
%                 the problem again, and then free the two system
%                 parameters p1 and p2, following the heteroclinic in two
%                 parameters.

% Clear plots
close('all');

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');
% Add boundary condition functions to path
addpath('./boundary_conditions/');

% Add continuation scripts
addpath('./continuation_scripts/');

% Add plotting scripts
addpath('./plotting_scripts/');

% Save figures switch
% save_figure = true;
save_figure = false;

%--------------------%
%     Parameters     %
%--------------------%
% Parameter names
p1 = 0.5;
p2 = 0;

% Initial parameter values
p0 = [p1; p2];

% Parameter names
pnames = {'p1', 'p2'};

%-----------------------%
%     Problem Setup     %
%-----------------------%
% Equilibria points
x0_u = [0; 0];
x0_s = [1.0; 0.0];

% State dimensions
pdim = length(p0);
xdim = length(x0_u);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
% funcs_field = {@huxley, [], []};
funcs_field = {@huxley, @huxley_DFDX, []};

% Boundary conditions: Initial conditions
bcs_funcs.bcs_initial = {@bcs_initial};
% Boundary conditions: Final conditions
bcs_funcs.bcs_final   = {@bcs_final};
% Boundary conditions: Lin gap conditions
bcs_funcs.bcs_lingap  = {@bcs_lingap};

%=========================================================================%
%                    LIN'S METHOD FOR HOMOCLINIC ORBIT                    %
%=========================================================================%
% We now calculate the homoclinic orbit using Lin's method, with steps
% outlined at the top of this program.

%-------------------------------------------------------------------------%
%%                         Grow Unstable Manifold                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.unstable_manifold = 'run01_unstable_manifold';
run_new = run_names.lins_method.unstable_manifold;
% Print to console
fprintf("~~~ Lin's Method: First Run (ode_isol2coll) ~~~ \n");
fprintf('Continue unstable trajectory segment until we hit Sigma plane \n');
fprintf('Run name: %s  \n', run_new);

%-------------------%
%     Read Data     %
%-------------------%
data_lins = lins_method_setup(x0_u, x0_s, p0, pnames);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 50);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set Continuation steps
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_isol2coll(prob, 'unstable', funcs_field{:}, ...
                     data_lins.t0, data_lins.x_init_u, data_lins.p0);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', funcs_field{:}, ...
                     data_lins.t0, data_lins.x_init_s, data_lins.p0);

% Construct instance of 'ep' tool box to follow stationary point
prob = ode_isol2ep(prob, 'x0_u', funcs_field{:}, data_lins.x0_u, ...
                   data_lins.p0);
prob = ode_isol2ep(prob, 'x0_s', funcs_field{:}, data_lins.x0_s, ...
                   data_lins.p0);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, data_lins.epsilon0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'seg_u', 'T1', 'T2'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelU');
label_plot = label_plot(1);

plot_run_i(run_new, 1, 1, save_figure);
plot_run_i(run_new, label_plot, 2, save_figure);

%-------------------------------------------------------------------------%
%%                          Grow Stable Manifold                          %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.stable_manifold = 'run02_stable_manifold';
run_new = run_names.lins_method.stable_manifold;
% Which run this continuation continues from
run_old = run_names.lins_method.unstable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelU');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Second Run (ode_coll2coll) ~~~ \n");
fprintf('Continue stable trajectory segment until we hit Sigma plane \n');
fprintf('Run name: %s  \n', run_new);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set Continuation steps
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0_u', run_old, label_old);
prob = ode_ep2ep(prob, 'x0_s', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Extract stored deviations of stable and unstable manifolds from
% stationary equilibrium point
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, epsilon);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'seg_s', 'T2', 'p1'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelS');
label_plot = label_plot(1);

plot_run_i(run_new, label_plot, 3, save_figure);

%-------------------------------------------------------------------------%
%%                   Lin's Method: Closing the Lin Gap                   %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.close_lingap = 'run03_close_lingap';
run_new = run_names.lins_method.close_lingap;
% Which run this continuation continues from
run_old = run_names.lins_method.stable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelS');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Third Run (ode_coll2coll) ~~~ \n");
fprintf('Close the Lin Gap on the Sigma Plane \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set Continuation steps
PtMX = 100;
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0_u', run_old, label_old);
prob = ode_ep2ep(prob, 'x0_s', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Extract stored deviations of stable and unstable manifolds from
% stationary equilibrium point
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, epsilon);

%---------------------------------%
%     Apply Lin Gap Condition     %
%---------------------------------%
% Find Lin's Vector
data_lingap = find_lingap_vector(run_old, label_old);
lingap = data_lingap.lingap0;

% Apply Lin's conditions
prob = apply_lingap_conditions(prob, data_lingap, bcs_funcs, lingap);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'lingap', 'T1', 'T2', 'p1', 'seg_u'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
label_plot = label_plot(1);

plot_run_i(run_new, label_plot, 1, save_figure);

%-------------------------------------------------------------------------%
%%                        Close the Distance eps1                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.close_eps1 = 'run04_close_eps1';
run_new = run_names.lins_method.close_eps1;
% Which run this continuation continues from
run_old = run_names.lins_method.close_lingap;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');
label_old = label_old(1);

% Print to console
fprintf("~~~ Lin's Method: Fourth Run (ode_coll2coll) ~~~ \n");
fprintf('Close epsilon gap until eps1=1e-8 \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% % Set Continuation steps
% PtMX = 100;
% prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0_u', run_old, label_old);
prob = ode_ep2ep(prob, 'x0_s', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Extract stored deviations of stable and unstable manifolds from
% stationary equilibrium point
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, epsilon);

%---------------------------------%
%     Apply Lin Gap Condition     %
%---------------------------------%
% Find Lin's Vector
data_lingap = find_lingap_vector(run_old, label_old);
lingap = data_lingap.lingap0;

% Apply Lin's conditions
prob = apply_lingap_conditions(prob, data_lingap, bcs_funcs, lingap);

%------------------%
%     Run COCO     %
%------------------%
% Add event for when eps1 gets small enough
prob = coco_add_event(prob, 'EPS1', 'eps1', 1e-4);

% Run COCO continuation
coco(prob, run_new, [], 1, {'eps1', 'T1', 'T2', 'p1', 'seg_u'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EPS1');
label_plot = label_plot(1);

plot_run_i(run_new, label_plot, 4, save_figure);

%-------------------------------------------------------------------------%
%%                        Close the Distance eps2                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.close_eps2 = 'run05_close_eps2';
run_new = run_names.lins_method.close_eps2;
% Which run this continuation continues from
run_old = run_names.lins_method.close_eps1;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS1');

% Print to console
fprintf("~~~ Lin's Method: Fifth Run (ode_coll2coll) ~~~ \n");
fprintf('Close epsilon gap until eps2=1e-8 \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% % Set Continuation steps
% PtMX = 100;
% prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0_u', run_old, label_old);
prob = ode_ep2ep(prob, 'x0_s', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Extract stored deviations of stable and unstable manifolds from
% stationary equilibrium point
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, epsilon);

%---------------------------------%
%     Apply Lin Gap Condition     %
%---------------------------------%
% Find Lin's Vector
data_lingap = find_lingap_vector(run_old, label_old);
lingap = data_lingap.lingap0;

% Apply Lin's conditions
prob = apply_lingap_conditions(prob, data_lingap, bcs_funcs, lingap);

%------------------%
%     Run COCO     %
%------------------%
% Add event for when eps1 gets small enough
prob = coco_add_event(prob, 'EPS2', 'eps2', 1.0e-4);

% Run COCO continuation
coco(prob, run_new, [], 1, {'eps2', 'T1', 'T2', 'p1', 'seg_u'}); 

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EPS2');
label_plot = label_plot(1);

plot_homoclinic_manifold_run(run_new, label_plot, 5, save_figure);

%-------------------------------------------------------------------------%
%%                     Parametrise the Heteroclinic                      %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.continue_homoclinics = 'run06_continue_homoclinics';
run_new = run_names.lins_method.continue_homoclinics;
% Which run this continuation continues from
run_old = run_names.lins_method.close_eps2;
% run_old = run_names.lins_method.close_lingap;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS2');
% label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');

% Print to console
fprintf("~~~ Lin's Method: Sixth Run (ode_coll2coll) ~~~ \n");
fprintf('Continue constrained segments to find parametrisation of homoclinic \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off MXCL?
prob = coco_set(prob, 'coll', 'MXCL', false);

% Set NTST size
prob = coco_set(prob, 'coll', 'NTST', 25);

% Set NAdpat
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set Continuation steps
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Construct first instance of 'coll' toolbox for unstable manifold
prob = ode_coll2coll(prob, 'unstable', run_old, label_old);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_coll2coll(prob, 'stable', run_old, label_old);
% Construct second instance of 'ep' toolbox for equilibrium point
prob = ode_ep2ep(prob, 'x0_u', run_old, label_old);
prob = ode_ep2ep(prob, 'x0_s', run_old, label_old);

%-----------------------------------%
%     Apply Boundary Conditions     %
%-----------------------------------%
% Extract stored deviations of stable and unstable manifolds from
% stationary equilibrium point
[data, chart] = coco_read_solution('bcs_initial', run_old, label_old);
epsilon = chart.x(data.epsilon_idx);

% Glue that shit together, haumi ;)
prob = apply_manifold_conditions(prob, data_lins, bcs_funcs, epsilon);

%---------------------------------%
%     Apply Lin Gap Condition     %
%---------------------------------%
% Find Lin's Vector
data_lingap = find_lingap_vector(run_old, label_old);
lingap = data_lingap.lingap0;

% Apply Lin's conditions
prob = apply_lingap_conditions(prob, data_lingap, bcs_funcs, lingap);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
bdtest = coco(prob, run_new, [], 1, {'p1', 'p2', 'eps1', 'eps2', 'seg_u'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
% label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
% label_plot = label_plot(1);

plot_run_i(run_new, 5, 6, save_figure);

% Plot bifurcation diagram
plot_bifurcation_diagram(run_new, save_figure);
