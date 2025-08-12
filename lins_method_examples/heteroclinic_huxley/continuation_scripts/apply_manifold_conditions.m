function prob_out = apply_manifold_conditions(prob_in, data_in, bcs_funcs_in, epsilon_in)
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
  % Parameters
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
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Continuation problem structure.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_glue, coco_add_func, coco_add_slot,
  % coco_add_pars, coco_add_event, coco_save_data

  %---------------%
  %     Input     %
  %---------------%
  % List of functions
  bcs_initial = bcs_funcs_in.bcs_initial;
  bcs_final   = bcs_funcs_in.bcs_final;

  % Set the COCO problem
  prob = prob_in;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for the unstable
  % and stable manfiolds.
  [data_u, uidx_u] = coco_get_func_data(prob, 'unstable.coll', 'data', 'uidx');
  [data_s, uidx_s] = coco_get_func_data(prob, 'stable.coll', 'data', 'uidx');

  % % Extract toolbox data and indices for equilibrium point bit
  [data_0u, uidx_0u] = coco_get_func_data(prob, 'x0_u.ep', 'data', 'uidx');
  [data_0s, uidx_0s] = coco_get_func_data(prob, 'x0_s.ep', 'data', 'uidx');

  % Grab the indices from data_u and data_s
  maps_u  = data_u.coll_seg.maps;
  maps_s  = data_s.coll_seg.maps;
  maps_0u = data_0u.ep_eqn;
  maps_0s = data_0s.ep_eqn;

  %-----------------------------------------------------%
  %     Glue Trajectory Segment Parameters Together     %
  %-----------------------------------------------------%
  % Both segments have the same system parameters, so glue them together
  prob = coco_add_glue(prob, 'shared', ...
                       uidx_u(maps_u.p_idx), uidx_s(maps_s.p_idx));
  % Glue equilibrium point segment parameters too
  prob = coco_add_glue(prob, 'shared_ep_u', ...
                       uidx_u(maps_u.p_idx), uidx_0u(maps_0u.p_idx));
  prob = coco_add_glue(prob, 'shared_ep_s', ...
                       uidx_u(maps_u.p_idx), uidx_0s(maps_0s.p_idx));

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
                        uidx_0u(maps_0u.x_idx); ...
                        uidx_0s(maps_0s.x_idx); ...
                        uidx_u(maps_u.p_idx)], ...
                       'u0', epsilon_in);

  % Get u-vector indices from this coco_add_func call
  uidx_eps = coco_get_func_data(prob, 'bcs_initial', 'uidx');

  % Grab epsilon parameters indices
  epsilon_idx = [numel(uidx_eps) - 1; numel(uidx_eps)];
  data.epsilon_idx = epsilon_idx;

  % Save data
  prob = coco_add_slot(prob, 'bcs_initial', @coco_save_data, data, 'save_full');

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
  % Define system parameters
  prob = coco_add_pars(prob, 'pars_system', ...
                       uidx_u(maps_u.p_idx), ...
                       {data_in.pnames{:}});

  % Define epsilon parameters
  prob = coco_add_pars(prob, 'pars_eps', ...
                       uidx_eps(epsilon_idx), ...
                       {'eps1', 'eps2'});

  % Define trajectory periods
  prob = coco_add_pars(prob, 'pars_T', ...
                       [uidx_u(maps_u.T_idx); uidx_s(maps_s.T_idx)], ...
                       {'T1', 'T2'});

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