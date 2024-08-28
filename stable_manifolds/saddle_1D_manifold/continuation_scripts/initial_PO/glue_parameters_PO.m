function prob_out = glue_parameters_PO(prob_in)
  % prob_out = glue_parameters_PO(prob_in)
  %
  % Glue the parameters of the EP segments and PO segment together 
  % (as they're all the same anyway).

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
  [data1, uidx1] = coco_get_func_data(prob, 'xpos.ep', 'data', 'uidx');
  [data2, uidx2] = coco_get_func_data(prob, 'xneg.ep', 'data', 'uidx');
  [data3, uidx3] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');

  % Index mapping
  maps = data.coll_seg.maps;
  % maps_var = data_var.coll_var;
  maps1 = data1.ep_eqn;
  maps2 = data2.ep_eqn;
  maps3 = data3.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx), uidx1(maps1.p_idx));
  prob = coco_add_glue(prob, 'glue_p2', uidx(maps.p_idx), uidx2(maps2.p_idx));
  prob = coco_add_glue(prob, 'glue_p3', uidx(maps.p_idx), uidx3(maps3.p_idx));

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end