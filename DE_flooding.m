function [Delta_E_O,Delta_E_D]=DE_flooding(Ta_Avg,Ts,ea,RH,DSWO,DO)
Tak=Ta_Avg+273.15;
Tsk=Ts+273.15;
Delta_O_surface=DSWO;
Delta_O_air=DO;
es=0.611*exp(17.3*Ta_Avg./(Ta_Avg+237.3));
ew=0.611*exp(17.3*Ts./(Ts+237.3));
RH1=RH.*(es./ew);
alpha_O=1./(exp(1137./(Tsk.*Tsk)-0.4156./Tsk-0.002067));
AK_0=0.67*(1-0.9691)*1000;
Aeq=(1-alpha_O)*1000;
Delta_E_O=(alpha_O.*Delta_O_surface-RH1.*DO-Aeq-(1-RH1).*AK_0)./((1-RH1)+0.001*((1-RH1).*AK_0));


% Delta_D_surface=DSWD;
% Delta_D_air=DD;
% alpha_D=1./(exp(24840./(Tsk.*Tsk)-76.25./Tsk+0.0526));
% Delta_epsilon_D=(1-RH1)*(1.0125-1)*1000;
% epsilon_D=(1-alpha_D)*1000+Delta_epsilon_D;
% AK=0.67*(1-0.9839)*1000;
% Delta_E_D=(alpha_D.*Delta_D_surface-RH1.*Delta_D_air-(1-alpha_D)*1000-(1-RH1).*AK)./(1-RH1+0.001*(1-RH1).*AK);

end
