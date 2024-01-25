%-------------------------------------------------------------------------%
%%            Compute Floquet Bundle at Zero Phase Point (mu)            %%
%-------------------------------------------------------------------------%
% We now add the adjoint function and Floquet boundary conditions to
% compute the adjoint (left or right idk) eigenvectors and eigenvalues.
% This will give us the perpendicular vector to the tangent of the periodic
% orbit. However, this will only be for the eigenvector corresponding to
% the eigenvalue \mu = 1. Hence, here we continue in \mu (mu_f) until
% mu_f = 1.

%------------------%
%     Run Name     %
%------------------%
% Current run name
run_new = run_names.compute_floquet_1;
% Which run this continuation continues from
run_old = run_names.initial_coll;

% Continuation point
label_old = 1;

% Print to console
fprintf("~~~ Second Run (ode_isol2bvp) ~~~ \n");
fprintf('Calculate Floquet bundle (mu) \n');
fprintf('Run name: %s \n', run_new);
fprintf('Continuing from point %d in run: %s \n', label_old, run_old);

%--------------------------%
%     Calculate Things     %
%--------------------------%
data_adjoint = calc_initial_solution_adjoint_problem(run_old, label_old);

%------------------------------------%
%     Setup Floquet Continuation     %
%------------------------------------%
% Set up the COCO problem
prob = coco_prob();

% Set PtMX
prob = coco_set(prob, 'cont', 'PtMX', 1500);
% Set NTST
prob = coco_set(prob, 'coll', 'NTST', 50);
% Set tolerance
prob= coco_set(prob, 'corr', 'TOL', 5e-7);

% % Kyoung's original BVP method
% % Set initial solution to boundary value problem (BVP)
% prob = ode_isol2bvp(prob, '', @floquet_adjoint_BVP, ...
%                     data_adjoint_BVP.t0, data_adjoint_BVP.x0, ...
%                     data_adjoint_BVP.p0, data_adjoint_BVP.pnames, ...
%                     @bcs_floquet_BVP);

% Add segment as initial solution
prob = ode_isol2coll(prob, 'adjoint', @floquet_adjoint, ...
                     data_adjoint.t0, data_adjoint.x0, ...
                     data_adjoint.pnames, data_adjoint.p0);

% Read function data and u-vector indices
[data, uidx] = coco_get_func_data(prob, 'adjoint.coll', 'data', 'uidx');
maps = data.coll_seg.maps;

% Apply periodic orbit boundary conditions
prob = coco_add_func(prob, 'bcs_po', @bcs_PO, data, 'zero', 'uidx', ...
                     uidx([maps.x0_idx(1:2); ...
                           maps.x1_idx(1:2); ...
                           maps.p_idx(1:2)]));

% Apply adjoint boundary conditions
prob = coco_add_func(prob, 'bcs_adjoint', @bcs_floquet, data, 'zero', 'uidx', ...
                     uidx([maps.x0_idx(3:4); ...
                           maps.x1_idx(3:4); ...
                           maps.p_idx(3:4)]));

% Run COCO
coco(prob, run_new, [], 1, {'mu_f', 'w_norm'} , [0.0, 1.1]);

%-------------------------------------------------------------------------%
%%                             Testing Stuff                             %%
%-------------------------------------------------------------------------%
function data_out = calc_initial_solution_adjoint_problem(run_in, label_in)
  % data_out = calc_initial_solution_adjoint_problem(run_in, label_in);
  %
  % Calculates and sets the initial solution to solve for the adjoint problem

  %-----------------------%
  %     Read Solution     %
  %-----------------------%
  % Read previous solution
  [sol, data] = coll_read_solution('initial_PO', run_in, label_in);

  % Dimensions
  xdim = data.xdim;
  pdim = data.pdim;

  % State solution
  xbp = sol.xbp;

  % Temporal data
  tbp = sol.tbp;

  % Initial parameter space
  p_OG = sol.p;
  % Initial parameter names
  pnames_OG = data.pnames;

  % Initial v;alues of eigenvalues and norm
  mu_f   = 0.9;
  w_norm = 0.0;

  % Extend the parameter space
  p_out = [p_OG; mu_f; w_norm];

  % Extend the parameter names
  pnames_out = pnames_OG;
  pnames_out{pdim+1} = 'mu_f';
  pnames_out{pdim+2} = 'w_norm';

  % % Elementary unit vector
  % e = eye(xdim);
  % e1 = e(:, 1);

  %----------------%
  %     Output     %
  %----------------%
  % Initial temporal solution
  data_out.t0 = tbp;

  % Initial state solution. First two columns correspond to the
  % periodic orbit, the third column corresponds to the eigenvalue
  % mu_f, and the last column corresponds to the norm of w.
  data_out.x0 = [xbp, zeros(length(tbp), xdim)];

  % Parameters
  data_out.p0     = p_out;
  data_out.pnames = pnames_out';
  
  % % Elementary unit vector
  % data_out.e1 = e1;

end