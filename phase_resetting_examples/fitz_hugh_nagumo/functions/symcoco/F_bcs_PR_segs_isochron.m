function varargout=F_bcs_PR_segs_isochron(action,varargin)
%% Automatically generated with matlabFunction
%#ok<*DEFNU,*INUSD,*INUSL>

switch action
  case 'nargs'
   varargout{1}=1;
   return
  case 'nout'
   varargout{1}=16;
   return
  case 'argrange'
   varargout{1}=struct('u',1:36);
   return
  case 'argsize'
   varargout{1}=struct('u',36);
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
nout=16;
order=varargin{1};
f=str2func(sprintf('F_bcs_PR_segs_isochron_%s_%d',action,order));
varargout=cell(nout,1);
[varargout{:}]=f(varargin{2:end});
end



function [out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16] = F_bcs_PR_segs_isochron_rhs_0(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32,in33,in34,in35,in36,in37,in38,in39,in40,in41,in42,in43,in44,in45,in46,in47,in48,in49,in50,in51,in52,in53,in54,in55,in56,in57,in58,in59,in60,in61,in62,in63,in64,in65,in66,in67,in68,in69,in70,in71,in72)
%F_bcs_PR_segs_isochron_rhs_0
%    [OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7,OUT8,OUT9,OUT10,OUT11,OUT12,OUT13,OUT14,OUT15,OUT16] = F_bcs_PR_segs_isochron_rhs_0(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32,IN33,IN34,IN35,IN36,IN37,IN38,IN39,IN40,IN41,IN42,IN43,IN44,IN45,IN46,IN47,IN48,IN49,IN50,IN51,IN52,IN53,IN54,IN55,IN56,IN57,IN58,IN59,IN60,IN61,IN62,IN63,IN64,IN65,IN66,IN67,IN68,IN69,IN70,IN71,IN72)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Mar-2025 10:28:47

out1 = in1-in17;
if nargout > 1
    out2 = in2-in18;
end
if nargout > 2
    out3 = in5-in13;
end
if nargout > 3
    out4 = in6-in14;
end
if nargout > 4
    out5 = in25.*(in1+in2+in28-in1.^3./3.0);
end
if nargout > 5
    t2 = -in7;
    out6 = in15+t2;
end
if nargout > 6
    t3 = -in8;
    out7 = in16+t3;
end
if nargout > 7
    out8 = -in19+in3.*in33;
end
if nargout > 8
    out9 = -in20+in4.*in33;
end
if nargout > 9
    out10 = sqrt(abs(in19).^2+abs(in20).^2)-1.0;
end
if nargout > 10
    out11 = -in1+in21;
end
if nargout > 11
    out12 = -in2+in22;
end
if nargout > 12
    out13 = -in9+in11-cos(in36);
end
if nargout > 13
    out14 = -in10+in12-sin(in36);
end
if nargout > 14
    out15 = t2.*(conj(in5)-conj(in23))+t3.*(conj(in6)-conj(in24));
end
if nargout > 15
    out16 = -in34+(in5-in23).^2+(in6-in24).^2;
end
end


function [out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16] = F_bcs_PR_segs_isochron_rhs_1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32,in33,in34,in35,in36,in37,in38,in39,in40,in41,in42,in43,in44,in45,in46,in47,in48,in49,in50,in51,in52,in53,in54,in55,in56,in57,in58,in59,in60,in61,in62,in63,in64,in65,in66,in67,in68,in69,in70,in71,in72)
%F_bcs_PR_segs_isochron_rhs_1
%    [OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7,OUT8,OUT9,OUT10,OUT11,OUT12,OUT13,OUT14,OUT15,OUT16] = F_bcs_PR_segs_isochron_rhs_1(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32,IN33,IN34,IN35,IN36,IN37,IN38,IN39,IN40,IN41,IN42,IN43,IN44,IN45,IN46,IN47,IN48,IN49,IN50,IN51,IN52,IN53,IN54,IN55,IN56,IN57,IN58,IN59,IN60,IN61,IN62,IN63,IN64,IN65,IN66,IN67,IN68,IN69,IN70,IN71,IN72)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Mar-2025 10:28:47

out1 = in37-in53;
if nargout > 1
    out2 = in38-in54;
end
if nargout > 2
    out3 = in41-in49;
end
if nargout > 3
    out4 = in42-in50;
end
if nargout > 4
    out5 = in61.*(in1+in2+in28-in1.^3./3.0)+in25.*(in37+in38+in64-in1.^2.*in37);
end
if nargout > 5
    out6 = -in43+in51;
end
if nargout > 6
    out7 = -in44+in52;
end
if nargout > 7
    out8 = -in55+in3.*in69+in33.*in39;
end
if nargout > 8
    out9 = -in56+in4.*in69+in33.*in40;
end
if nargout > 9
    t2 = abs(in19);
    t3 = abs(in20);
    t4 = conj(in19);
    t5 = conj(in20);
    out10 = (1.0./sqrt(t2.^2+t3.^2).*(t2.*(in55.*t4+in19.*conj(in55)).*1.0./sqrt(in19.*t4)+t3.*(in56.*t5+in20.*conj(in56)).*1.0./sqrt(in20.*t5)))./2.0;
end
if nargout > 10
    out11 = -in37+in57;
end
if nargout > 11
    out12 = -in38+in58;
end
if nargout > 12
    out13 = -in45+in47+in72.*sin(in36);
end
if nargout > 13
    out14 = -in46+in48-in72.*cos(in36);
end
if nargout > 14
    out15 = -in43.*(conj(in5)-conj(in23))-in44.*(conj(in6)-conj(in24))-in7.*(conj(in41)-conj(in59))-in8.*(conj(in42)-conj(in60));
end
if nargout > 15
    out16 = -in70+(in5-in23).*(in41-in59).*2.0+(in6-in24).*(in42-in60).*2.0;
end
end


function [out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16] = F_bcs_PR_segs_isochron_rhs_2(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32,in33,in34,in35,in36,in37,in38,in39,in40,in41,in42,in43,in44,in45,in46,in47,in48,in49,in50,in51,in52,in53,in54,in55,in56,in57,in58,in59,in60,in61,in62,in63,in64,in65,in66,in67,in68,in69,in70,in71,in72)
%F_bcs_PR_segs_isochron_rhs_2
%    [OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7,OUT8,OUT9,OUT10,OUT11,OUT12,OUT13,OUT14,OUT15,OUT16] = F_bcs_PR_segs_isochron_rhs_2(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14,IN15,IN16,IN17,IN18,IN19,IN20,IN21,IN22,IN23,IN24,IN25,IN26,IN27,IN28,IN29,IN30,IN31,IN32,IN33,IN34,IN35,IN36,IN37,IN38,IN39,IN40,IN41,IN42,IN43,IN44,IN45,IN46,IN47,IN48,IN49,IN50,IN51,IN52,IN53,IN54,IN55,IN56,IN57,IN58,IN59,IN60,IN61,IN62,IN63,IN64,IN65,IN66,IN67,IN68,IN69,IN70,IN71,IN72)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    24-Mar-2025 10:28:47

out1 = 0.0;
if nargout > 1
    out2 = 0.0;
end
if nargout > 2
    out3 = 0.0;
end
if nargout > 3
    out4 = 0.0;
end
if nargout > 4
    out5 = in61.*(in37+in38+in64-in1.^2.*in37).*2.0-in1.*in25.*in37.^2.*2.0;
end
if nargout > 5
    out6 = 0.0;
end
if nargout > 6
    out7 = 0.0;
end
if nargout > 7
    out8 = in39.*in69.*2.0;
end
if nargout > 8
    out9 = in40.*in69.*2.0;
end
if nargout > 9
    t2 = abs(in19);
    t3 = abs(in20);
    t4 = conj(in19);
    t5 = conj(in20);
    t6 = conj(in55);
    t7 = conj(in56);
    t8 = in72.^2;
    t9 = t2.^2;
    t10 = t3.^2;
    t11 = in19.*t4;
    t12 = in20.*t5;
    t13 = in19.*t6;
    t14 = in55.*t4;
    t15 = in20.*t7;
    t16 = in56.*t5;
    t17 = t13+t14;
    t18 = t15+t16;
    t19 = t9+t10;
    t20 = 1.0./sqrt(t11);
    t21 = 1.0./sqrt(t12);
    t22 = t17.^2;
    t23 = t18.^2;
    out10 = (1.0./sqrt(t19).*((t20.^2.*t22)./2.0+(t21.^2.*t23)./2.0-(t2.*t20.^3.*t22)./2.0-(t3.*t21.^3.*t23)./2.0+in55.*t2.*t6.*t20.*2.0+in56.*t3.*t7.*t21.*2.0))./2.0-(1.0./t19.^(3.0./2.0).*(t2.*t17.*t20+t3.*t18.*t21).^2)./4.0;
end
if nargout > 10
    out11 = 0.0;
end
if nargout > 11
    out12 = 0.0;
end
if nargout > 12
    out13 = t8.*cos(in36);
end
if nargout > 13
    out14 = t8.*sin(in36);
end
if nargout > 14
    out15 = in43.*(conj(in41)-conj(in59)).*-2.0-in44.*(conj(in42)-conj(in60)).*2.0;
end
if nargout > 15
    out16 = (in41-in59).^2.*2.0+(in42-in60).^2.*2.0;
end
end

