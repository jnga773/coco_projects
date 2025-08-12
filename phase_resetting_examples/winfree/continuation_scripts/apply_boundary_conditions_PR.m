function prob_out = apply_boundary_conditions_PR(prob_in, data_in, bcs_funcs_in, options)
  % prob_out = apply_boundary_conditions_PR(prob_in)
  %
  % Applies the various boundary conditions, adds monitor functions
  % for the singularity point, glue parameters and other things
  % together, and also adds some user defined points. Also
  % applied some COCO settings to the continuation problem.
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure containing initialisation information
  %     for the segments.
  % bcs_funcs_in : list of functions
  %     List of all of the boundary condition functions for each
  %     phase resetting segment.
  % bcs_isochron : boolean
  %     Flag to determine if the isochron phase condition should be added.
  % par_isochron : boolean
  %     Flag to determine if isochron parameters should be recorded.
  %
  % Returns
  % -------
  % prob_out : COCO problem structure
  %     Continuation problem structure.
  %
  % See Also
  % --------
  % coco_get_func_data, coco_add_glue, coco_add_func, coco_add_pars

  %-----------------------%
  %     Default Input     %
  %-----------------------%
  arguments
    prob_in struct
    data_in struct
    bcs_funcs_in struct

    % Optional arguments
    options.bcs_isochron logical = false;
    options.par_isochron logical = false;
  end

  %---------------%
  %     Input     %
  %---------------%
  % Set the COCO problem
  prob = prob_in;

  % Original vector field dimensions
  xdim            = data_in.xdim;
  pdim            = data_in.pdim;
  % Create data structure for original vector field dimensions
  dim_data.xdim   = xdim;
  dim_data.pdim   = pdim;
  dim_data.p_maps = data_in.p_maps;

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for each of the orbit
  % segments.
  [data1, uidx1]  = coco_get_func_data(prob, 'seg1.coll', 'data', 'uidx');
  [data2, uidx2]  = coco_get_func_data(prob, 'seg2.coll', 'data', 'uidx');
  [data3, uidx3]  = coco_get_func_data(prob, 'seg3.coll', 'data', 'uidx');
  [data4, uidx4]  = coco_get_func_data(prob, 'seg4.coll', 'data', 'uidx');

  % Grab the indices from each of the orbit segments
  maps1 = data1.coll_seg.maps;
  maps2 = data2.coll_seg.maps;
  maps3 = data3.coll_seg.maps;
  maps4 = data4.coll_seg.maps;

  % Read index data equilibrium points
  [data_x0, uidx_x0] = coco_get_func_data(prob, 'x0.ep',   'data', 'uidx');
  % Grab the indices from the equilibrium point
  maps_x0 = data_x0.ep_eqn;

  % Add function handle to dim_data
  dim_data.fhan = data_x0.fhan;

  %----------------------------------------%
  %     Glue Trajectory Segment Things     %
  %----------------------------------------%
  % "Glue" segment periods together
  prob = coco_add_glue(prob, 'glue_T', ...
                       [uidx1(maps1.T_idx); uidx1(maps1.T_idx); uidx1(maps1.T_idx)], ...
                       [uidx2(maps2.T_idx); uidx3(maps3.T_idx); uidx4(maps4.T_idx)]);
  % "Glue" segment parameters together
  prob = coco_add_glue(prob, 'glue_pars', ...
                       [uidx1(maps1.p_idx); uidx1(maps1.p_idx); uidx1(maps1.p_idx)], ...
                       [uidx2(maps2.p_idx); uidx3(maps3.p_idx); uidx4(maps4.p_idx)]);
  % "Glue" segment and equilibrium point parameters together
  prob = coco_add_glue(prob, 'glue_x0', uidx1(maps1.p_idx(1:pdim)), uidx_x0(maps_x0.p_idx));

  %---------------------------------%
  %     Add Boundary Conditions     %
  %---------------------------------%
  % Boundary condition function list
  bcs_PR = bcs_funcs_in.bcs_PR;

  % Add boundary conditions for four segments
  prob = coco_add_func(prob, 'bcs_PR', bcs_PR{:}, dim_data, 'zero', 'uidx', ...
                       [uidx1(maps1.x0_idx);
                        uidx2(maps2.x0_idx);
                        uidx3(maps3.x0_idx);
                        uidx4(maps4.x0_idx);
                        uidx1(maps1.x1_idx);
                        uidx2(maps2.x1_idx);
                        uidx3(maps3.x1_idx);
                        uidx4(maps4.x1_idx);
                        uidx1(maps1.p_idx)]);

  % Add phase boundary condition
  if options.bcs_isochron
    bcs_iso_phase = bcs_funcs_in.bcs_iso_phase;
    prob = coco_add_func(prob, 'bcs_iso_phase', bcs_iso_phase{:}, dim_data, 'zero', 'uidx', ...
                          uidx1(maps1.p_idx));
  end
                        
  %------------------------%
  %     Add Parameters     %
  %------------------------%
  if options.par_isochron
    % Add isochron parameters
    prob = coco_add_pars(prob, 'pars_isochron', ...
                        uidx4(maps4.x0_idx), {'iso1', 'iso2'}, ...
                        'active');
  end

  %----------------%
  %     Output     %
  %----------------%
  % Output problem structure
  prob_out = prob;

end