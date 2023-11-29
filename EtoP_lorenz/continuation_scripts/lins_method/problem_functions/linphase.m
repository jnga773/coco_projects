function [data_in, y_out] = linphase(prob_in, data_in, u_in)
  % [data_in, y_out] = linphase(prob_in, data_in, u_in)

  % COCO compatible encoding for the Lin phase condition.
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
  %          * u_in(4:6) - The initial point of the stable manifold (x0_stable).
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

  % Lin-gap vector
  vphase = data_in.vphase_vec;

  %----------------%
  %     Output     %
  %----------------%
  y_out = vphase * (x1_unstable - x0_stable);

end
