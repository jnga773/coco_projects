function y_out = marsden_analytic(p_in)
  % Grab the parameter-space variables from p_in
  p1 = p_in(1);
  p2 = p_in(2);

  % Setup state-space variables
  % x = optimvar('x', 3);
  % x1 = x(1); x2 = x(2); x3 = x(3);

  syms x1 x2 x3

  % The system of equations
  eq1 = (p1 * x1) + x2 + (p2 * (x1 ^ 2)) == 0;
  eq2 = (-x1) + (p1 * x2) + (x2 * x3) == 0;
  eq3 = (((p1 ^ 2) - 1) * x2 ) - x1 - x3 + (x1 ^ 2) == 0;

  % Create problem structure
  % prob = eqnproblem;
  % prob.Equations.eq1 = eq1;
  % prob.Equations.eq2 = eq2;
  % prob.Equations.eq3 = eq3;

  % Calculate solution using Solve
  sol = Solve([eq1, eq2, eq3], [x1, x2, x3]);

  % Solutions
  x1_sol = sol.x1;
  x2_sol = sol.x2;
  x3_sol = sol.x3;

  % Output
  y_out = [x1_sol, x2_sol, x3_sol];

end