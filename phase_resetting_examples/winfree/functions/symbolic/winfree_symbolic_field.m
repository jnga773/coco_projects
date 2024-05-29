function F_out = winfree_symbolic_field()
  % F_out = winfree_symbolic_field()
  %
  % Symbolic notation of the Yamada vector field in the transformed axes.
  
  % State-space and parameter variables
  syms x1 x2
  syms a omega

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % square root bit
  sqrt_xy = sqrt( (x1 .^ 2) + (x2 .^ 2) );
  % front bit
  first_bit = 1 - sqrt_xy;

  % Vector field components
  F1 = first_bit .* (x1 .* (sqrt_xy - a) + (omega .* x2)) + x2;
  F2 = first_bit .* (x2 .* (sqrt_xy - a) - (omega .* x1)) - x1;

  % Vector field
  F_vec = [F1; F2];

  %----------------%
  %     Output     %
  %----------------%
  F_out = F_vec;

end