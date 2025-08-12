function prob_out = apply_boundary_conditions_PO(prob_in, bcs_PO_in)
  % prob_out = apply_boundary_conditions_PO(prob_in)
  %
  % This function reads index data for the stable periodic orbit segment and equilibrium points,
  % glues the COLL and EP parameters together, applies periodic orbit boundary conditions.
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Input continuation problem structure.
  % bcs_PO_in : List of functions
  %     List of boundary conditions for the periodic orbit.
  %
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Output continuation problem structure with applied boundary conditions.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_glue, coco_add_func, coco_add_pars

  %---------------%
  %     Input     %
  %---------------%
  % Input continuation problem structure
  prob = prob_in;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read index data for periodic orbit segment
  [data_PO, uidx_PO] = coco_get_func_data(prob, 'initial_PO.coll', 'data', 'uidx');

  % Read index data for equilibrium points
  [data_x0, uidx_x0] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

  % Index mapping
  maps_PO = data_PO.coll_seg.maps;
  maps_x0 = data_x0.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx_PO(maps_PO.p_idx), uidx_x0(maps_x0.p_idx));

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Apply periodic orbit boundary conditions and special phase condition
  prob = coco_add_func(prob, 'bcs_po', bcs_PO_in{:}, data_PO, 'zero', 'uidx', ...
                       uidx_PO([maps_PO.x0_idx; ...
                                maps_PO.x1_idx; ...
                                maps_PO.p_idx]));
  
  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end