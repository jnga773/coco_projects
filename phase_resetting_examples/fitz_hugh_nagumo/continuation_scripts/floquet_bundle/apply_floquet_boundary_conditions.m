function prob_out = apply_floquet_boundary_conditions(prob_in)
  % prob_out = apply_floquet_boundary_conditions(prob_in)
  %
  % Applies the boundary conditions for the rotated periodic orbit
  % (with function @bcs_PO) and for the Floquet bundle adjoint equation
  % with function (bcs_floquet).

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
  pdim = data.pdim - 2;

  % Save dimensions to be called in boundary condition functions
  dim_data.xdim = xdim;
  dim_data.pdim = pdim;

  %-----------------------------------%
  %     Apply Boundary Conditions     %
  %-----------------------------------%
  % Apply periodic orbit boundary conditions
  prob = coco_add_func(prob, 'bcs_po', @bcs_PO, dim_data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(1:xdim); ...
                             maps.x1_idx(1:xdim); ...
                             maps.p_idx(1:pdim)]));

  % Apply adjoing boundary conditions
  prob = coco_add_func(prob, 'bcs_adjoint', @bcs_floquet, dim_data, 'zero', 'uidx', ...
                       uidx([maps.x0_idx(xdim+1:end); ...
                             maps.x1_idx(xdim+1:end); ...
                             maps.p_idx(end-1:end)]));

  %----------------%
  %     Output     %
  %----------------%
  % Output CoCo problem structure
  prob_out = prob;

end