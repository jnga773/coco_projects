function prob_out = apply_boundary_conditions_Wsq(prob_in, bcs_funcs_in, eps_in)
  % prob_out = apply_boundary_conditions_Wsq(prob_in, bcs_funcs_in, eps_in)
  %
  % This function reads index data for the stable periodic orbit segment and equilibrium points, glues the COLL and EP parameters together, applies periodic orbit boundary conditions, and adds variational problem matrix parameters.
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Input continuation problem structure.
  % bcs_funcs_in : List of functions
  %     Structure containing boundary condition functions.
  % eps_in : double
  %     Epsilon parameter for boundary conditions.
  %
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Output continuation problem structure with applied boundary conditions.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_glue, coco_add_func, coco_add_pars

  % Set the COCO problem
  prob = prob_in;

  % Boundary condition function list
  % bcs_eig     = bcs_funcs_in.bcs_eig;
  bcs_initial = bcs_funcs_in.bcs_initial;
  bcs_final   = bcs_funcs_in.bcs_final;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for the two segments
  % and the stationary point.
  [data1, uidx1] = coco_get_func_data(prob, 'W1.coll', 'data', 'uidx');
  [data2, uidx2] = coco_get_func_data(prob, 'W2.coll', 'data', 'uidx');
  % Index mapping
  maps1 = data1.coll_seg.maps;
  maps2 = data2.coll_seg.maps;

  % Read index data for the stable periodic orbit segment
  [data_s, uidx_s] = coco_get_func_data(prob, 'PO_stable.po.orb.coll', 'data', 'uidx');
  % Index mapping
  maps_s     = data_s.coll_seg.maps;

  % Read index data for equilibrium points
  [data_pos, uidx_pos] = coco_get_func_data(prob, 'xpos.ep', 'data', 'uidx');
  [data_neg, uidx_neg] = coco_get_func_data(prob, 'xneg.ep', 'data', 'uidx');
  [data_0, uidx_0] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');
  % Index mapping
  maps_pos   = data_pos.ep_eqn;
  maps_neg   = data_neg.ep_eqn;
  maps_0     = data_0.ep_eqn;

  %-----------------------------------------------------%
  %     Glue Trajectory Segment Parameters Together     %
  %-----------------------------------------------------%
  % All segments have the same system parameters, so "glue" them together,
  % i.e., let COCO know that they are the same thing.
  prob = coco_add_glue(prob, 'pars_glue', ...
                       [uidx_s(maps_s.p_idx); ...
                        uidx_s(maps_s.p_idx); uidx_s(maps_s.p_idx); ...
                        uidx_s(maps_s.p_idx); uidx_s(maps_s.p_idx)], ...
                       [uidx_0(maps_0.p_idx); ...
                        uidx_pos(maps_pos.p_idx); uidx_neg(maps_neg.p_idx); ...
                        uidx1(maps1.p_idx); uidx2(maps2.p_idx)]);

  %-------------------------------------%
  %     Initial Boundary Conditions     %
  %-------------------------------------%
  % Append hyperplane conditions with parameters 'seg_u' and 'seg_s' for the unstable
  % and stable segments, respectively.
  prob = coco_add_func(prob, 'bcs_initial', bcs_initial{:}, data1, ...
                       'inactive', {'W_seg1', 'W_seg2'}, 'uidx', ...
                       [uidx1(maps1.x0_idx); ...
                        uidx2(maps2.x0_idx)]);

  %-----------------------------------%
  %     Final Boundary Conditions     %
  %-----------------------------------%
  % Apply the boundary conditions for the initial points near the equilibrium.
  % Here, epsilon_in is appended as an input to the u-vector input for the function
  % @bcs_initial.
  prob = coco_add_func(prob, 'bcs_final', bcs_final{:}, data_pos.data, 'zero', 'uidx', ...
                       [uidx1(maps1.x1_idx); ...
                        uidx2(maps2.x1_idx); ...
                        uidx_pos(maps_pos.x_idx)], ...
                       'u0', eps_in);

  % Get u-vector indices from this coco_add_func call, including the extra
  % indices from the added "eps"
  uidx_eps = coco_get_func_data(prob, 'bcs_final', 'uidx');
  
  % Grab eigenvector and value indices from u-vector [eps]
  data_out.eps_idx = numel(uidx_eps);
  
  % Save data
  prob = coco_add_slot(prob, 'bcs_final', @coco_save_data, data_out, 'save_full');

  %-----------------------------------%
  %     Define Problem Parameters     %
  %-----------------------------------%
  % Define trajectory periods
  prob = coco_add_pars(prob, 'pars_T', ...
                       [uidx1(maps1.T_idx); uidx2(maps2.T_idx)], {'T1', 'T2'}, ...
                       'inactive');

  % Define epsilon parameters
  prob = coco_add_pars(prob, 'pars_eps', ...
                       uidx_eps(data_out.eps_idx), 'eps', ...
                       'inactive');

  %----------------%
  %     Output     %
  %----------------%
  % Output problem structure
  prob_out = prob;

end