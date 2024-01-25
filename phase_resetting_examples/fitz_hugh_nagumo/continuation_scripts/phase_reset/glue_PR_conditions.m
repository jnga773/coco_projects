function prob_out = glue_PR_conditions(prob_in, data_in)
  % prob_out = glue_PR_conditions(prob_in)
  %
  % Applies the various boundary conditions, adds monitor functions
  % for the singularity point, glue parameters and other things
  % together, and also adds some user defined points. Also
  % applied some COCO settings to the continuation problem.
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  %
  % Output
  % ----------
  % prob_out : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure containing initialisation information
  %     for the segments.

  %---------------%
  %     Input     %
  %---------------%
  % Set the COCO problem
  prob = prob_in;

  % Original dimensions of vector field
  xdim          = data_in.xdim;
  pdim          = data_in.pdim;
  % Create data structure for original vector field dimensions
  dim_data.xdim = xdim;
  dim_data.pdim = pdim;

  %-------------------------------%
  %     Continuation Settings     %
  %-------------------------------%
  % % Set NTST values for each segment
  % prob = coco_set(prob, 'seg1_gamma_0_to_theta_new.coll', 'NTST', NTST(1));
  % prob = coco_set(prob, 'seg2_theta_new_to_gamma_0.coll', 'NTST', NTST(2));
  % prob = coco_set(prob, 'seg3_gamma_0_to_theta_old.coll', 'NTST', NTST(3));
  % prob = coco_set(prob, 'seg4_theta_old_to_theta_new.coll', 'NTST', NTST(4));

  %-------------------------------%
  %     Read the Segment Data     %
  %-------------------------------%
  % Extract toolbox data and context-dependent index set for each of the orbit
  % segments.
  [data1, uidx1]   = coco_get_func_data(prob, 'seg1.coll', 'data', 'uidx');
  [data2, uidx2]   = coco_get_func_data(prob, 'seg2.coll', 'data', 'uidx');
  [data3, uidx3]   = coco_get_func_data(prob, 'seg3.coll', 'data', 'uidx');
  [data4, uidx4]   = coco_get_func_data(prob, 'seg4.coll', 'data', 'uidx');
  [dataep, uidxep] = coco_get_func_data(prob, 'singularity.ep', 'data', 'uidx');

  % Grab the indices from each of the orbit segments
  maps1 = data1.coll_seg.maps;
  maps2 = data2.coll_seg.maps;
  maps3 = data3.coll_seg.maps;
  maps4 = data4.coll_seg.maps;
  mapsep = dataep.ep_eqn;

  %----------------------------------------%
  %     Glue Trajectory Segment Things     %
  %----------------------------------------%
  % Glue parameters and periods and what not together
  prob = coco_add_glue(prob, 'shared_seg1_seg2', ...
                       uidx1([maps1.T_idx; maps1.p_idx]), ...
                       uidx2([maps2.T_idx; maps2.p_idx]));
  prob = coco_add_glue(prob, 'shared_seg1_seg4', ...
                       uidx1([maps1.T_idx; maps1.p_idx]), ...
                       uidx4([maps4.T_idx; maps4.p_idx]));
  prob = coco_add_glue(prob, 'shared_seg1_seg3', ...
                       uidx1([maps1.T_idx; maps1.p_idx]), ...
                       uidx3([maps3.T_idx; maps3.p_idx]));
  prob = coco_add_glue(prob, 'shared_pars_ep', ...
                       uidx1(maps1.p_idx), uidxep(mapsep.p_idx));

  %---------------------------------%
  %     Add Boundary Conditions     %
  %---------------------------------%
  % Add boundary conditions for segments 1 and 2
  prob = coco_add_func(prob, 'bcs_PR_seg1_seg2', @bcs_PR_seg1_seg2, dim_data, 'zero', 'uidx', ...
                       [uidx1(maps1.x0_idx);
                        uidx2(maps2.x0_idx);
                        uidx1(maps1.x1_idx);
                        uidx2(maps2.x1_idx);
                        uidx1(maps1.p_idx)]);

  % Add boundary conditions for segment 3
  prob = coco_add_func(prob, 'bcs_PR_seg3', @bcs_PR_seg3, dim_data, 'zero', 'uidx', ...
                       [uidx1(maps1.x0_idx(1:xdim));
                        uidx3(maps3.x1_idx)]);

  % Add boundary conditions for segment 4
  prob = coco_add_func(prob, 'bcs_PR_seg4', @bcs_PR_seg4, dim_data, 'zero', 'uidx', ...
                       [uidx2(maps2.x0_idx);
                        uidx3(maps3.x0_idx);
                        uidx4(maps4.x0_idx);
                        uidx4(maps4.x1_idx);
                        uidx1(maps1.p_idx)]);
                        
  %------------------------%
  %     Add Parameters     %
  %------------------------%
  % Parameter names
  prob = coco_add_pars(prob, 'pars_all', ...
                       uidx1(maps1.p_idx), data_in.pnames);

  % % Add segment parameters
  prob = coco_add_pars(prob, 'pars_seg4', ...
                       uidx4(maps4.x0_idx), {'iso1'; 'iso2'}, 'active');

  %------------------------------%
  %     Add Monitor Function     %
  %------------------------------%
  % Monitor the distance and angle that the initial point of segment 4 is
  % from the equilibrium point / singularity. This will also output the
  % difference between the first components to 'EP_delta_x' so that we can
  % trigger a user-defined event, as defined below.
  prob = coco_add_func(prob, 'singular', @distance_to_singularity, dim_data, ...
                       'active', {'EP_distance', 'EP_angle', 'EP_delta_x'}, 'uidx', ...
                       [uidx4(maps4.x0_idx); ...
                        uidxep(mapsep.x_idx)]);

  %-------------------------%
  %     Add COCO Events     %
  %-------------------------%
  % When first component of x4(0) equals the first component of the
  % singularity.
  prob = coco_add_event(prob, 'vert', 'EP_delta_x', 0.0);

  %----------------%
  %     Output     %
  %----------------%
  % Output problem structure
  prob_out = prob;


end