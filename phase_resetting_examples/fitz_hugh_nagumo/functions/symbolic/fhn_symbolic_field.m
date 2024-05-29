function F_out = fhn_symbolic_field()
  % F_out = fhn_symbolic_field()
  %
  % Symbolic notation of the Yamada vector field in the transformed axes.
  
  % State-space and parameter variables
  syms x1 x2
  syms c a b z

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Vector field
  F1 = c * (x2 + x1 - ((1/3) * (x1 ^ 3)) + z);
  F2 = (-1 / c) * (x1 - a + (b * x2));

  % Vector field
  F_vec = [F1; F2];

  %----------------%
  %     Output     %
  %----------------%
  F_out = F_vec;

end