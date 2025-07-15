function prob_out = glue_parameters_PO(prob_in, floquet)
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

  %-------------------%
  %     Arguments     %
  %-------------------%
  arguments
    prob_in struct
    floquet logical = false % Optional argument to add Floquet bundle parameters
  end

  %---------------%
  %     Input     %
  %---------------%
  % Input continuation problem structure
  prob = prob_in;

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read index data periodic orbit segment
  [data, uidx] = coco_get_func_data(prob, 'PO_stable.po.orb.coll', 'data', 'uidx');

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

  %------------------------%
  %     Floquet Bundle     %
  %------------------------%
  if floquet
    % Read index data for the Floquet bundle
    [data_var, uidx_var] = coco_get_func_data(prob, 'PO_stable.po.orb.coll.var', 'data', 'uidx');
    % Index mapping
    maps_var = data_var.coll_var;
    % Add variational problem matrix parameters
    prob = coco_add_pars(prob, 'pars_var_unstable', ...
                        uidx_var(maps_var.v0_idx,:), ...
                        {'var1', 'var2', 'var3', ...
                          'var4', 'var5', 'var6', ...
                          'var7', 'var8', 'var9'});
  end


  %----------------%
  %     Output     %
  %----------------%
  prob_out = prob;

end