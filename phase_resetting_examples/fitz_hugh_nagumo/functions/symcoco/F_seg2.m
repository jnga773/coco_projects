function varargout=F_seg2(action,varargin)
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
   varargout{1}=struct('x',1:4,'p',5:16);
   return
  case 'argsize'
   varargout{1}=struct('x',4,'p',12);
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
f=str2func(sprintf('F_seg2_%s_%d',action,order));
varargout=cell(nout,1);
[varargout{:}]=f(varargin{2:end});
end



function [out1,out2,out3,out4] = F_seg2_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32)
%F_seg2_rhs_0
%    [OUT1,OUT2,OUT3,OUT4] = F_seg2_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Mar-2025 11:56:16

t2 = in12-1.0;
out1 = -in5.*in9.*t2.*(in1+in2+in8-in1.^3./3.0);
if nargout > 1
    t3 = 1.0./in5;
    out2 = in9.*t2.*t3.*(in1-in6+in2.*in7);
end
if nargout > 2
    out3 = -in4.*in9.*t2.*t3-in3.*in5.*in9.*t2.*(in1.^2-1.0);
end
if nargout > 3
    out4 = in3.*in5.*in9.*t2-in4.*in7.*in9.*t2.*t3;
end
end


function [out1,out2,out3,out4] = F_seg2_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32)
%F_seg2_rhs_1
%    [OUT1,OUT2,OUT3,OUT4] = F_seg2_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Mar-2025 11:56:16

t2 = in2.*in7;
t3 = in1.^2;
t4 = in1.^3;
t5 = -in6;
t6 = in12-1.0;
t7 = 1.0./in5;
t8 = t7.^2;
t9 = t3-1.0;
t10 = t4./3.0;
t12 = in1+t2+t5;
t11 = -t10;
t13 = in1+in2+in8+t11;
out1 = -in5.*in9.*in28.*t13-in5.*in25.*t6.*t13-in9.*in21.*t6.*t13-in5.*in9.*t6.*(in17+in18+in24-in17.*t3);
if nargout > 1
    out2 = in9.*in28.*t7.*t12+in25.*t6.*t7.*t12+in9.*t6.*t7.*(in17-in22+in2.*in23+in7.*in18)-in9.*in21.*t6.*t8.*t12;
end
if nargout > 2
    out3 = -in4.*in9.*in28.*t7-in4.*in25.*t6.*t7-in9.*in20.*t6.*t7-in3.*in5.*in9.*in28.*t9-in3.*in5.*in25.*t6.*t9-in3.*in9.*in21.*t6.*t9+in4.*in9.*in21.*t6.*t8-in5.*in9.*in19.*t6.*t9-in1.*in3.*in5.*in9.*in17.*t6.*2.0;
end
if nargout > 3
    out4 = in3.*in5.*in9.*in28+in3.*in5.*in25.*t6+in3.*in9.*in21.*t6+in5.*in9.*in19.*t6-in4.*in7.*in9.*in28.*t7-in4.*in7.*in25.*t6.*t7-in4.*in9.*in23.*t6.*t7-in7.*in9.*in20.*t6.*t7+in4.*in7.*in9.*in21.*t6.*t8;
end
end


function [out1,out2,out3,out4] = F_seg2_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32)
%F_seg2_rhs_2
%    [OUT1,OUT2,OUT3,OUT4] = F_seg2_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Mar-2025 11:56:16

t2 = in2.*in7;
t3 = in2.*in23;
t4 = in7.*in18;
t5 = in1.^2;
t6 = in1.^3;
t7 = in17.^2;
t8 = in21.^2;
t9 = -in6;
t10 = -in22;
t11 = in12-1.0;
t12 = 1.0./in5;
t13 = t12.^2;
t14 = t12.^3;
t15 = in17.*t5;
t16 = t5-1.0;
t17 = t6./3.0;
t20 = in1+t2+t9;
t23 = in17+t3+t4+t10;
t18 = -t15;
t19 = -t17;
t21 = in17+in18+in24+t18;
t22 = in1+in2+in8+t19;
out1 = in5.*in9.*in28.*t21.*-2.0-in5.*in25.*in28.*t22.*2.0-in9.*in21.*in28.*t22.*2.0-in5.*in25.*t11.*t21.*2.0-in9.*in21.*t11.*t21.*2.0-in21.*in25.*t11.*t22.*2.0+in1.*in5.*in9.*t7.*t11.*2.0;
if nargout > 1
    out2 = in9.*in28.*t12.*t23.*2.0+in25.*in28.*t12.*t20.*2.0+in25.*t11.*t12.*t23.*2.0+in9.*in18.*in23.*t11.*t12.*2.0-in9.*in21.*in28.*t13.*t20.*2.0-in9.*in21.*t11.*t13.*t23.*2.0-in21.*in25.*t11.*t13.*t20.*2.0+in9.*t8.*t11.*t14.*t20.*2.0;
end
if nargout > 2
    out3 = in4.*in25.*in28.*t12.*-2.0-in9.*in20.*in28.*t12.*2.0-in20.*in25.*t11.*t12.*2.0+in4.*in9.*in21.*in28.*t13.*2.0-in3.*in5.*in25.*in28.*t16.*2.0-in3.*in9.*in21.*in28.*t16.*2.0-in5.*in9.*in19.*in28.*t16.*2.0-in3.*in5.*in9.*t7.*t11.*2.0+in4.*in21.*in25.*t11.*t13.*2.0+in9.*in20.*in21.*t11.*t13.*2.0-in3.*in21.*in25.*t11.*t16.*2.0-in5.*in19.*in25.*t11.*t16.*2.0-in9.*in19.*in21.*t11.*t16.*2.0-in4.*in9.*t8.*t11.*t14.*2.0-in1.*in3.*in5.*in9.*in17.*in28.*4.0-in1.*in3.*in5.*in17.*in25.*t11.*4.0-in1.*in3.*in9.*in17.*in21.*t11.*4.0-in1.*in5.*in9.*in17.*in19.*t11.*4.0;
end
if nargout > 3
    out4 = in3.*in5.*in25.*in28.*2.0+in3.*in9.*in21.*in28.*2.0+in5.*in9.*in19.*in28.*2.0+in3.*in21.*in25.*t11.*2.0+in5.*in19.*in25.*t11.*2.0+in9.*in19.*in21.*t11.*2.0-in4.*in7.*in25.*in28.*t12.*2.0-in4.*in9.*in23.*in28.*t12.*2.0-in7.*in9.*in20.*in28.*t12.*2.0-in4.*in23.*in25.*t11.*t12.*2.0-in7.*in20.*in25.*t11.*t12.*2.0-in9.*in20.*in23.*t11.*t12.*2.0+in4.*in7.*in9.*in21.*in28.*t13.*2.0+in4.*in7.*in21.*in25.*t11.*t13.*2.0+in4.*in9.*in21.*in23.*t11.*t13.*2.0+in7.*in9.*in20.*in21.*t11.*t13.*2.0-in4.*in7.*in9.*t8.*t11.*t14.*2.0;
end
end

