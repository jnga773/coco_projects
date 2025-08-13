function prob_out = apply_boundary_conditions_VAR(prob_in, bcs_funcs_in)
  % prob_out = apply_boundary_conditions_VAR(prob_in)
  %
  % Applies the boundary conditions for the rotated periodic orbit
  % (with function @bcs_PO) and for the Floquet bundle adjoint equation
  % with function (bcs_floquet).
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Input continuation problem structure.
  % bcs_funcs_in : List of functions
  %     List of boundary conditions for the periodic orbit and variational
  %     problem.
  %
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Output continuation problem structure with applied boundary conditions.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_func

  % Set the COCO problem
  prob = prob_in;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Read function data and u-vector indices
  [data_VAR, uidx_VAR] = coco_get_func_data(prob, 'adjoint.coll', 'data', 'uidx');
  % Read function data for equilibrium point
  [data_EP, uidx_EP]   = coco_get_func_data(prob, 'x0.ep', 'data', 'uidx');

  % Read index mappings from data
  maps_VAR = data_VAR.coll_seg.maps;
  maps_EP  = data_EP.ep_eqn;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  % Glue 'EP' and 'VAR' parameters together
  prob = coco_add_glue(prob, 'glue_par_VAR_EP', ...
                      uidx_VAR(maps_VAR.p_idx(1:data_EP.pdim)), ...
                      uidx_EP(maps_EP.p_idx));

  %-----------------------------------%
  %     Apply Boundary Conditions     %
  %-----------------------------------%
  % Apply periodic orbit boundary conditions
  prob = coco_add_func(prob, 'bcs_po', bcs_funcs_in.bcs_PO{:}, data_EP, 'zero', 'uidx', ...
                       uidx_VAR([maps_VAR.x0_idx(1:data_EP.xdim); ...
                                 maps_VAR.x1_idx(1:data_EP.xdim); ...
                                 maps_VAR.p_idx(1:data_EP.pdim)]));

  % Apply adjoint boundary conditions
  prob = coco_add_func(prob, 'bcs_VAR', bcs_funcs_in.bcs_VAR{:}, data_EP, 'zero', 'uidx', ...
                       uidx_VAR([maps_VAR.x0_idx(data_EP.xdim+1:end); ...
                                 maps_VAR.x1_idx(data_EP.xdim+1:end); ...
                                 maps_VAR.p_idx(end-1:end)]));

  %----------------%
  %     Output     %
  %----------------%
  % Output CoCo problem structure
  prob_out = prob;

end