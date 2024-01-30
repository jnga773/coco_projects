function varargout=F_seg1(action,varargin)
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
   varargout{1}=struct('x',1:4,'p',5:17);
   return
  case 'argsize'
   varargout{1}=struct('x',4,'p',13);
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
f=str2func(sprintf('F_seg1_%s_%d',action,order));
varargout=cell(nout,1);
[varargout{:}]=f(varargin{2:end});
end



function [out1,out2,out3,out4] = F_seg1_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32,in33,in34)
%F_seg1_rhs_0
%    [OUT1,OUT2,OUT3,OUT4] = F_seg1_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32,IN33,IN34)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    31-Jan-2024 08:58:21

out1 = in5.*in13.*(in1+in2+in8-in1.^3./3.0);
if nargout > 1
    t2 = 1.0./in5;
    out2 = -in13.*t2.*(in1-in6+in2.*in7);
end
if nargout > 2
    out3 = in13.*(in4.*t2+in3.*in5.*(in1.^2-1.0));
end
if nargout > 3
    out4 = -in13.*(in3.*in5-in4.*in7.*t2);
end
end


function [out1,out2,out3,out4] = F_seg1_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32,in33,in34)
%F_seg1_rhs_1
%    [OUT1,OUT2,OUT3,OUT4] = F_seg1_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32,IN33,IN34)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    31-Jan-2024 08:58:21

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
out1 = in5.*in13.*(in18+in19+in25-in18.*t3)+in5.*in30.*t12+in13.*in22.*t12;
if nargout > 1
    out2 = -in13.*t6.*(in18-in23+in2.*in24+in7.*in19)-in30.*t6.*t11+in13.*in22.*t7.*t11;
end
if nargout > 2
    out3 = in30.*(in4.*t6+in3.*in5.*t8)+in13.*(in21.*t6+in3.*in22.*t8-in4.*in22.*t7+in5.*in20.*t8+in1.*in3.*in5.*in18.*2.0);
end
if nargout > 3
    out4 = -in30.*(in3.*in5-in4.*in7.*t6)-in13.*(in3.*in22+in5.*in20-in4.*in24.*t6-in7.*in21.*t6+in4.*in7.*in22.*t7);
end
end


function [out1,out2,out3,out4] = F_seg1_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32,in33,in34)
%F_seg1_rhs_2
%    [OUT1,OUT2,OUT3,OUT4] = F_seg1_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32,IN33,IN34)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    31-Jan-2024 08:58:21

t2 = in2.*in7;
t3 = in2.*in24;
t4 = in7.*in19;
t5 = in1.^2;
t6 = in18.^2;
t7 = in22.^2;
t8 = -in6;
t9 = -in23;
t10 = 1.0./in5;
t11 = t10.^2;
t12 = t10.^3;
t13 = in18.*t5;
t14 = t5-1.0;
t16 = in1+t2+t8;
t18 = in18+t3+t4+t9;
t15 = -t13;
t17 = in18+in19+in25+t15;
out1 = in5.*in30.*t17.*2.0+in13.*in22.*t17.*2.0+in22.*in30.*(in1+in2+in8-in1.^3./3.0).*2.0-in1.*in5.*in13.*t6.*2.0;
if nargout > 1
    out2 = in30.*t10.*t18.*-2.0-in13.*in19.*in24.*t10.*2.0+in13.*in22.*t11.*t18.*2.0+in22.*in30.*t11.*t16.*2.0-in13.*t7.*t12.*t16.*2.0;
end
if nargout > 2
    out3 = in30.*(in21.*t10-in4.*in22.*t11+in3.*in22.*t14+in5.*in20.*t14+in1.*in3.*in5.*in18.*2.0).*2.0+in13.*(in3.*in5.*t6.*2.0-in21.*in22.*t11.*2.0+in20.*in22.*t14.*2.0+in4.*t7.*t12.*2.0+in1.*in3.*in18.*in22.*4.0+in1.*in5.*in18.*in20.*4.0);
end
if nargout > 3
    out4 = -in13.*(in20.*in22.*2.0-in21.*in24.*t10.*2.0+in4.*in22.*in24.*t11.*2.0+in7.*in21.*in22.*t11.*2.0-in4.*in7.*t7.*t12.*2.0)-in30.*(in3.*in22+in5.*in20-in4.*in24.*t10-in7.*in21.*t10+in4.*in7.*in22.*t11).*2.0;
end
end

