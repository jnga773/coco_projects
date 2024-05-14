function varargout=F_seg3(action,varargin)
%% Automatically generated with matlabFunction
%#ok<*DEFNU,*INUSD,*INUSL>

switch action
  case 'nargs'
   varargout{1}=2;
   return
  case 'nout'
   varargout{1}=2;
   return
  case 'argrange'
   varargout{1}=struct('x',1:2,'p',3:15);
   return
  case 'argsize'
   varargout{1}=struct('x',2,'p',13);
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
nout=2;
order=varargin{1};
f=str2func(sprintf('F_seg3_%s_%d',action,order));
varargout=cell(nout,1);
[varargout{:}]=f(varargin{2:end});
end



function [out1,out2] = F_seg3_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30)
%F_seg3_rhs_0
%    [OUT1,OUT2] = F_seg3_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    31-Jan-2024 08:58:23

t2 = in10-1.0;
out1 = -in3.*t2.*(in1+in2+in6-in1.^3./3.0);
if nargout > 1
    out2 = (t2.*(in1-in4+in2.*in5))./in3;
end
end


function [out1,out2] = F_seg3_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30)
%F_seg3_rhs_1
%    [OUT1,OUT2] = F_seg3_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    31-Jan-2024 08:58:23

t2 = in2.*in5;
t3 = in1.^3;
t4 = -in4;
t5 = in10-1.0;
t6 = 1.0./in3;
t7 = t3./3.0;
t9 = in1+t2+t4;
t8 = -t7;
t10 = in1+in2+in6+t8;
out1 = -in3.*t5.*(in16+in17+in21-in1.^2.*in16)-in3.*in25.*t10-in18.*t5.*t10;
if nargout > 1
    out2 = t5.*t6.*(in16-in19+in2.*in20+in5.*in17)+in25.*t6.*t9-in18.*t5.*t6.^2.*t9;
end
end


function [out1,out2] = F_seg3_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30)
%F_seg3_rhs_2
%    [OUT1,OUT2] = F_seg3_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    31-Jan-2024 08:58:23

t2 = in2.*in5;
t3 = in2.*in20;
t4 = in5.*in17;
t5 = in1.^2;
t6 = -in4;
t7 = -in19;
t8 = in10-1.0;
t9 = 1.0./in3;
t10 = t9.^2;
t11 = in16.*t5;
t13 = in1+t2+t6;
t15 = in16+t3+t4+t7;
t12 = -t11;
t14 = in16+in17+in21+t12;
out1 = in3.*in25.*t14.*-2.0-in18.*t8.*t14.*2.0-in18.*in25.*(in1+in2+in6-in1.^3./3.0).*2.0+in1.*in3.*in16.^2.*t8.*2.0;
if nargout > 1
    out2 = in25.*t9.*t15.*2.0+in17.*in20.*t8.*t9.*2.0-in18.*in25.*t10.*t13.*2.0-in18.*t8.*t10.*t15.*2.0+in18.^2.*t8.*t9.^3.*t13.*2.0;
end
end
