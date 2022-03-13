function [E,T]=ETsw(e_Avg,Prss_Avg,Ta_Avg,rsc,LAI,Zh,rss,ustar,wnd_spd,As,A,VPD)

[Cp,Psy,rou,~,delta]= metalib(e_Avg,Prss_Avg,Ta_Avg);% get metro data
%%
% Calculate reference height of measurement (d0) and the roughness
% lengths(z0) governing the transfer of momentum [m]
z0=zeros(1,1);
X=(MyConstants.cd).*LAI;
d0=1.1*Zh.*log(1+X.^0.25);
z0(X<0.2)=(MyConstants.z0s)+0.3*Zh(X<0.2).*(X(X<0.2).^0.5);
z0(X>0.2)=0.3*Zh(X>0.2).*((1-d0(X>0.2))./Zh(X>0.2));
%%
% the eddy diffusion coefficient at the top of the canopy (Kh)
Kh=0.4*ustar.*(Zh-d0);

%%
%canopy boundary layer resistance (rac) and  the mean boundary layer
%resistance(rb), calcualted from the wind speed at the top of canopy
%(uh)and the characteristic leaf dimension (dl)
Uh=wnd_spd./(1+log(MyConstants.Zu_m-Zh+1));
rb=(100./(MyConstants.Km)).*((MyConstants.dl)./Uh)*0.5./(1-exp(-(MyConstants.Km)/2));
rac=rb./(2*LAI);

%%
%aerodynamic resistances ras and raa are calculated by integrating the eddy
%diffusion coefficients from the soil surface to the level of the
%preferred sink of momentum in the canopy [s/m]
raa=(1./(0.4*ustar)).*log(((MyConstants.Zu_m)-d0)./(Zh-d0))+(Zh./((MyConstants.Km).*Kh)).*(exp((MyConstants.Km).*(1-(d0+z0)./Zh))-1);
ras=(Zh.*(exp(MyConstants.Km))./((MyConstants.Km).*Kh)).*(exp((-(MyConstants.Km).*(MyConstants.z0s))./Zh)-exp(-(MyConstants.Km).*((d0+z0)./Zh)));

%%
%Two source SW model calculation
Rc=(delta+Psy).*rac+Psy.*rsc;
Rs=(delta+Psy).*ras+Psy.*rss;
Ra=(delta+Psy).*raa;
wc=1./(1+Rc.*Ra./(Rs.*(Rc+Ra)));
ws=1./(1+Rs.*Ra./(Rc.*(Rs+Ra)));
PMc=(delta.*A+(rou.*Cp.*VPD-delta.*rac.*As)./(raa+rac))./(delta+Psy.*(1+rsc./(raa+rac)));
PMs=(delta.*A+(rou.*Cp.*VPD-delta.*ras.*(A-As))./(raa+ras))./(delta+Psy.*(1+rss./(raa+ras)));
T=wc.*PMc;
E=ws.*PMs;
end
