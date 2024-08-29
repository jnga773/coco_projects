function prob_out = apply_PO_boundary_conditions(prob_in, bcs_PO_in)
  % prob_out = apply_PO_boundary_conditions(prob_in)
  %
  % Glue the parameters of the EP segments and PO segment together 
  % (as they're all the same anyway)

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

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Apply periodic orbit boundary conditions and special phase condition
  prob = coco_add_func(prob, 'bcs_po', bcs_PO_in{:}, data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(1:data.xdim); ...
                             maps.x1_idx(1:data.xdim); ...
                             maps.p_idx(1:data.pdim)]));

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx), uidx1(maps1.p_idx));
  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end