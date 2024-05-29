function template_plot_isochrons(ax_in, isochron_run_in)
  % template_plot_isochrons(ax_in, isochron_run_in)
  %
  % Plots all isochron from the isochron_multi.m run.

  %-------------------%
  %     Read Data     %
  %-------------------%
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
  
  dir_sub_plot = dir_sub;

  % Cycle through each data directory
  for i = 1 : length(dir_sub_plot)
    % Sub folder name
    dir_read = {isochron_run_in, dir_sub_plot{i}};

    % Bifurcation data
    bd_read = coco_bd_read(dir_read);

    % Read theta_old and theta_new
    iso1_read = coco_bd_col(bd_read, 'iso1');
    iso2_read = coco_bd_col(bd_read, 'iso2');

    % Append to arrays
    iso1_data{i} = iso1_read;
    iso2_data{i} = iso2_read;

  end

  %-------------------------------------------------------------------------%
  %%                          Plot: All Isochrons                          %%
  %-------------------------------------------------------------------------%
  % matplotlib colour order
  colours = colororder();

  % Cycle through data and plot
  for i = 1 : length(dir_sub_plot)

    % Read data
    iso1_plot = iso1_data{i};
    iso2_plot = iso2_data{i};

    % Plot single isochron
    plot(ax_in, iso1_plot, iso2_plot, Color=[colours(1, :), 0.5], LineStyle='-');

  end

end