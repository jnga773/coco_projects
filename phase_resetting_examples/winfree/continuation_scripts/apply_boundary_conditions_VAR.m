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
  [data, uidx] = coco_get_func_data(prob, 'adjoint.coll', 'data', 'uidx');
  % Read index data equilibrium points
  [data_x0, uidx_x0] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');

  % Read index mappings from data
  maps = data.coll_seg.maps;
  % maps_var = data_var.coll_var;
  maps_x0 = data_x0.ep_eqn;

  % Dimensions of original structure
  xdim = data_x0.xdim;
  pdim = data_x0.pdim;

  %-------------------------%
  %     Glue Parameters     %
  %-------------------------%
  prob = coco_add_glue(prob, 'glue_p1', uidx(maps.p_idx(1:pdim)), uidx_x0(maps_x0.p_idx));

  %-----------------------------------%
  %     Apply Boundary Conditions     %
  %-----------------------------------%
  % Apply periodic orbit boundary conditions
  prob = coco_add_func(prob, 'bcs_po', bcs_funcs_in.bcs_PO{:}, data_x0, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(1:xdim); ...
                             maps.x1_idx(1:xdim); ...
                             maps.p_idx(1:pdim)]));

  % Apply adjoint boundary conditions
  prob = coco_add_func(prob, 'bcs_adjoint', bcs_funcs_in.bcs_VAR{:}, data_x0, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(xdim+1:end); ...
                             maps.x1_idx(xdim+1:end); ...
                             maps.p_idx(end-1:end)]));

  %----------------%
  %     Output     %
  %----------------%
  % Output CoCo problem structure
  prob_out = prob;

end