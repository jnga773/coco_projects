function save_isochron_data(isochron_run_in, filename_in)

  %-----------------------------%
  %     Read Data: Isochrons    %
  %-----------------------------%
  % Folder name
  dir_data = sprintf('./data/%s/', isochron_run_in);
  % List all directories
  dirs = dir(dir_data);
  % Remove ./ and ../
  dirs = dirs(~ismember({dirs.name}, {'.', '..', '.DS_Store'}));
  % Sub folder names
  dir_sub = {dirs.name};

  % Empty arrays for theta_old and theta_new
  iso1_data = {};
  iso2_data = {};
  iso3_data = {};
  
  dir_sub_plot = dir_sub;

  % Cycle through each data directory
  for i = 1 : length(dir_sub_plot)
    % Sub folder name
    dir_read = {isochron_run_in, dir_sub_plot{i}};
    fprintf('run_dir:  {%s, %s} \n', dir_read{1}, dir_read{2});

    % Bifurcation data
    bd_read = coco_bd_read(dir_read);

    % Read theta_old and theta_new
    iso1_read = coco_bd_col(bd_read, 'iso1');
    iso2_read = coco_bd_col(bd_read, 'iso2');
    iso3_read = coco_bd_col(bd_read, 'iso3');

    % Append to arrays
    iso1_data{i} = iso1_read;
    iso2_data{i} = iso2_read;
    iso3_data{i} = iso3_read;

  end

  % Read parameters
  parameters.A         = coco_bd_val(bd_read, 1, 'A');
  parameters.gamma     = coco_bd_val(bd_read, 1, 'gamma');
  parameters.B         = coco_bd_val(bd_read, 1, 'B');
  parameters.a         = coco_bd_val(bd_read, 1, 'a');
  parameters.theta_old = coco_bd_val(bd_read, 1, 'theta_old');
  parameters.theta_new = coco_bd_val(bd_read, 1, 'theta_new');

  %---------------------------------------%
  %     Save Data to MATLAB .mat file     %
  %---------------------------------------%
  % Save data
  save(filename_in, 'iso1_data', 'iso2_data', 'iso3_data', 'parameters');
end