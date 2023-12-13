function prob_out = glue_lin_conditions(prob_in, data_in, lingap_in)
  % prob_out = glue_lin_conditions(prob_in, data_in, lingap_in)
  %
  % Applies the Lin gap and Lin phase boundary conditions to the COCO problem.
  % The parameter [lingap] is then allowed to vary.
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure containing boundary condition information.
  % lingap_in : float
  %     Value of the Lin gap distance parameter.
  %
  % Output
  % ----------
  % prob_out : COCO problem structure
  %     Continuation problem structure.

  % Set the COCO problem
  prob = prob_in;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for the unstable
  % and stable manfiolds.
  [data_u, uidx_u] = coco_get_func_data(prob, 'unstable.coll', 'data', 'uidx');
  [data_s, uidx_s] = coco_get_func_data(prob, 'stable.coll', 'data', 'uidx');

  % Grab the indices from the data sections
  maps_u = data_u.coll_seg.maps;
  maps_s = data_s.coll_seg.maps;

  % uidx_u(maps_u.x1_idx) - u-vector indices for the final point of the
  %                         unstable manifold trajectory segment - x_u(T1).
  % uidx_s(maps_s.x0_idx) - u-vector indices for the initial point of the
  %                         stable manifold trajectory segment - x_s(0).

  % Add x-dimension to data_in
  data_in.xdim = data_u.xdim;
  
  %---------------------------------%
  %     Apply Lin Gap Condition     %
  %---------------------------------%
  % % Append Lin's gap condition. 
  % % Here, lingap_in is appended as an input to the u-vector input for the function
  % % @boundary_conditions_lingap.
  % prob = coco_add_func(prob, 'bcs_lingap', @lingap, data_in, ...
  %                      'inactive', 'lingap', 'uidx', ...
  %                      [uidx_u(maps_u.x1_idx); uidx_s(maps_s.x0_idx)]);

  %---------------------------------%
  %     Apply Lin Gap Condition     %
  %---------------------------------%
  % Append Lin's gap condition. 
  % Here, lingap_in is appended as an input to the u-vector input for the function
  % @boundary_conditions_lingap.
  prob = coco_add_func(prob, 'bcs_lingap', @boundary_conditions_lingap, data_in, ...
                       'zero', 'uidx', ...
                       [uidx_u(maps_u.x1_idx); uidx_s(maps_s.x0_idx)], ...
                       'u0', lingap_in);
  
  % Get u-vector indices from this coco_add_func call,  including the extra
  % indices from the added "lingap_in"
  uidx_lins = coco_get_func_data(prob, 'bcs_lingap', 'uidx');
  
  % Grab epsilon parameters indices from u-vector [lingap]
  lingap_idx = [numel(uidx_lins)];
  data_in.lingap_idx = lingap_idx;
  
  % Save data structure to be called later with coco_get_func_data 
  prob = coco_add_slot(prob, 'bcs_lingap', @coco_save_data, data_in, 'save_full');
  
  % Add "lingap" parameter 
  prob = coco_add_pars(prob, 'pars_lins', [uidx_lins(lingap_idx)], {'lingap'});

  %------------------------%
  %     Add Lin0 Event     %
  %------------------------%
  % Add event for when Lin's gap is zero
  prob = coco_add_event(prob, 'Lin0', 'lingap', 0);

  %----------------%
  %     Output     %
  %----------------%
  % Save data structure to be called later with coco_get_func_data 
  prob = coco_add_slot(prob, 'lins_data', @coco_save_data, data_in, 'save_full');

  % COCO problem structure
  prob_out = prob;

end