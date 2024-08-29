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
   varargout{1}=struct('x',1:2,'p',3:16);
   return
  case 'argsize'
   varargout{1}=struct('x',2,'p',14);
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



function [out1,out2] = F_seg3_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32)
%F_seg3_rhs_0
%    [OUT1,OUT2] = F_seg3_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    29-Aug-2024 16:05:42

t2 = in9-1.0;
out1 = -in3.*in7.*t2.*(in1+in2+in6-in1.^3./3.0);
if nargout > 1
    out2 = (in7.*t2.*(in1-in4+in2.*in5))./in3;
end
end


function [out1,out2] = F_seg3_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32)
%F_seg3_rhs_1
%    [OUT1,OUT2] = F_seg3_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    29-Aug-2024 16:05:42

t2 = in2.*in5;
t3 = in1.^3;
t4 = -in4;
t5 = in9-1.0;
t6 = 1.0./in3;
t7 = t3./3.0;
t9 = in1+t2+t4;
t8 = -t7;
t10 = in1+in2+in6+t8;
out1 = -in3.*in7.*in25.*t10-in3.*in23.*t5.*t10-in7.*in19.*t5.*t10-in3.*in7.*t5.*(in17+in18+in22-in1.^2.*in17);
if nargout > 1
    out2 = in7.*in25.*t6.*t9+in23.*t5.*t6.*t9+in7.*t5.*t6.*(in17-in20+in2.*in21+in5.*in18)-in7.*in19.*t5.*t6.^2.*t9;
end
end


function [out1,out2] = F_seg3_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32)
%F_seg3_rhs_2
%    [OUT1,OUT2] = F_seg3_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    29-Aug-2024 16:05:42

t2 = in2.*in5;
t3 = in2.*in21;
t4 = in5.*in18;
t5 = in1.^2;
t6 = in1.^3;
t7 = -in4;
t8 = -in20;
t9 = in9-1.0;
t10 = 1.0./in3;
t11 = t10.^2;
t12 = in17.*t5;
t13 = t6./3.0;
t16 = in1+t2+t7;
t19 = in17+t3+t4+t8;
t14 = -t12;
t15 = -t13;
t17 = in17+in18+in22+t14;
t18 = in1+in2+in6+t15;
out1 = in3.*in7.*in25.*t17.*-2.0-in3.*in23.*in25.*t18.*2.0-in7.*in19.*in25.*t18.*2.0-in3.*in23.*t9.*t17.*2.0-in7.*in19.*t9.*t17.*2.0-in19.*in23.*t9.*t18.*2.0+in1.*in3.*in7.*in17.^2.*t9.*2.0;
if nargout > 1
    out2 = in7.*in25.*t10.*t19.*2.0+in23.*in25.*t10.*t16.*2.0+in23.*t9.*t10.*t19.*2.0+in7.*in19.^2.*t9.*t10.^3.*t16.*2.0+in7.*in18.*in21.*t9.*t10.*2.0-in7.*in19.*in25.*t11.*t16.*2.0-in7.*in19.*t9.*t11.*t19.*2.0-in19.*in23.*t9.*t11.*t16.*2.0;
end
end

