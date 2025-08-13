function [data_in, y_out] = bcs_VAR(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_VAR(prob_in, data_in, u_in)
  %
  % Boundary conditions for the Floquet multipliers with the adjoint equation
  %                  d/dt w = -J^{T} w    .
  % The boundary conditions we require are the eigenvalue equations and that
  % the norm of w is equal to 1:
  %                   w(1) = \mu_{f} w(0) ,                         (1)
  %                norm(w) = w_norm       .                         (2)
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
  %          * u_in(1:2) - Initial point of the perpendicular vector,
  %          * u_in(3:4) - Final point of the perpendicular vector,
  %          * u_in(5)   - Eigenvalue (mu_s),
  %          * u_in(6)   - Norm of w (w_norm).
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
  
  % Original vector field state-space dimension
  xdim   = data_in.xdim;
  % Original vector field parameter-space dimension
  pdim   = data_in.pdim;
  % Original vector field function
  field  = data_in.fhan;

  %============================================================================%
  %                                    INPUT                                   %
  %============================================================================%
  %-------------------------------%
  %     Adjoint-Space Vectors     %
  %-------------------------------%
  % Initial perpendicular vector
  w_init  = u_in(1 : xdim);
  % Final perpendicular vector
  w_final = u_in(xdim+1 : 2 * xdim);

  %--------------------%
  %     Parameters     %
  %--------------------%
  % Stable eigenvalue
  mu_s   = u_in(end-1);
  % Norm of stable orthogonal eigenvector
  w_norm = u_in(end);

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  % Adjoint boundary conditions
  bcs_adjt_1 = w_final - (mu_s * w_init);
  bcs_adjt_2 = (w_init' * w_init) - w_norm;

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  y_out = [bcs_adjt_1;
           bcs_adjt_2];

end
