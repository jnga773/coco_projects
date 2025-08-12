function [data_in, y_out] = bcs_isochron_phase(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_isochron_phase(prob_in, data_in, u_in)
  %
  % Boundary conditions for the isochron, that is:
  %            \theta_old - \theta_new = 0 .
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
  %          * u_in(1) - theta_new
  %          * u_in(2) - theta_old
  %
  % Output
  % ----------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  % (defined in calc_PR_initial_conditions.m)
  % Parameter maps
  p_maps = data_in.p_maps;

  %---------------%
  %     Input     %
  %---------------%
  % System parameters
  % p_system     = u_in(1 : pdim);

  % Phase resetting u_in
  % Integer for period
  % k             = u_in(p_maps.k);
  % Stable Floquet eigenvalue
  % mu_s          = u_in(p_maps.mu_s);
  % Distance from pertured segment to \Gamma
  % eta           = u_in(p_maps.eta);
  % Phase where perturbation starts
  theta_old     = u_in(p_maps.theta_old);
  % Phase where segment comes back to \Gamma
  theta_new     = u_in(p_maps.theta_new);
  % Angle of perturbation
  % theta_perturb = u_in(p_maps.theta_perturb);
  % Size of perturbation
  % A             = u_in(p_maps.A);

  %----------------%
  %     Output     %
  %----------------%
  y_out = [theta_new - theta_old];

end