% % Add this function with the following code:
% % Add boundary conditions for segment 3
% prob = coco_add_func(prob, 'bcs_PR_seg3', @bcs_PR_seg3, data_in, 'zero', 'uidx', ...
%                      [uidx1(maps1.x0_idx(1:2));
%                       uidx3(maps3.x1_idx)]);

function bcs_coco_out = symbolic_bcs_PR_seg3()
  % bcs_coco_out = bcs_PR_seg3()
  %
  % Boundary conditions for segment three of the phase reset
  % segments:
  %                        x3(1) - x1(0) = 0 .
  %
  % Input
  % ----------
  % prob_in : COCO problem structure
  %     Continuation problem structure.
  % data_in : structure
  %     Problem data structure contain with function data.
  % u_in : array (floats?)
  %     Total u-vector of the continuation problem. This function
  %     only utilises the following (as imposed by coco_add_func):
  %          * u_in(1:2)   - x0 of segment 1,
  %          * u_in(3:4)   - x1 of segment 3,
  %
  % Output
  % ----------
  % bcs_coco_out : cell of function handles
  %     List of CoCo-ified symbolic functions for the boundary conditions
  %     Jacobian, and Hessian.

  %---------------%
  %     Input     %
  %---------------%
  % State space variables
  syms x1 x2 x3 x4

  % Segment 1 - x(0)
  x0_seg1 = [x1; x2];
  % Segment 3 - x(1)
  x1_seg3 = [x3; x4];

  % Combined vector
  uvec = [x0_seg1; x1_seg3];

  %--------------------------%
  %     Calculate Things     %
  %--------------------------%
  % Boundary Conditions - Segment 3
  bcs_seg3 = x1_seg3 - x0_seg1;

  % Boundary condition vector
  bcs = bcs_seg3;

  % CoCo-compatible encoding
  filename_out = './boundary_conditions/symbolic/F_bcs_seg3';
  bcs_coco = sco_sym2funcs(bcs, {uvec}, {'u'}, 'filename', filename_out);

  % Function to "CoCo-ify" function outputs: [data_in, y_out] = f(prob_in, data_in, u_in)
  cocoify = @(func_in) @(prob_in, data_in, u_in) deal(data_in, func_in(u_in));

  %----------------%
  %     Output     %
  %----------------%
  % List of functions
  func_list = {cocoify(bcs_coco('')), cocoify(bcs_coco('u')), cocoify(bcs_coco({'u', 'u'}))};

  % Output
  bcs_coco_out = func_list;

end
