function prob_out = glue_conditions(prob_in, data_in, epsilon_in)
  % prob_out = glue_conditions(prob_in, data_in, vec_floquet_in, lam_floquet_in, epsilon_in)
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
  % vec_floquet_in : array (floats)
  %     Stable Floquet eigenvector.
  % lam_floquet_in : float
  %     Stable Floquet eigenvalue.
  % epsilon_in : array (floats)
  %     Array of separations at end points from orbit and equilibrium.
  %
  % Output
  % ----------
  % prob_out : COCO problem structure
  %     Continuation problem structure.

  % Set the COCO problem
  prob = prob_in;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for the unstable
  % and stable manfiolds.
  [data_u, uidx_u] = coco_get_func_data(prob, 'unstable.coll', 'data', 'uidx');
  [data_s, uidx_s] = coco_get_func_data(prob, 'stable.coll', 'data', 'uidx');

  % Grab the indices from data_u and data_s
  maps_u = data_u.coll_seg.maps;
  maps_s = data_s.coll_seg.maps;

  % uidx_u(maps_u.x0_idx) - u-vector indices for the initial point of the
  %                         unstable manifold trajectory segment - x_u(0).
  % uidx_u(maps_u.x1_idx) - u-vector indices for the final point of the
  %                         unstable manifold trajectory segment - x_u(T1).

  % uidx_s(maps_s.x0_idx) - u-vector indices for the initial point of the
  %                         stable manifold trajectory segment - x_s(0).
  % uidx_s(maps_s.x1_idx) - u-vector indices for the final point of the
  %                         stable manifold trajectory segment - x_s(T2).

  % uidx_u(maps_u.p_idx)  - u-vector indices for the system parameters.
  % uidx_u(maps_u.T_idx)  - u-vector index for the period of the unstable
  %                         manifold trajectory segment.
  % uidx_s(maps_s.T_idx)  - u-vector index for the period of the stable
  %                         manifold trajectory segment.

  %-----------------------------------------------------%
  %     Glue Trajectory Segment Parameters Together     %
  %-----------------------------------------------------%
  % Both segments have the same system parameters, so "glue" them together,
  % i.e., let COCO know that they are the same thing.
  prob = coco_add_glue(prob, 'shared', ...
                       uidx_u(maps_u.p_idx), uidx_s(maps_s.p_idx));

  %-------------------------------------%
  %     Initial Boundary Conditions     %
  %-------------------------------------%
  % Apply the boundary conditions for the initial points near the equilibrium.
  % Here, epsilon_in is appended as an input to the u-vector input for the function
  % @boundary_conditions_initial.
  prob = coco_add_func(prob, 'bcs_initial', @boundary_conditions_initial, data_in, 'zero', 'uidx', ...
                       [uidx_u(maps_u.x0_idx); ...
                        uidx_s(maps_s.x1_idx); ...
                        uidx_u(maps_u.p_idx)], ...
                       'u0', epsilon_in);

  % Get u-vector indices from this coco_add_func call, including the extra
  % indices from the added "epsilon_in"
  uidx_eps = coco_get_func_data(prob, 'bcs_initial', 'uidx');

  % Grab epsilon parameters indices from u-vector [eps1, eps2]
  epsilon_idx = [numel(uidx_eps) - 1; numel(uidx_eps)];
  data.epsilon_idx = epsilon_idx;

  % Save data structure to be called later with coco_get_func_data 
  prob = coco_add_slot(prob, 'bcs_initial', @coco_save_data, data, 'save_full');

  %-----------------------------------%
  %     Final Boundary Conditions     %
  %-----------------------------------%
  % Append hyperplane conditions with parameters 'seg_u' and 'seg_s' for the unstable
  % and stable segments, respectively.
  prob = coco_add_func(prob, 'bcs_final', @boundary_conditions_final, data_in, ...
                       'inactive', {'seg_u', 'seg_s'}, ...
                       'uidx', [uidx_u(maps_u.x1_idx); uidx_s(maps_s.x0_idx)]);

  %-----------------------------------%
  %     Define Problem Parameters     %
  %-----------------------------------%
  % Define system parameters
  prob = coco_add_pars(prob, 'pars_system', ...
                       uidx_u(maps_u.p_idx), ...
                       {data_in.pnames});

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
  % Add event for when trajectory hits \Sigma plane for unstable and stable manifolds.
  prob = coco_add_event(prob, 'DelU', 'seg_u', 0);
  prob = coco_add_event(prob, 'DelS', 'seg_s', 0);

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end