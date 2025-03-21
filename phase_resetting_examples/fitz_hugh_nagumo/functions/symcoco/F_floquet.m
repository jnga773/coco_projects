function varargout=F_floquet(action,varargin)
%% Automatically generated with matlabFunction
%#ok<*DEFNU,*INUSD,*INUSL>

switch action
  case 'nargs'
   varargout{1}=2;
   return
  case 'nout'
   varargout{1}=4;
   return
  case 'argrange'
   varargout{1}=struct('x',1:4,'p',5:11);
   return
  case 'argsize'
   varargout{1}=struct('x',4,'p',7);
   return
  case 'vector'
   varargout{1}=struct('x',1,'p',1);
   return
  case 'extension'
   varargout{1}='rhs';
   return
  case 'maxorder'
   varargout{1}=2;
   return
end
nout=4;
order=varargin{1};
f=str2func(sprintf('F_floquet_%s_%d',action,order));
varargout=cell(nout,1);
[varargout{:}]=f(varargin{2:end});
end



function [out1,out2,out3,out4] = F_floquet_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22)
%F_floquet_rhs_0
%    [OUT1,OUT2,OUT3,OUT4] = F_floquet_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    21-Mar-2025 16:38:15

out1 = in5.*in11.*(in1+in2+in8-in1.^3./3.0);
if nargout > 1
    t2 = 1.0./in5;
    out2 = -in11.*t2.*(in1-in6+in2.*in7);
end
if nargout > 2
    out3 = in4.*in11.*t2+in3.*in5.*in11.*(in1.^2-1.0);
end
if nargout > 3
    out4 = -in3.*in5.*in11+in4.*in7.*in11.*t2;
end
end


function [out1,out2,out3,out4] = F_floquet_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22)
%F_floquet_rhs_1
%    [OUT1,OUT2,OUT3,OUT4] = F_floquet_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    21-Mar-2025 16:38:15

t2 = in2.*in7;
t3 = in1.^2;
t4 = in1.^3;
t5 = -in6;
t6 = 1.0./in5;
t7 = t6.^2;
t8 = t3-1.0;
t9 = t4./3.0;
t11 = in1+t2+t5;
t10 = -t9;
t12 = in1+in2+in8+t10;
out1 = in5.*in11.*(in12+in13+in19-in12.*t3)+in5.*in22.*t12+in11.*in16.*t12;
if nargout > 1
    out2 = -in11.*t6.*(in12-in17+in2.*in18+in7.*in13)-in22.*t6.*t11+in11.*in16.*t7.*t11;
end
if nargout > 2
    out3 = in4.*in22.*t6+in11.*in15.*t6+in3.*in5.*in22.*t8+in3.*in11.*in16.*t8-in4.*in11.*in16.*t7+in5.*in11.*in14.*t8+in1.*in3.*in5.*in11.*in12.*2.0;
end
if nargout > 3
    out4 = -in3.*in5.*in22-in3.*in11.*in16-in5.*in11.*in14+in4.*in7.*in22.*t6+in4.*in11.*in18.*t6+in7.*in11.*in15.*t6-in4.*in7.*in11.*in16.*t7;
end
end


function [out1,out2,out3,out4] = F_floquet_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22)
%F_floquet_rhs_2
%    [OUT1,OUT2,OUT3,OUT4] = F_floquet_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    21-Mar-2025 16:38:15

t2 = in2.*in7;
t3 = in2.*in18;
t4 = in7.*in13;
t5 = in1.^2;
t6 = in12.^2;
t7 = in16.^2;
t8 = -in6;
t9 = -in17;
t10 = 1.0./in5;
t11 = t10.^2;
t12 = t10.^3;
t13 = in12.*t5;
t14 = t5-1.0;
t16 = in1+t2+t8;
t18 = in12+t3+t4+t9;
t15 = -t13;
t17 = in12+in13+in19+t15;
out1 = in5.*in22.*t17.*2.0+in11.*in16.*t17.*2.0+in16.*in22.*(in1+in2+in8-in1.^3./3.0).*2.0-in1.*in5.*in11.*t6.*2.0;
if nargout > 1
    out2 = in22.*t10.*t18.*-2.0-in11.*in13.*in18.*t10.*2.0+in11.*in16.*t11.*t18.*2.0+in16.*in22.*t11.*t16.*2.0-in11.*t7.*t12.*t16.*2.0;
end
if nargout > 2
    out3 = in15.*in22.*t10.*2.0+in3.*in5.*in11.*t6.*2.0-in4.*in16.*in22.*t11.*2.0-in11.*in15.*in16.*t11.*2.0+in3.*in16.*in22.*t14.*2.0+in5.*in14.*in22.*t14.*2.0+in11.*in14.*in16.*t14.*2.0+in4.*in11.*t7.*t12.*2.0+in1.*in3.*in5.*in12.*in22.*4.0+in1.*in3.*in11.*in12.*in16.*4.0+in1.*in5.*in11.*in12.*in14.*4.0;
end
if nargout > 3
    out4 = in3.*in16.*in22.*-2.0-in5.*in14.*in22.*2.0-in11.*in14.*in16.*2.0+in4.*in18.*in22.*t10.*2.0+in7.*in15.*in22.*t10.*2.0+in11.*in15.*in18.*t10.*2.0-in4.*in7.*in16.*in22.*t11.*2.0-in4.*in11.*in16.*in18.*t11.*2.0-in7.*in11.*in15.*in16.*t11.*2.0+in4.*in7.*in11.*t7.*t12.*2.0;
end
end

