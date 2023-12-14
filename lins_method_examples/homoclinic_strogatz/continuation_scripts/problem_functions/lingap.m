function [data_in, y_out] = lingap(prob_in, data_in, u_in)
  % [data_in, y_out] = lingap(prob_in, data_in, u_in)

  % COCO compatible encoding for the boundary conditions of the Lin condition,
  %           x_s(0) = x_u(T1) + \delta v_gap,
  % where x_s(0) is the initial point of the stable trajectory,
  % x_u(T1) is the final point of the unstable trajectory, v_gap
  % is the normalised vector between these two points, and \delta
  % is the Lin gap, the distance between these two points.
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with Lin gap function data.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the following (as imposed by coco_add_func):
  %          * u_in(1:2) - The final point of the unstable manifold (x1_unstable),
  %          * u_in(3:4) - The initial point of the stable manifold (x0_stable).
  %
  % Output
  % ----------
  % y_out : array (float)
  %     An array the Lin gap condition.
  % data_in : structure
  %     Not actually output here but you need to have it for COCO.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------% 
  % Ustable vector
  x1_unstable = u_in(1:2);
  
  % Stable vector
  x0_stable = u_in(3:4);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Lin gap vector
  % x_lin = x1_unstable - x0_stable;
  x_lin = x0_stable - x1_unstable;

  %----------------%
  %     Output     %
  %----------------%
  % Lin gap distance
  y_out = data_in.vgap * x_lin;

end