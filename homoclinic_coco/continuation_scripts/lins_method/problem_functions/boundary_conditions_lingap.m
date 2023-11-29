function [data_in, y_out] = boundary_conditions_lingap(prob_in, data_in, u_in)
  % [data_in, y_out] = boundary_conditions_lingap(prob_in, data_in, u_in)

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
  %          * u_in(1:3) - The final point of the unstable manifold (x1_unstable),
  %          * u_in(4:6) - The initial point of the stable manifold (x0_stable),
  %          * u_in(7)   - The distance between these two points (lingap).
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
  % Final point of the unstable trajectory
  x1_unstable = u_in(1:3);

  % Initial point of the stable trajectory
  x0_stable = u_in(4:6);

  % Lin-gap parameter
  lingap = u_in(7);

  % Lin-gap vector
  vgap = data_in.vgap';

  %---------------------------------------%
  %     Calculate Boundary Conditions     %
  %---------------------------------------%
  % Boundary condition
  x0_stable_bcs = x1_unstable + (lingap * vgap);

  %----------------%
  %     Output     %
  %----------------%
  y_out = x0_stable - x0_stable_bcs;

end