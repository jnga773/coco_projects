function varargout=F_bcs_floquet(action,varargin)
%% Automatically generated with matlabFunction
%#ok<*DEFNU,*INUSD,*INUSL>

switch action
  case 'nargs'
   varargout{1}=1;
   return
  case 'nout'
   varargout{1}=3;
   return
  case 'argrange'
   varargout{1}=struct('u',1:7);
   return
  case 'argsize'
   varargout{1}=struct('u',7);
   return
  case 'vector'
   varargout{1}=struct('u',1);
   return
  case 'extension'
   varargout{1}='rhs';
   return
  case 'maxorder'
   varargout{1}=2;
   return
end
nout=3;
order=varargin{1};
f=str2func(sprintf('F_bcs_floquet_%s_%d',action,order));
varargout=cell(nout,1);
[varargout{:}]=f(varargin{2:end});
end



function [out1,out2,out3] = F_bcs_floquet_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14)
%F_bcs_floquet_rhs_0
%    [OUT1,OUT2,OUT3] = F_bcs_floquet_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    29-May-2024 12:25:56

out1 = in3-in1.*in5;
if nargout > 1
    out2 = in4-in2.*in5;
end
if nargout > 2
    out3 = -in6+in1.*conj(in1)+in2.*conj(in2);
end
end


function [out1,out2,out3] = F_bcs_floquet_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14)
%F_bcs_floquet_rhs_1
%    [OUT1,OUT2,OUT3] = F_bcs_floquet_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    29-May-2024 12:25:56

out1 = in10-in1.*in12-in5.*in8;
if nargout > 1
    out2 = in11-in2.*in12-in5.*in9;
end
if nargout > 2
    out3 = -in13+in1.*conj(in8)+in8.*conj(in1)+in2.*conj(in9)+in9.*conj(in2);
end
end


function [out1,out2,out3] = F_bcs_floquet_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14)
%F_bcs_floquet_rhs_2
%    [OUT1,OUT2,OUT3] = F_bcs_floquet_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    29-May-2024 12:25:56

out1 = in8.*in12.*-2.0;
if nargout > 1
    out2 = in9.*in12.*-2.0;
end
if nargout > 2
    out3 = in8.*conj(in8).*2.0+in9.*conj(in9).*2.0;
end
end
