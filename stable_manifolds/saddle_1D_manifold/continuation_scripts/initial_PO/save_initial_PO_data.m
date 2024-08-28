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
  % Stable periodic orbit
  [sol_s, data_s] = coll_read_solution('PO_stable', run_in, label_in);
  xbp_PO_s = sol_s.xbp;

  % Equilibrium points
  sol_0 = ep_read_solution('x0', run_in, label_in);
  x_0   = sol_0.x;
  sol_pos = ep_read_solution('xpos', run_in, label_in);
  x_pos = sol_pos.x;
  sol_neg = ep_read_solution('xneg', run_in, label_in);
  x_neg = sol_neg.x;

  % Parameters
  p      = sol_s.p;
  pnames = data_s.pnames;

  % Time
  tbp_s = sol_s.tbp;
  
  % Period
  T_s   = sol_s.T;

  %--------------------------------------%
  %     Periodic Orbit Floquet Stuff     %
  %--------------------------------------%
  % End point of periodic orbits
  xbp_end_s = xbp_PO_s(end, :);

  % Monodromy matrix
  chart = coco_read_solution('PO_stable.coll.var', run_in, label_in, 'chart');
  data  = coco_read_solution('PO_stable.coll', run_in, label_in, 'data');

  % Create monodrony matrix
  M1 = chart.x(data.coll_var.v1_idx);

  % Get eigenvalues and eigenvectors of the Monodromy matrix
  [floquet_vec, floquet_eig] = eig(M1);

  % Find index for stable eigenvector? < 1
  [lam_s, min_idx] = min(abs(diag(floquet_eig)));

  % Stable eigenvector
  vec_s = floquet_vec(:, min_idx);
  % Stable eigenvalue (Floquet thingie)
  % lam_s = floquet_eig(min_idx, min_idx);

  %----------------%
  %     Output     %
  %----------------%
  data_out.xbp     = xbp_PO_s;
  data_out.tbp     = tbp_s;
  data_out.T       = T_s;

  data_out.x0      = x_0;
  data_out.xpos    = x_pos;
  data_out.xneg    = x_neg;
  
  data_out.xbp_end = xbp_end_s;
  data_out.vec_s   = vec_s;
  data_out.lam_s   = lam_s;

  data_out.p       = p;
  data_out.pnames  = pnames;

  data_out.xdim    = length(x_0);
  data_out.pdim    = length(p); 

  %-------------------%
  %     Save Data     %
  %-------------------%
  save(filename_out, '-struct', 'data_out');

end