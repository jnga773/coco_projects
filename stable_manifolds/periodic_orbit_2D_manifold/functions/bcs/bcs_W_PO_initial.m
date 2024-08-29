function [data_in, y_out] = bcs_W_PO_initial(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_W_PO_initial(prob_in, data_in, u_in)
  %
  % COCO compatible encoding for the "final" boundary conditions of the two
  % trajectory segments of the stable manifold of x_pos. Each segment
  % will intersect a defined plane, \Sigma_{i}, 
  %           x1(0) \in \Sigma_{1} ,
  %           x2(0) \in \Sigma_{2} .
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with function data.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the following (as imposed by coco_add_func):
  %          * u_in(1:3)   - The initial point of segment 1 of the manifold (x0_seg1),
  %          * u_in(4:6)   - The initial point of segment 2 of the manifold (x0_seg2),
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  % State space dimension
  xdim = data_in.xdim;
  
  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Initial vector of segment 1
  x0_seg1 = u_in(1 : xdim);
  % Initial vector of segment 2
  x0_seg2 = u_in(xdim+1 : 2*xdim);

  %------------------------------------%
  %     Read Points from "data_in"     %
  %------------------------------------%
  % "End" point for segment 1
  bcs_seg1 = 35.0;
  % "End" point for segment 2
  bcs_seg2 = -4.0;

  %----------------%
  %     Output     %
  %----------------%
  % Boundary conditions
  y_out = [x0_seg1(3) - bcs_seg1;
           x0_seg2(2) - bcs_seg2];

end
