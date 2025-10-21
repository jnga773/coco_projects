function prob_out = apply_boundary_conditions_PR(prob_in, bcs_funcs_in)
  % prob_out = apply_boundary_conditions_PR(prob_in)
  %
  % Applies the various boundary conditions, adds monitor functions
  % for the singularity point, glue parameters and other things
  % together, and also adds some user defined points. Also
  % applied some COCO settings to the continuation problem.
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  %     for the segments.
  % bcs_funcs_in : list of functions
  %     List of all of the boundary condition functions for each
  %     phase resetting segment.
  %
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Continuation problem structure.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_glue, coco_add_func, coco_add_pars

  %-----------------------%
  %     Default Input     %
  %-----------------------%
  arguments
    prob_in struct
    bcs_funcs_in struct
  end

  %---------------%
  %     Input     %
  %---------------%
  % Set the COCO problem
  prob = prob_in;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for each of the orbit
  % segments.
  [data1, uidx1]  = coco_get_func_data(prob, 'seg1.coll', 'data', 'uidx');
  [data2, uidx2]  = coco_get_func_data(prob, 'seg2.coll', 'data', 'uidx');
  [data3, uidx3]  = coco_get_func_data(prob, 'seg3.coll', 'data', 'uidx');
  [data4, uidx4]  = coco_get_func_data(prob, 'seg4.coll', 'data', 'uidx');

  % Read index data equilibrium points
  [data_EP, uidx_EP] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');

  % Grab the indices from each of the orbit segments
  maps1   = data1.coll_seg.maps;
  maps2   = data2.coll_seg.maps;
  maps3   = data3.coll_seg.maps;
  maps4   = data4.coll_seg.maps;
  % Grab the indices from the equilibrium point
  maps_EP = data_EP.ep_eqn;

  %----------------------------------------%
  %     Glue Trajectory Segment Things     %
  %----------------------------------------%
  % "Glue" segment periods together
  prob = coco_add_glue(prob, 'glue_T', ...
                       [uidx1(maps1.T_idx); uidx1(maps1.T_idx); uidx1(maps1.T_idx)], ...
                       [uidx2(maps2.T_idx); uidx3(maps3.T_idx); uidx4(maps4.T_idx)]);
  % "Glue" segment parameters together
  prob = coco_add_glue(prob, 'glue_pars', ...
                       [uidx1(maps1.p_idx); uidx1(maps1.p_idx); uidx1(maps1.p_idx)], ...
                       [uidx2(maps2.p_idx); uidx3(maps3.p_idx); uidx4(maps4.p_idx)]);
  % "Glue" segment and equilibrium point parameters together
  prob = coco_add_glue(prob, 'glue_x0', uidx1(maps1.p_idx(1:data_EP.pdim)), uidx_EP(maps_EP.p_idx));

  %---------------------------------%
  %     Add Boundary Conditions     %
  %---------------------------------%
  % Boundary condition function list
  bcs_T  = bcs_funcs_in.bcs_T;
  bcs_PR = bcs_funcs_in.bcs_PR;

  % Add boundary conditions for segment periods
  prob = coco_add_func(prob, 'bcs_T', bcs_T{:}, [], 'zero', 'uidx', ...
                       uidx1(maps1.T_idx));

  % Add boundary conditions for four segments
  prob = coco_add_func(prob, 'bcs_PR', bcs_PR{:}, data_EP, 'zero', 'uidx', ...
                       [uidx1(maps1.x0_idx);
                        uidx2(maps2.x0_idx);
                        uidx3(maps3.x0_idx);
                        uidx4(maps4.x0_idx);
                        uidx1(maps1.x1_idx);
                        uidx2(maps2.x1_idx);
                        uidx3(maps3.x1_idx);
                        uidx4(maps4.x1_idx);
                        uidx1(maps1.p_idx)]);
                        
  %------------------------%
  %     Add Parameters     %
  %------------------------%
  % Set isochron parameter names
  for idx = 1 : numel(maps4.x0_idx)
    pname_isochron{idx} = sprintf('iso%d', idx);
  end

  % Add isochron parameters
  prob = coco_add_pars(prob, 'pars_isochron', ...
                      uidx4(maps4.x0_idx), pname_isochron, ...
                      'active');

  %----------------%
  %     Output     %
  %----------------%
  % Output problem structure
  prob_out = prob;

end