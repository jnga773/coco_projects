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
  [data, uidx] = coco_get_func_data(prob, 'initial_PO.coll', 'data', 'uidx');

  % Read index data for equilibrium points
  [data1, uidx1] = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

  % Index mapping
  maps     = data.coll_seg.maps;
  maps1    = data1.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx), uidx1(maps1.p_idx));

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Apply periodic orbit boundary conditions and special phase condition
  prob = coco_add_func(prob, 'bcs_po', bcs_PO_in{:}, data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(1:data.xdim); ...
                             maps.x1_idx(1:data.xdim); ...
                             maps.p_idx(1:data.pdim)]));
  
  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end