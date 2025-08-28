function [data_in, y_out] = bcs_PR_phase(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_PR_phase(prob_in, data_in, u_in)
  %
  % Boundary conditions for the isochron phase, that is:
  %            \theta_old - \theta_new = 0 .
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with function data.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the parameters.
  %
  % Returns
  % -------
  % y_out : array of vectors
  %     An array containing to the two boundary conditions.
  % data_in : structure
  %     Function data structure to give dimensions of parameter and state
  %     space.

  %============================================================================%
  %                         READ FROM data_in STRUCTURE                        %
  %============================================================================%
  % These parameters are read from the data_in structure. This is defined as
  % 'data_EP' in the 'apply_boundary_conditions_PR' function, and is the
  % function data of the equilibrium point problem (ode_ep2ep).
  
  % Original vector field parameter-space dimension
  pdim   = data_in.pdim;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %--------------------%
  %     Parameters     %
  %--------------------%
  % System parameters
  % p_sys         = u_in(1 : pdim);
  % Phase resetting parameters
  p_PR          = u_in(pdim+1 : end);

  % Phase resetting parameters
  % Integer for period
  % k             = p_PR(1);
  % Phase where perturbation starts
  theta_old     = p_PR(2);
  % Phase where segment comes back to \Gamma
  theta_new     = p_PR(3);
  % Stable Floquet eigenvalue
  % mu_s          = p_PR(4);
  % Distance from pertured segment to \Gamma
  % eta           = p_PR(5);
  % Perturbation vector
  % d_vec         = p_PR(6:end);

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  %----------------------------------%
  %     Phase Boundary Condition     %
  %----------------------------------%
  % Force the two phases to be equal
  bcs_phase = theta_old - theta_new;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  y_out = bcs_phase;

end