function [Rav,Rag]=aerodynamicresistance(Zh,U,ObukhovLength)
%MyConstants.Zu_m the height of wind speed measurement (m)

%do the zero-plane displacement height (m)
d0=0.666*Zh;
% MyConstants.Zt_m the height of temperature and humidity measurement (m)
 
%Z0mv is the roughness length govering momentum transfer above vegetation canopy (m)
Z0mv=0.123*Zh;
%Z0hv is the roughness length govering heat and vapor transfer above vegetation canopy (m)
Z0hv=0.1*Z0mv;
%Z0mg is the roughness length govering momentum transfer above ground surface(m)
Z0mg=0.0001;
%Z0hg is the roughness length govering heat and vapor transfer above ground surface(m)
Z0hg=0.1*Z0mg;
%k von Karman constant 
k=0.41;

ZL=(d0-Zh)./ObukhovLength;
ZL(ZL>1)=1;
ZL(ZL<-1.5)=-1.5;
%get stability correction function
[stab_m,stab_h]=brutsaertstability(ZL);

%Rav the aerodynamic resistance for vegetation canopy(s m-1)
Rav=(log(((MyConstants.Zu_m)-d0)./Z0mv)-stab_m).*(log(((MyConstants.Zt_m)-d0)./Z0hv)-stab_h)./(k^2*U);
%Rav=(log(((MyConstants.Zu_m)-d0)./Z0mv)).*(log(((MyConstants.Zt_m)-d0)./Z0hv))./(k^2*U);

%Rag the aerodynamic resistance for ground surface(s m-1)
Rag=(log((MyConstants.Zu_m)./Z0mg)-stab_m).*(log((MyConstants.Zt_m)./Z0hg)-stab_h)./(k*k*U);
%Rag=(log((MyConstants.Zu_m)./Z0mg)).*(log((MyConstants.Zt_m)./Z0hg))./(k*k*U);

end
%Rbh=2./(k*ustar)*()
