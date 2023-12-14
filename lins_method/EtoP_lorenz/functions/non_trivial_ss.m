function [x_pos_out, x_neg_out] = non_trivial_ss(p_in)
  % NON_TRIVIAL_SS: Calculates the non-trivial intensity
  % steady state solutions, from analytic expressions.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the parameter-space variables from p_in
  s = p_in(1, :);
  r = p_in(2, :);
  b = p_in(3, :);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Components of the two non-trivial equilibrium values of intensity
  y1 = sqrt(b * (r - 1));
  y2 = sqrt(b * (r - 1));
  y3 = r - 1;

  %----------------%
  %     Output     %
  %----------------%
  % The steady state values
  x_pos_out = [y1;
               y2;
               y3];
  
  x_neg_out = [-y1;
               -y2;
                y3];
end