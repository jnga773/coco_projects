function save_initial_PO_data(run_in, label_in)
  % save_initial_PO_data(run_in, label_in)
  %
  % Reads periodic orbit solution data from COCO solution, calculates the
  % one-dimensional stable manifold of the "central" saddle point 'q', and
  % saves the data to './data/initial_PO.mat'.

  % Data matrix filename
  filename_out = './data_mat/initial_PO.mat';

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Periodic orbit solution
  sol_PO = coll_read_solution('initial_PO', run_in, label_in);
  xbp_PO = sol_PO.xbp;
  p_PO   = sol_PO.p;

  % Equilibrium point solutions
  sol_0  = ep_read_solution('x0', run_in, label_in);
  x0     = sol_0.x;

  %-------------------%
  %     Save Data     %
  %-------------------%
  save(filename_out, 'x0', 'xbp_PO', 'p_PO');

end
