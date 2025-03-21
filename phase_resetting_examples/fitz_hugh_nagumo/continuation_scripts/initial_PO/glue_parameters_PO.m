function prob_out = glue_parameters_PO(prob_in)
  % prob_out = glue_parameters_PO(prob_in)
  %
  % Glue the parameters of the EP segments and PO segment together 
  % (as they're all the same anyway).
  % This function reads index data for the periodic orbit segment and equilibrium points,
  % and glues the parameters together.
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Input continuation problem structure.
  %
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Output continuation problem structure with applied boundary conditions.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_glue

  %---------------%
  %     Input     %
  %---------------%
  % Input continuation problem structure
  prob = prob_in;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read index data periodic orbit segment
  [data, uidx] = coco_get_func_data(prob, 'po.orb.coll', 'data', 'uidx');

  % Read index data equilibrium points
  [data_x0, uidx_x0] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');

  % Index mapping
  maps = data.coll_seg.maps;
  % maps_var = data_var.coll_var;
  maps_x0 = data_x0.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx), uidx_x0(maps_x0.p_idx));

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end