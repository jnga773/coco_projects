function prob_out = apply_manifold_conditions(prob_in, data_in, bcs_funcs_in, vec_floquet_in, lam_floquet_in, epsilon_in)
  % prob_out = apply_manifold_conditions(prob_in, data_in, vec_floquet_in, lam_floquet_in, epsilon_in)
  %
  % Encoding of the initial and final boundary conditions of the two trajectory segments.
  % 
  % The boundary conditions are applied as added monitor functions,
  % with inactive parameters 'seg_u' and 'seg_s', which monitor the
  % distance of the trajectory segment from the defined point on the
  % \Sigma plane, for the unstable and stable manifolds, respectively.
  %
  % The system parameters are also added, with the coco_glue function
  % setting the parameters of each segment to be the same.
  % 
  % The epsilon distance parameters are then saved into the data_in
  % structure such that they can be called in sucessive runs.
  %
  % Finally, COCO events are added for when the trajectory segments
  % hit the \Sigma plane, i.e., when 'seg_u' or 'seg_s' = 0.
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure containing boundary condition information.
  % bcs_funcs_in : structure
  %     Data structure containing lists of boundary condition functions.
  % epsilon_in : array (floats)
  %     Array of separations at end points from orbit and equilibrium.
  %
  % Output
  % ----------
  % prob_out : COCO problem structure
  %     Continuation problem structure.

  %---------------%
  %     Input     %
  %---------------%
  % List of functions
  bcs_initial = bcs_funcs_in.bcs_initial;
  bcs_final   = bcs_funcs_in.bcs_final;
  bcs_eig     = bcs_funcs_in.bcs_eig;

  % Set the COCO problem
  prob = prob_in;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for the unstable
  % and stable manfiolds.
  [data_u, uidx_u] = coco_get_func_data(prob, 'unstable.coll', 'data', 'uidx');
  [data_s, uidx_s] = coco_get_func_data(prob, 'stable.coll', 'data', 'uidx');
  % Data and index array for periodic orbit segment
  [data_p, uidx_p] = coco_get_func_data(prob, 'hopf_po.po.orb.coll', 'data', 'uidx');
  % Data and index array for fundamental solution associated with orbit
  [data_f, uidx_f] = coco_get_func_data(prob, 'hopf_po.po.orb.coll.var', 'data', 'uidx');

  % Extract toolbox data and indices for equilibrium point bit
  [data_0, uidx_0] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

  % Grab the indices from data_u and data_s
  maps_u  = data_u.coll_seg.maps;
  maps_s  = data_s.coll_seg.maps;
  maps_p = data_p.coll_seg.maps;
  maps_f = data_f.coll_var;
  maps_0 = data_0.ep_eqn;

  %-----------------------------------------------------%
  %     Glue Trajectory Segment Parameters Together     %
  %-----------------------------------------------------%
  % Both segments have the same system parameters, so glue them together
  prob = coco_add_glue(prob, 'shared', ...
                       uidx_u(maps_u.p_idx), uidx_s(maps_s.p_idx));
  % Glue the periodic orbit parameters too
  prob = coco_add_glue(prob, 'shared_PO', ...
                       uidx_u(maps_u.p_idx), uidx_p(maps_p.p_idx));
  % Glue equilibrium point segment parameters too
  prob = coco_add_glue(prob, 'shared_ep', ...
                       uidx_u(maps_u.p_idx), uidx_0(maps_0.p_idx));

  %----------------------------------------%
  %     Eigenvalue Boundary Conditions     %
  %----------------------------------------%
  % Add state- and parameter-space dimensions to input data structure
  data_in.xdim = data_u.xdim;
  data_in.pdim = data_u.pdim;

  % % Data structure containing the toolbox id for the monodromy matrix data
  % data_eig.tbid = 'hopf_po.po.orb.coll';

  % Apply the boundary conditions for the eigenvalues and eigenvectors of the
  % monodromy matrix
  prob = coco_add_func(prob, 'bcs_eig', bcs_eig{:}, data_in, ...
                       'zero', 'uidx', ...
                       [uidx_f(maps_f.v1_idx(:, 1)); ...
                        uidx_f(maps_f.v1_idx(:, 2)); ...
                        uidx_f(maps_f.v1_idx(:, 3))], ...
                       'u0', [vec_floquet_in; lam_floquet_in]);

  % Get u-vector indices from this coco_add_func call, including the extra
  % indices from the added "vec_floquet" and "lam_floquet".
  uidx_eig = coco_get_func_data(prob, 'bcs_eig', 'uidx');

  % Grab eigenvector and value indices from u-vector [vec_floquet, lam_floquet]
  data_out.vec_floquet_idx = [numel(uidx_eig)-3; numel(uidx_eig)-2; numel(uidx_eig)-1];
  data_out.lam_floquet_idx = numel(uidx_eig);

  % Save data
  prob = coco_add_slot(prob, 'bcs_eig', @coco_save_data, data_out, 'save_full');

  %-------------------------------------%
  %     Initial Boundary Conditions     %
  %-------------------------------------%
  % Add state- and parameter-space dimensions to input data structure
  data_in.xdim = data_u.xdim;
  data_in.pdim = data_u.pdim;

  % Apply the boundary conditions for the initial points near the equilibrium
  prob = coco_add_func(prob, 'bcs_initial', bcs_initial{:}, data_in, ...
                       'zero', 'uidx', ...
                       [uidx_u(maps_u.x0_idx); ...
                        uidx_s(maps_s.x1_idx); ...
                        uidx_p(maps_p.xbp_idx(end-data_p.xdim+1:end)); ...
                        uidx_0(maps_0.x_idx); ...
                        uidx_p(maps_p.p_idx); ...
                        uidx_eig(data_out.vec_floquet_idx)], ...
                       'u0', epsilon_in);

  % Get u-vector indices from this coco_add_func call
  uidx_eps = coco_get_func_data(prob, 'bcs_initial', 'uidx');

  % Grab epsilon parameters indices
  epsilon_idx = [numel(uidx_eps) - 1; numel(uidx_eps)];
  data_out.epsilon_idx = epsilon_idx;

  % Save data
  prob = coco_add_slot(prob, 'bcs_initial', @coco_save_data, data_out, 'save_full');

  %-----------------------------------%
  %     Final Boundary Conditions     %
  %-----------------------------------%
  % Add state- and parameter-space dimensions to input data structure
  data_in.xdim = data_u.xdim;
  data_in.pdim = data_u.pdim;
  
  % Append hyperplane conditions with parameters 'seg_u' and 'seg_s' for the unstable
  % and stable segments, respectively.
  prob = coco_add_func(prob, 'bcs_final', bcs_final{:}, data_in, ...
                       'inactive', {'seg_u', 'seg_s'}, ...
                       'uidx', [uidx_u(maps_u.x1_idx); uidx_s(maps_s.x0_idx)]);

  %-----------------------------------%
  %     Define Problem Parameters     %
  %-----------------------------------%
  % % Define system parameters
  % prob = coco_add_pars(prob, 'pars_system', ...
  %                      uidx_u(maps_u.p_idx), ...
  %                      {data_in.pnames{:}});

  % Define epsilon parameters
  prob = coco_add_pars(prob, 'pars_eps', ...
                       uidx_eps(epsilon_idx), ...
                       {'eps1', 'eps2'});

  % Define trajectory periods
  prob = coco_add_pars(prob, 'pars_T', ...
                       [uidx_u(maps_u.T_idx); uidx_s(maps_s.T_idx)], ...
                       {'T1', 'T2'});

  % Add parameters for each component of the monodromy matrix
  prob = coco_add_pars(prob, 'pars', ...
                       uidx_f(maps_f.v0_idx,:), ...
                       {'s1', 's2', 's3', ...
                        's4', 's5', 's6', ...
                        's7', 's8', 's9'});

  %--------------------------------------------%
  %     Add Event for Hitting \Sigma Plane     %
  %--------------------------------------------%
  % Add event for when trajectory hits \Sigma plane
  prob = coco_add_event(prob, 'DelU', 'seg_u', 0);
  prob = coco_add_event(prob, 'DelS', 'seg_s', 0);

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end