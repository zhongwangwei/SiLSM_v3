function [d_T,delta_Lb,delta_Le,e_Peclet,delta_Lb_s,exitfalg]=nonsteadyT(delta_v,xylem,T_c,Tr,delta_Lb_0,delta_Le_0,r_cw,e,lwc_c_0,lwc_c,Zh,wnd_spd,ObukhovLength,LAI,e_Peclet_0)
T_ck=T_c+273.15;
C=55.5*1000; % density of water, mol/m3

%###################resistance estimation################################
%Input Zh,wnd_spd,Obukhovlength
%output r_a r_bw, 
d0 = 0.666 * Zh;
z0mv = 0.123 * Zh;
z0hv = 0.1 * z0mv;
z0mg = 1 / 100;
z0hg = 1 * z0mg;
zm=3.95;
[Rav,~]=aerodynamicresistance(Zh,wnd_spd,ObukhovLength);
uv = wnd_spd * log((Zh - d0) / z0mv) / log((zm - d0) / z0mv); %Baldocchi et al., 1988
uca = -0.03 * LAI * LAI + 0.66 * LAI + 0.7;
uc = uv * (1 - exp(-uca)) / uca;
lw =0.02;%see campbell 1977 and wang et al. 2015
r_bw = 283 * (lw / uc) ^ 0.5 / 2 / LAI;
r_a = Rav - r_bw;


r_cw=r_cw./0.04/1000; % stomatal resistance upscaled to canopy, covert from s/mm to (m^2 s)/mol
r_a=r_a/0.04/1000; % aerodynamic resistance to water vapor diffusion convert s/mm to (m^2 s)/mol
if r_a>2500||r_a<0
    r_a=nan;
end
r_bw=r_bw/0.04/1000; % convert s/mm to (m^2 s)/mol
%###################resistance estimation################################





%############################## Peclet effect ##############################
L=2.3187e-009;% optimization result August 26, 2009
lambda = 2450*1000; % latent heat of vaporization J/kg
T=Tr./(lambda/1000.)/18.;  % transpiration rate of isotopically light water, mol/(m2 s)

D_Peclet=119*1e-009*exp(-637./(T_ck-137)); % m^2/s Cuntz_2007PCE
Peclet=(T*L)/(C*D_Peclet); % Peclet number, dimensionless;
e_Peclet=(1-exp(-1.*Peclet))./Peclet;
%############################## Peclet effect ##############################


%##############################  Nomorized Humidity ##############################
%Relative humidity of the ambient air reference to TL or TG, %
esattl=0.611*exp(17.3*T_c./(T_c+237.3));
rh_i=e/esattl;
%##############################  Nomorized Humidity ##############################

rho_v = 2.2*e./T_ck*1000;
g_t= 1./(r_cw+r_bw);% canopy conductance (stomata and boundary layer in series) to diffusion of the light molecules of water (in air), mol/(m2 s)
w_a=rho_v./18/(1.23*1000./29); % mole fraction of (light) water vapor in the air outside the leaf, mol/mol
w_i=w_a./rh_i; % mole fraction of (light) water vapour in air in the intercellular spaces, mol/mol


%##############################  Isotope pool ##############################
epsilon_k=(28*r_cw+19*r_bw)/(r_cw+r_a+r_bw); % per mil, kinetic fractionation, (Lee_2007_China chapter)
%epsilon_k=(32*r_s+21*r_b)/(r_s+r_b)/1000.; % kinetic fractionation, (Farquhar_1989,Cappa_2003_JGR)
alpha_k=1+epsilon_k/1000; % fractionation factor (>1) for diffusion;
alpha_eq=exp(1137./T_ck.^2-0.4156./T_ck-0.0020667); % majoube 1971
epsilon_eq=(1-1./alpha_eq)*1000;

delta_Le_s=xylem+epsilon_k+epsilon_eq+rh_i.*(delta_v-epsilon_k-xylem);
% if delta_Le_s>40||delta_Le_s<-40
%     delta_Le_s=nan;
% end
delta_Lb_s=0.8*delta_Le_s+(1-0.8)*xylem;

B_Le=(alpha_k*alpha_eq/(g_t*w_i))/(MyConstants.dt);
B_Lb=(alpha_k.*alpha_eq/(g_t*w_i))*e_Peclet/(MyConstants.dt);


Error_delta_Le= @ (delta_Le) delta_Le_s-B_Le*(lwc_c*e_Peclet*(delta_Le-xylem)-lwc_c_0*e_Peclet_0*(delta_Le_0-xylem))-delta_Le;
Error_delta_Lb= @ (delta_Lb) delta_Lb_s-B_Lb*(lwc_c*(delta_Lb-xylem)-lwc_c_0*(delta_Lb_0-xylem))-delta_Lb;
options=optimset('Display','iter','TolX',1e-006,'FunValCheck','on');

[x,fval,exitfalg,output]=fzero(Error_delta_Le,xylem);
[z,fval,exitflag,output]=fzero(Error_delta_Lb,xylem);
delta_Le=x;
delta_Lb=z;
% if delta_Le>20||delta_Le<-10
%     delta_Le=xylem;
% end
% if delta_Lb>20||delta_Lb<-10
%     delta_Lb=xylem;
% end

d_T=xylem+(delta_Le-delta_Le_s)./(alpha_k*alpha_eq*(1.-min(0.95,rh_i)));
end
