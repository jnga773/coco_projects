%=========================================================================%
%                     YAMADA MODEL (Phase Resetting)                      %
%=========================================================================%
% Doing an exmaple from this paper "A Continuation Approach to Calculating
% Phase Resetting Curves" by Langfield et al.

% Clear plots
close('all');

% Clear workspace
clear;
clc;

% Add equation/functions to path
addpath('./functions/');

% Add equation/functions to path
addpath('./functions/');
% Add field functions to path
addpath('./functions/fields/');
% Add boundary condition functions to path
addpath('./functions/bcs/');
% Add SymCOCO files to path
addpath('./functions/symcoco/');

% Add continuation scripts
addpath('./continuation_scripts/PTC/');

% Add plotting scripts
addpath('./plotting_scripts/PTC');

% Save figure switch
% save_figure = true;
save_figure = false;

%-------------------------%
%     Functions Lists     %
%-------------------------%
% Phase Reset Segment 1: Functions
% func.seg1 = {@func_seg1};
funcs.seg1 = func_seg1_symbolic();

% Phase Reset: Segment 2
% funcs.seg2 = {@func_seg2};
funcs.seg2 = func_seg2_symbolic();

% Phase Reset: Segment 3
% funcs.seg3 = {@func_seg3};
funcs.seg3 = func_seg3_symbolic();

% Phase Reset: Segment 4
% funcs.seg4 = {@func_seg4};
funcs.seg4 = func_seg4_symbolic();

% Boundary conditions: Period
% bcs_funcs.bcs_T = {@bcs_T};
bcs_funcs.bcs_T = bcs_T_symbolic();

% Boundary conditions: Phase-resetting segments
% bcs_funcs.bcs_segs = {@bcs_PR_segs};
bcs_funcs.bcs_segs = bcs_PR_segs_symbolic();

%-------------------------------------------------------------------------%
%%                   Increasing Pertubation Amplitude                    %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.phase_reset_perturbation = 'run01_phase_reset_perturbation';
run_new = run_names.phase_reset_perturbation;

% Print to console
fprintf("~~~ Phase Transition Curve: First Run ~~~ \n");
fprintf('Increase perturbation amplitude \n');
fprintf('Run name: %s \n', run_new);

%-------------------%
%     Read Data     %
%-------------------%
% Set periodicity
k = 5;
% Set perturbation direction
theta_perturb = pi;

% Set initial conditions from previous solutions
data_PR = calc_PR_initial_conditions(k, theta_perturb);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 5e-5);
% prob = coco_set(prob, 'cont', 'h0', 1e-3);
prob = coco_set(prob, 'cont', 'h_max', 1e1);

% Set adaptive mesh
prob = coco_set(prob, 'cont', 'NAdapt', 10);

% Set number of steps
PtMX = 1000;
prob = coco_set(prob, 'cont', 'PtMX', [0, PtMX]);

% Set number of stored solutions
prob = coco_set(prob, 'cont', 'NPR', 100);

% Turn off MXCL
prob = coco_set(prob, 'coll', 'MXCL', 'off');

% Set norm to int
prob = coco_set(prob, 'cont', 'norm', inf);

% Set MaxRes and al_max
prob = coco_set(prob, 'cont', 'MaxRes', 10);
prob = coco_set(prob, 'cont', 'al_max', 25);

%------------------%
%     Set NTST     %
%------------------%
% In calc_PR_initial conditions, we define segment 4 as having 'k' periods,
% where 'k' is an integer. This is the perturbed segment, that may have to
% orbit the unperturbed periodic orbit many times before "resetting". Hence
% we have set the NTST for this segment (NTST(4)) as k * 50.
NTST(1) = 50;
NTST(2) = 10;
NTST(3) = 10;
NTST(4) = 50 * k;

prob = coco_set(prob, 'seg1.coll', 'NTST', NTST(1));
prob = coco_set(prob, 'seg2.coll', 'NTST', NTST(2));
prob = coco_set(prob, 'seg3.coll', 'NTST', NTST(3));
prob = coco_set(prob, 'seg4.coll', 'NTST', NTST(4));

%------------------------------------%
%     Create Trajectory Segments     %
%------------------------------------%
% Here we set up the four segments to calculate the phase resetting curve:
% Segment 1 - Trajectory segment of the periodic orbit from the zero-phase
%             point (gamma_0) to the point where the perturbed trajectory 
%             comes close to the periodic orbit (at theta_new).
prob = ode_isol2coll(prob, 'seg1', funcs.seg1{:}, ...
                     data_PR.t_seg1, data_PR.x_seg1, data_PR.p0);

% Segment 2 - Trajectory segment of the periodic from the end of Segment 1
%             (at theta_new) back to the zero-phase point (gamma_0).
prob = ode_isol2coll(prob, 'seg2', funcs.seg2{:}, ...
                     data_PR.t_seg2, data_PR.x_seg2, data_PR.p0);

% Segment 3 - Trajectory segment of the periodic orbit from the zero-phase
%             point (gamma_0) to the point at which the perturbation is
%             applied (theta_old).
prob = ode_isol2coll(prob, 'seg3', funcs.seg3{:}, ...
                     data_PR.t_seg3, data_PR.x_seg3, data_PR.p0);   

% Segment 4 - Trajectory segment of the perturbed trajectory, from
%             theta_old to theta_new.
prob = ode_isol2coll(prob, 'seg4', funcs.seg4{:}, ...
                     data_PR.t_seg4, data_PR.x_seg4, data_PR.p0);

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply all boundary conditions, glue parameters together, and
% all that other good COCO stuff. Looking the function file
% if you need to know more ;)
prob = apply_PR_boundary_conditions(prob, data_PR, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Array of values for special event
SP_values = [0.0; 0.4; 0.75];

% When the parameter we want (from param) equals a value in A_vec
prob = coco_add_event(prob, 'SP', 'A_perturb', SP_values);

%------------------%
%     Run COCO     %
%------------------%
% Run COCO continuation
prange = {[-1e-4, max(SP_values)], [], [], [0.99, 1.01], []};
bdtest = coco(prob, run_new, [], 1, ...
              {'A_perturb', 'theta_new', 'eta', 'mu_s', 'T'}, prange);

%--------------------%
%     Test Plots     %
%--------------------%
% Label of solution to plot
label_plot = sort(coco_bd_labs(coco_bd_read(run_new), 'SP'));
label_plot = label_plot(end);

% Plot some stuff my g
plot_phase_reset_phase_space(run_new, label_plot, 21, save_figure);

% Plot perturbation amplitude against theta_new
plot_langfield_four_figure(run_new, save_figure)
% plot_A_perturb_theta_new(run_new, save_figure);

%-------------------------------------------------------------------------%
%%                 Phase Transition Curve (PTC) - Single                 %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% Current run name
run_names.phase_transition_curve = 'run02_phase_reset_PTC_single';
run_new = run_names.phase_transition_curve;
% Which run this continuation continues from
run_old = run_names.phase_reset_perturbation;

% Continuation point
label_old = coco_bd_labs(coco_bd_read(run_old), 'SP');
label_old = label_old(end);

% Print to console
fprintf("~~~ Phase Reset: Second Run ~~~ \n");
fprintf('Fix A_perturb and continue in theta_perturb \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%----------------------------%
%     Setup Continuation     %
%----------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set tolerance
% prob = coco_set(prob, 'corr', 'TOL', 5e-7);

% Set step sizes
% prob = coco_set(prob, 'cont', 'h_min', 5e-2);
% prob = coco_set(prob, 'cont', 'h0', 1e-1);
prob = coco_set(prob, 'cont', 'h_max', 1e1);

% Set adaptive meshR
prob = coco_set(prob, 'cont', 'NAdapt', 10);

% Set number of steps
prob = coco_set(prob, 'cont', 'PtMX', 750);

% Set norm to int
prob = coco_set(prob, 'cont', 'norm', inf);

% Set MaxRes and al_max
prob = coco_set(prob, 'cont', 'MaxRes', 10);
prob = coco_set(prob, 'cont', 'al_max', 25);

%-------------------------------------------%
%     Continue from Trajectory Segments     %
%-------------------------------------------%
% Segment 1
prob = ode_coll2coll(prob, 'seg1', run_old, label_old);
% Segment 2
prob = ode_coll2coll(prob, 'seg2', run_old, label_old);
% Segment 3
prob = ode_coll2coll(prob, 'seg3', run_old, label_old);
% Segment 4
prob = ode_coll2coll(prob, 'seg4', run_old, label_old); 

%------------------------------------------------%
%     Apply Boundary Conditions and Settings     %
%------------------------------------------------%
% Apply all boundary conditions, glue parameters together, and
% all that other good COCO stuff. Looking the function file
% if you need to know more ;)
prob = apply_PR_boundary_conditions(prob, data_PR, bcs_funcs);

%-------------------------%
%     Add COCO Events     %
%-------------------------%
% Run COCO continuation
prange = {[0.0, 1.0], [], [], [0.99, 1.01], [], []};
coco(prob, run_new, [], 1, {'theta_old', 'theta_new', 'eta', 'mu_s', 'T', 'A_perturb'}, prange);

%--------------------%
%     Test Plots     %
%--------------------%
% Plot first SP solution
plot_phase_reset_phase_space(run_new, label_plot(1), 1, save_figure);

% Plot phase transition curve (PTC)
plot_phase_transition_curve(run_new);

%-------------------------------------------------------------------------%
%%                Phase Transition Curve (PTC) - Multiple                %%
%-------------------------------------------------------------------------%
%------------------%
%     Run Name     %
%------------------%
% % Current run name
% run_names.phase_transition_curve = 'run10_phase_reset_PTC_scan';
% % Which run this continuation continues from
% run_old = run_names.phase_reset_perturbation;
% 
% % Continuation point
% label_old = coco_bd_labs(coco_bd_read(run_old), 'SP');
% 
% % Print to console
% fprintf("~~~ Phase Reset: Second Run ~~~ \n");
% fprintf('Calculate phase transition curve \n');
% fprintf('Run name: %s \n', run_names.phase_transition_curve);
% fprintf('Continuing from SP points in run: %s \n', run_old);

%---------------------------------%
%     Cycle through SP labels     %
%---------------------------------%
% % Set number of threads
% M = 0;
% parfor (run = 1 : length(label_old), M)
%   % Label for this run
%   this_run_label = label_old(run);
% 
%   % Data directory for this run
%   fprintf('\n Continuing from point %d in run: %s \n', this_run_label, run_old);
% 
%   this_run_name = {run_names.phase_transition_curve; sprintf('run_%02d', run)};
% 
%   % Run continuation
%   PTC_scan_A_perturb(this_run_name, run_old, this_run_label, data_PR, bcs_funcs);
% 
% end

%--------------------%
%     Test Plots     %
%--------------------%
% Plot PTC plane in A_perturb
% plot_PTC_plane_A_perturb(run_new, save_figure);

%=========================================================================%
%                               END OF FILE                               %
%=========================================================================%