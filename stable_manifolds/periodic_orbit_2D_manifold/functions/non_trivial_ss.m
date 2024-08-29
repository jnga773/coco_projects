function [x_pos_out, x_neg_out] = non_trivial_ss(p_in)
  % NON_TRIVIAL_SS: Calculates the non-trivial intensity (I)
  % steady state solutions, from analytic expressions.

  %--------------------------%
  %     Input Parameters     %
  %--------------------------%
  % Grab the parameter-space variables from p_in
  % Decay time of gain
  gamma = p_in(1);
  % Pump current on the gain
  A = p_in(2);
  % (Relative) absorption
  B = p_in(3);
  a = p_in(4);

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Components of the two non-trivial equilibrium values of intensity
  temp1 = -B - 1 - a + (a * A);
  temp1 = temp1 / (2 * a);

  temp2 = (B + 1 + a - (a * A)) ^ 2;
  temp2 = temp2 - 4 * (1 + B - A) * a;
  temp2 = sqrt(temp2);
  temp2 = temp2 / (2 * a);

  % The two non-trivial equilibrium values of intensity
  I_pos = temp1 + temp2;
  I_neg = temp1 - temp2;

  %----------------%
  %     Output     %
  %----------------%
  % The steady state values
  x_pos_out = [A / (1 + I_pos) ;
               B / (1 + (a * I_pos)) ;
               I_pos];
  
  x_neg_out = [A / (1 + I_neg) ;
               B / (1 + (a * I_neg)) ;
               I_neg];
end