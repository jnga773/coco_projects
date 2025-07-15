%=========================================================================%
%                      MARSDEN MODEL (Lin's Method)                       %
%=========================================================================%
% Example 8.3 in Recipes for Continuation
%
% We compute a family of periodic orbits emanating from a Hopf bifurcation
% point of the dynamical system
%
% x1' = p1*x1 + x2 + p2*x1^2
% x2' = -x1 + p1*x2 + x2*x3
% x3' = (p1^2 - 1)*x2 - x1 - x3 + x1^2
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
addpath('./functions/field/');
% Add boundary condition functions to path
addpath('./functions/boundary_conditions/');

% Add continuation scripts
addpath('./continuation_scripts/');

% Add plotting scripts
addpath('./plotting_scripts/');
% addpath('./plotting_scripts/homoclinic_approx/');
addpath('./plotting_scripts/lins_method/');

% Save figures switch
% save_figure = true;
save_figure = false;

%--------------------%
%     Parameters     %
%--------------------%
% Parameter names
p1 = -1.0;
p2 = 6.0;

% Initial parameter values
p0 = [p1; p2];

% Parameter names
pnames = {'p1', 'p2'};

%-----------------------%
%     Problem Setup     %
%-----------------------%
% Initial state values
x0 = [0.0; 0.0; 0.0];

% Parameter ranges
p1_range = [-1.0, 1.0];
p2_range = [0.0, 40.0];
p_range = [p1_range, p2_range];

% State dimensions
pdim = length(p0);
xdim = length(x0);

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Vector field: Functions
funcs_field = {@marsden, @marsden_DFDX, @marsden_DFDP};

% Boundary conditions: Initial conditions
bcs_funcs.bcs_initial = {@bcs_initial};
% Boundary conditions: Final conditions
bcs_funcs.bcs_final   = {@bcs_final};
% Boundary conditions: Lin gap conditions
bcs_funcs.bcs_lingap  = {@bcs_lingap};

%=========================================================================%
%               APPROXIMATE HOMOCLINIC FROM PERIODIC ORBIT                %
%=========================================================================%
% We compute an approximation to a homoclinic orbit by taking a periodic
% orbit with large period, and continuing that in two parameters.

%-------------------------------------------------------------------------%
%%                   Compute Initial Equilibrium Point                   %%
%-------------------------------------------------------------------------%
% We compute and continue the equilibrium point of the model using
% the 'EP' toolbox constructor 'ode_isol2ep'.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.initial_EP = 'run01_initial_EP';
run_new = run_names.initial_EP;

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Initialisation: First Run\n');
fprintf(' Continue family of equilibrium points\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Continuation parameters : %s\n', 'p1');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Set upper bound of continuation steps in each direction along solution
prob = coco_set(prob, 'cont', 'PtMX', 100);

% Detect and locate neutral saddles
prob = coco_set(prob, 'ep', 'NSA', true);
prob = coco_set(prob, 'ep', 'BTP', true);

% Set up isol2ep problem
prob = ode_isol2ep(prob, '', funcs_field{:}, x0, pnames, p0);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 'p1', p1_range);

%-------------------------------------------------------------------------%
%%                   Continuation from Hopf Bifurcation                  %%
%-------------------------------------------------------------------------%
% We continue a family of periodic orbitfrom the Hopf bifurcation in run1
% with a call to ode_HB2PO.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.PO_from_hopf = 'run02_periodic_orbit_from_hopf';
run_new = run_names.PO_from_hopf;
% Which run this continuation continues from
run_old = run_names.initial_EP;

% Label for Hopf bifurcation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'HB');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Approximate Homoclinic: First Run\n');
fprintf(' Continue periodic orbits originating from Hopf bifurcation\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'p1, po.period');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NAdapt to 1?
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set upper bound of continuation steps in each direction along solution
% 'PtMX', [negative steps, positive steps]
PtMX = 200;
% prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);
prob = coco_set(prob, 'cont', 'PtMX', [PtMX, 0]);

% Continue from branching point
prob = ode_HB2po(prob, '', run_old, label_old);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'p1', 'po.period'}, p1_range);

%-------------------------------------------------------------------------%
%%                   Locate High Period Periodic Orbit                   %%
%-------------------------------------------------------------------------%
% We reconstruct a periodic orbit of high period, and make it even larger.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.high_period = 'run03_high_period_periodic_orbit';
run_new = run_names.high_period;
% Which run this continuation continues from
run_old = run_names.PO_from_hopf;

% Read solution of previous run with largest period.
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Approximate Homoclinic: Second Run\n');
fprintf(' Find reconstructed high-period periodic orbit approximating a homoclinic connection\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'p1, homo.po.orb.coll.err_TF, homo.po.period');
fprintf(' =====================================================================\n');

%-------------------------------------%
%     Read Data from Previous Run     %
%-------------------------------------%
% Find minimum point corresponding to equilibrium point, and insert
% large time segment.
po_data = insert_large_time_segment(run_old, label_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up COCO problem
prob = coco_prob();

% Set NTST to previous solutions NTST
prob = coco_set(prob, 'coll', 'NTST', po_data.NTST);

% Turn off bifucation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% The value of 10 for 'NAdapt' implied that the trajectory discretisation
% is changed adaptively ten times before the solution is accepted.
prob = coco_set(prob, 'cont', 'NAdapt', 10);

% Continue periodic orbit from initial solution
prob = ode_isol2po(prob, 'homo', funcs_field{:}, ...
                   po_data.t_sol, po_data.x_sol, pnames, po_data.p0);

% Add instance of equilibrium point to find and follow the actual 
% equilibrium point
prob = ode_isol2ep(prob, 'x0', funcs_field{:}, ...
                   po_data.x0, po_data.p0);

% Read construct data and indices of the two COCO instances
[data1, uidx1] = coco_get_func_data(prob, 'homo.po.orb.coll', 'data', 'uidx');
[data2, uidx2] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

% "Glue" the two segments' parameters together
prob = coco_add_glue(prob, 'shared_parameters', ...
                     uidx1(data1.coll_seg.maps.p_idx), uidx2(data2.ep_eqn.p_idx));

% Assign 'p2' to the set of active continuation parameters and 'po.period'
% to the set of inactive continuation parameters, thus ensuring that the
% latter is fixed during root finding.
prob = coco_xchg_pars(prob, 'p2', 'homo.po.period');

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 0, {'p1', 'homo.po.orb.coll.err_TF', 'homo.po.period'});

%-------------------------------------------------------------------------%
%%            Follow Approximate Homoclinic in Two Parameters            %%
%-------------------------------------------------------------------------%
% Having reconstructed a large period periodic orbit as an approximate
% homoclinic orbit, we continue in the two system parameters.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.continue_approx_homoclinics = 'run04_continue_approximate_homoclinics';
run_new = run_names.continue_approx_homoclinics;
% Which run this continuation continues from
run_old = run_names.high_period;

% Grab the label for the previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(' Approximate Homoclinic: Third Run\n');
fprintf(' Continue family of periodic orbits approximating homoclinics\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'p1, p2, homo.po.period');
fprintf(' =====================================================================\n');

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Initialise continuation problem
prob = coco_prob();

% Turn off bifurcation detections
prob = coco_set(prob, 'po', 'bifus', 'off');

% Set NAdapt
prob = coco_set(prob, 'cont', 'NAdapt', 1);

% Set number of continuation steps
PtMX = 500;
prob = coco_set(prob, 'cont', 'PtMX', PtMX);

% Continue a periodic orbit from a previous periodic orbit
prob = ode_po2po(prob, 'homo', run_old, label_old);

% Continue from equilibrium point
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

% Read construct data and indices of the two COCO instances
[data1, uidx1] = coco_get_func_data(prob, 'homo.po.orb.coll', 'data', 'uidx');
[data2, uidx2] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

% "Glue" the two segments' parameters together
prob = coco_add_glue(prob, 'shared_parameters', ...
                     uidx1(data1.coll_seg.maps.p_idx), uidx2(data2.ep_eqn.p_idx));

% Assign 'p2' to the set of active continuation parameters and 'po.period'
% to the set of inactive continuation parameters, thus ensuring that the
% latter is fixed during root finding.
prob = coco_xchg_pars(prob, 'p2', 'homo.po.period');

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
coco(prob, run_new, [], 1, {'p1', 'p2', 'homo.po.period'}, p_range);

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
run_names.lins_method.unstable_manifold = 'run07_unstable_manifold';
run_new = run_names.lins_method.unstable_manifold;
% Which run this continuation continues from
run_old = run_names.high_period;

% Grab the label for the previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EP');
label_old = max(label_old);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: First Run\n");
fprintf(' Continue unstable trajectory segment until we hit Sigma plane\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'seg_u, T1, p1');
fprintf(' =====================================================================\n');

%-------------------%
%     Read Data     %
%-------------------%
data_lins = lins_method_setup(run_old, label_old);

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
prob = ode_isol2coll(prob, 'unstable', funcs_field{:}, ...
                     data_lins.t0, data_lins.x_init_u, data_lins.p0);
% Construct second instance of 'coll' toolbox for stable manifold
prob = ode_isol2coll(prob, 'stable', funcs_field{:}, ...
                     data_lins.t0, data_lins.x_init_s, data_lins.p0);

% Construct instance of 'ep' tool box to follow stationary point
prob = ode_isol2ep(prob, 'x0', funcs_field{:}, data_lins.x_ss, ...
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
coco(prob, run_new, [], 1, {'seg_u', 'T1', 'p1'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'DelU');
label_plot = label_plot(1);

plot_homoclinic_manifold_run(run_new, label_plot, data_lins.xbp_PO, 1, save_figure);

% %--------------------------%
% %     Print to Console     %
% %--------------------------%
% [sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
% [sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% [solx, ~] = ep_read_solution('x0', run_new, label_plot);

% fprintf('Print Start and End Points to Console\n');
% fprintf('Equilibrium point       = (%.3f, %.3f, %.3f)\n', solx.x);
% fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
% fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
% fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
% fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));

%-------------------------------------------------------------------------%
%%                          Grow Stable Manifold                          %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.stable_manifold = 'run08_stable_manifold';
run_new = run_names.lins_method.stable_manifold;
% Which run this continuation continues from
run_old = run_names.lins_method.unstable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelU');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Second Run\n");
fprintf(' Continue stable trajectory segment until we hit Sigma plane\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'seg_s, T2, p1');
fprintf(' =====================================================================\n');

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
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

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

plot_homoclinic_manifold_run(run_new, label_plot, data_lins.xbp_PO, 2, save_figure);

% %--------------------------%
% %     Print to Console     %
% %--------------------------%
% [sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
% [sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% [solx, ~] = ep_read_solution('x0', run_new, label_plot);

% fprintf('Print Start and End Points to Console\n');
% fprintf('Equilibrium point       = (%.3f, %.3f, %.3f)\n', solx.x);
% fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
% fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
% fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
% fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));

%-------------------------------------------------------------------------%
%%                   Lin's Method: Closing the Lin Gap                   %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.close_lingap = 'run09_close_lingap';
run_new = run_names.lins_method.close_lingap;
% Which run this continuation continues from
run_old = run_names.lins_method.stable_manifold;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'DelS');
label_old = label_old(1);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Third Run\n");
fprintf(' Reduce the Lin gap to zero\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'lingap, T1, T2, theta, p1, seg_u');
fprintf(' =====================================================================\n');

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
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

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
coco(prob, run_new, [], 1, {'lingap', 'T1', 'T2', 'theta', 'p1', 'seg_u'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
label_plot = label_plot(1);

plot_homoclinic_manifold_run(run_new, label_plot, data_lins.xbp_PO, 3, save_figure);

% %--------------------------%
% %     Print to Console     %
% %--------------------------%
% [sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
% [sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% 
% fprintf('Print Start and End Points to Console\n');
% fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
% fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
% fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
% fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));

%-------------------------------------------------------------------------%
%%                        Close the Distance eps1                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.close_eps1 = 'run10_close_eps1';
run_new = run_names.lins_method.close_eps1;
% Which run this continuation continues from
run_old = run_names.lins_method.close_lingap;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');
label_old = label_old(2);

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Fourth Run\n");
fprintf(' Close epsilon gap until eps1=1e-8\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'eps1, T1, T2, theta, p1, seg_u');
fprintf(' =====================================================================\n');

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
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

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
prob = coco_add_event(prob, 'EPS1', 'eps1', -1.0e-3);

% Run COCO continuation
coco(prob, run_new, [], 1, {'eps1', 'T1', 'T2', 'theta', 'p1', 'seg_u'}); 

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EPS1');
label_plot = label_plot(1);

plot_homoclinic_manifold_run(run_new, label_plot, data_lins.xbp_PO, 4, save_figure);

% %--------------------------%
% %     Print to Console     %
% %--------------------------%
% [sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
% [sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% 
% fprintf('Print Start and End Points to Console\n');
% fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
% fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
% fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
% fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));

%-------------------------------------------------------------------------%
%%                        Close the Distance eps2                        %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.close_eps2 = 'run11_close_eps2';
run_new = run_names.lins_method.close_eps2;
% Which run this continuation continues from
run_old = run_names.lins_method.close_eps1;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS1');

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Fifth Run\n");
fprintf(' Close epsilon gap until eps2=1e-8\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'eps2, T1, T2, theta, p1, seg_u');
fprintf(' =====================================================================\n');

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
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

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
coco(prob, run_new, [], 1, {'eps2', 'T1', 'T2', 'theta', 'p1', 'seg_u'}); 

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
label_plot = coco_bd_labs(coco_bd_read(run_new), 'EPS2');
label_plot = label_plot(1);

plot_homoclinic_manifold_run(run_new, label_plot, data_lins.xbp_PO, 5, save_figure);

% %--------------------------%
% %     Print to Console     %
% %--------------------------%
% [sol1, ~] = coll_read_solution('unstable', run_new, label_plot);
% [sol2, ~] = coll_read_solution('stable', run_new, label_plot);
% 
% fprintf('Print Start and End Points to Console\n');
% fprintf('Unstable starting point = (%.3f, %.3f, %.3f)\n', sol1.xbp(1, :));
% fprintf('Unstable ending point   = (%.3f, %.3f, %.3f)\n', sol1.xbp(end, :));
% fprintf('Stable starting point   = (%.3f, %.3f, %.3f)\n', sol2.xbp(1, :));
% fprintf('Stable ending point     = (%.3f, %.3f, %.3f)\n', sol2.xbp(end, :));

%-------------------------------------------------------------------------%
%%                     Parametrise the Heteroclinic                      %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.lins_method.continue_homoclinics = 'run12_continue_homoclinics';
run_new = run_names.lins_method.continue_homoclinics;
% Which run this continuation continues from
run_old = run_names.lins_method.close_eps2;
% run_old = run_names.lins_method.close_lingap;

% Label for previous run solution
label_old = coco_bd_labs(coco_bd_read(run_old), 'EPS2');
% label_old = coco_bd_labs(coco_bd_read(run_old), 'Lin0');

%--------------------------%
%     Print to Console     %
%--------------------------%
fprintf(' =====================================================================\n');
fprintf(" Lin's Method: Fifth Run\n");
fprintf(' Continue constrained segments to find parametrisation of homoclinic\n');
fprintf(' ---------------------------------------------------------------------\n');
fprintf(' This run name           : %s\n', run_new);
fprintf(' Previous run name       : %s\n', run_old);
fprintf(' Previous solution label : %d\n', label_old);
fprintf(' Continuation parameters : %s\n', 'p1, p2, eps1, eps2, theta, seg_u');
fprintf(' =====================================================================\n');

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
prob = ode_ep2ep(prob, 'x0', run_old, label_old);

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
bdtest = coco(prob, run_new, [], 1, {'p1', 'p2', 'eps1', 'eps2', 'theta', 'seg_u'});

%--------------------%
%     Test Plots     %
%--------------------%
% Grab solution label to plot
% label_plot = coco_bd_labs(coco_bd_read(run_new), 'Lin0');
% label_plot = label_plot(1);
label_plot = 25;

plot_homoclinic_manifold_run(run_new, label_plot, data_lins.xbp_PO, 6, save_figure);

% plot_temporal_solution_single(run_new, label_plot, 20, save_figure);
% plot_temporal_solutions(run_new, 19, save_figure);

compare_homoclinic_bifurcations(run_names, save_figure);

%-------------------------------------------------------------------------%
%%                             Plot Things                               %%
%-------------------------------------------------------------------------%
% Plot bifurcation diagram
plot_bifurcation_diagram(run_names, save_figure);
