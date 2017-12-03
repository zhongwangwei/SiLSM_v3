
function [Tc]=Tc_Taylor_Expansion_theory(Ta_Avg,Rh_Avg,rsc,Rav,T,P)
ea_air=0.6108*exp(17.27*Ta_Avg./(Ta_Avg + 237.3)).*Rh_Avg; %Kpa
esat_air=0.6108*exp(17.27*Ta_Avg./(Ta_Avg + 237.3));%Kpa

%qsatta = 0.622 * esat_air / (P - 0.378 * esat_air);
%qa = 0.622 * ea_air / (P - 0.378 * ea_air);
%diff_eas=0.611*17.502*240.97*exp(17.502*Ta_Avg./((240.97+Ta_Avg).^2))/1000;
[Cp,Psy,~,~,~]= metalib(ea_air,P,Ta_Avg);%Psy=P*Cp/0.622lamda

%Tak=Ta_Avg+273.15;
diff_eas=-(1527*exp((1727*Ta_Avg)./(100*(Ta_Avg + 2373/10))).*((1727*Ta_Avg)./(100*(Ta_Avg + 2373/10).^2) - 1727./(100*(Ta_Avg + 2373/10))))/2500;
% [zenith,~]= Solar_zenith_angle(Year, Month, Day, Hour, Minute);
% K=0.5;
% kr=K./cosd(zenith);
%kr=0.6;
%C=1./(1-exp(-kr.*LAI));
%rou.*(esatL-e_Avg)./(Rav+rc).*Cp./Psy;
%ga=1./(Rav);
gw=1./(Rav+rsc);
%Epsilon=1.24 * (ea_air ./ (Ta_Avg +273.15)).^ (1 / 7) ;
%dlwr = 1.24 * (ea_air ./ (Ta_Avg +273.15)) .^ (1 / 7) .* sigma .* ((Ta_Avg +273.15).^ 4);

%Q=(1 - alpha_v) * Rs_inc_Avg + dlwr;
%Lambda=2503-2.39*(Ta_Avg);


rhoa = 1.293 * 273.15 ./ (273.15 + Ta_Avg) .* P ./ 101.325 .* (1 - 0.378 * ea_air./ P);
%Tc=Ta_Avg+(0.622*Lambda*rhoa*gw*(esat_air-ea_air)/P)/esat_air;
DD=T.*Psy./(Cp.*rhoa.*gw);
D=esat_air-ea_air;
Tc=(DD-D)./diff_eas+Ta_Avg;
%Tc=(Q-Epsilon.*sigma.*Tak.*Tak.*Tak.*Tak-C.*T)./(C.*rou.*Cp.*ga+4*Epsilon.*sigma.*Tak.*Tak.*Tak);
%Tc=abs(Tc);
%Tc=(Ta_Avg-Rn_Avg.*(-0.00947)+2.002);

end