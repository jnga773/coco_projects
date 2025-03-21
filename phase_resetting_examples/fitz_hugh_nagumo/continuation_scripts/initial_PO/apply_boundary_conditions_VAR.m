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

  % Read index mappings from data
  maps = data.coll_seg.maps;

  % Dimensions of original structure
  xdim = 0.5 * data.xdim;
  pdim = data.pdim - 3;

  % Save dimensions to be called in boundary condition functions
  dim_data.xdim = xdim;
  dim_data.pdim = pdim;

  %-----------------------------------%
  %     Apply Boundary Conditions     %
  %-----------------------------------%
  % Apply periodic orbit boundary conditions
  prob = coco_add_func(prob, 'bcs_po', bcs_funcs_in.bcs_PO{:}, dim_data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(1:xdim); ...
                             maps.x1_idx(1:xdim); ...
                             maps.p_idx(1:pdim)]));

  % Apply adjoint boundary conditions
  prob = coco_add_func(prob, 'bcs_adjoint', bcs_funcs_in.bcs_floquet{:}, dim_data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(xdim+1:end); ...
                             maps.x1_idx(xdim+1:end); ...
                             maps.p_idx(end-2:end)]));

  % Apply period boundary condition
  prob = coco_add_func(prob, 'bcs_T', bcs_funcs_in.bcs_T{:}, [], 'zero', ...
                       'uidx', uidx(maps.T_idx));

  %--------------------%
  %     Parameters     %
  %--------------------%
  % Add segment period as parameter
  % prob = coco_add_pars(prob, 'par_T', uidx(maps.T_idx), 'T_seg', 'active');

  %----------------%
  %     Output     %
  %----------------%
  % Output CoCo problem structure
  prob_out = prob;

end