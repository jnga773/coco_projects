function save_stable_q_data(run_in, label_in)
  % save_initial_PO_data(run_in, label_in)
  %
  % Reads periodic orbit solution data from COCO solution, calculates the
  % one-dimensional stable manifold of the "central" saddle point 'q', and
  % saves the data to './data/initial_PO.mat'.

  % Data matrix filename
  filename_out = './data_mat/stable_manifold_q.mat';

  %-------------------%
  %     Read Data     %
  %-------------------%
  % Read stable manifold solutions
  [sol1, ~] = coll_read_solution('W1', run_in, label_in);
  [sol2, ~] = coll_read_solution('W2', run_in, label_in);

  % State space solutions
  W1 = sol1.xbp;
  W2 = sol2.xbp;

  % Append to single array
  W_out = [W1; flip(W2)];

  %----------------%
  %     Output     %
  %----------------%
  % Read periodic orbit solution
  data_out = load('./data_mat/initial_PO.mat');

  data_out.Wq_s   = W_out;

  %-------------------%
  %     Save Data     %
  %-------------------%
  save(filename_out, '-struct', 'data_out');

end