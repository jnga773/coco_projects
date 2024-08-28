function prob_out = apply_PO_boundary_conditions(prob_in, bcs_PO_in)
  % prob_out = apply_PO_boundary_conditions(prob_in)
  %
  % Glue the COLL and EP parameters together, and apply the 'new'
  % periodic orbit boundary conditions.

  %---------------%
  %     Input     %
  %---------------%
  % Input continuation problem structure
  prob = prob_in;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read index data for the stable periodic orbit segment
  [data_s, uidx_s] = coco_get_func_data(prob, 'PO_stable.coll', 'data', 'uidx');
  [data_s_var, uidx_s_var] = coco_get_func_data(prob, 'PO_stable.coll.var', 'data', 'uidx');
  % Index mapping
  maps_s     = data_s.coll_seg.maps;
  maps_s_var = data_s_var.coll_var;

  % Read index data for equilibrium points
  [data_pos, uidx_pos] = coco_get_func_data(prob, 'xpos.ep', 'data', 'uidx');
  [data_neg, uidx_neg] = coco_get_func_data(prob, 'xneg.ep', 'data', 'uidx');
  [data_0, uidx_0] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');
  % Index mapping
  maps_pos   = data_pos.ep_eqn;
  maps_neg   = data_neg.ep_eqn;
  maps_0     = data_0.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'pars_glue', ...
                       [uidx_s(maps_s.p_idx); uidx_s(maps_s.p_idx); uidx_s(maps_s.p_idx)], ...
                       [uidx_0(maps_0.p_idx); uidx_pos(maps_pos.p_idx); uidx_neg(maps_neg.p_idx)]);

  %-----------------------------%
  %     Boundary Conditions     %
  %-----------------------------%
  % Apply periodic orbit boundary conditions and special phase condition
  prob = coco_add_func(prob, 'bcs_PO', bcs_PO_in{:}, data_s, 'zero', 'uidx', ...
                       uidx_s([maps_s.x0_idx(1:data_s.xdim); ...
                               maps_s.x1_idx(1:data_s.xdim); ...
                               maps_s.p_idx(1:data_s.pdim)]));

  %------------------------%
  %     Add Parameters     %
  %------------------------%
  % Add variational problem matrix parameters
  prob = coco_add_pars(prob, 'pars_var_stable', ...
                       uidx_s_var(maps_s_var.v0_idx,:), ...
                       {'vars1', 'vars2', 'vars3', ...
                        'vars4', 'vars5', 'vars6', ...
                        'vars7', 'vars8', 'vars9'});

  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end