function [data_in, y_out] = bcs_PO(prob_in, data_in, u_in)
  % [data_in, y_out] = bcs_PO(prob_in, data_in, u_in)
  % 
  % Boundary conditions for a periodic orbit,
  %                           x(1) - x(0) = 0 ,
  % in the 'coll' toolbox with the zero phase condition where:
  %                         e . F(x(0)) = 0,
  % that is, the first component of the vector field at t=0 is zero.
  %
  % Parameters
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with function data. Utilises the
  %     following fields:
  %          * xdim   - Dimension of the state space,
  %          * pdim   - Dimension of the parameter space,
  %          * fhan   - Function handle for the vector field encoding.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the following (as imposed by coco_add_func):
  %          * u_in(1:2) - Initial point of the periodic orbit,
  %          * u_in(3:4) - Final point of the periodic orbit,
  %          * u_in(5:8) - Parameters.
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
  %-----------------------------%
  %     State-Space Vectors     %
  %-----------------------------%
  % Initial point of the periodic orbit
  x_init     = u_in(1 : xdim);
  % Final point of the periodic orbit
  x_final    = u_in(xdim+1 : 2*xdim);

  %--------------------%
  %     Parameters     %
  %--------------------%
  % Parameters
  parameters = u_in(2*xdim+1 : end);
  % System parameters
  p_sys      = parameters(1:pdim);

  %============================================================================%
  %                         BOUNDARY CONDITION ENCODING                        %
  %============================================================================%
  % Identity matrix
  ones_matrix = eye(xdim);
  % First component unit vector
  e1 = ones_matrix(1, :);

  % Periodic boundary conditions
  bcs1 = x_init - x_final;
  % First component of the vector field is zero (phase condition)
  bcs2 = e1 * field(x_init, p_sys);

  %============================================================================%
  %                                   OUTPUT                                   %
  %============================================================================%
  y_out = [bcs1; bcs2];

end
