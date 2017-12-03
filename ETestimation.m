function [Es,Tr,rsc2,rss,Tc]=ETestimation(Zh,Ta_Avg,e_Avg,co2,K_d,T_c_0,LAI,Rh_Avg,Prss_Avg,ustar,wnd_spd,ObukhovLength,As,A,theta,theta_2,VPD)

T_ck_0=T_c_0+273.15;

rho_a = 1.23;  % air density at sea leve kg/m3

lambda = 2450*1000; % latent heat of vaporization J/kg

rss=exp(8.206-4.225*theta)*(MyConstants.rss_v);% Soil resistance

[Rav,~]=aerodynamicresistance(Zh,wnd_spd,ObukhovLength);% aero dynamic resistance
%--------------------------------------------------------------------------------------------------------------------------------------------------------- 
%!! first guess 
C_a=co2;%*1.8; % approximate, mg/m3? convert ppm to mg/m3
C_s=C_a;
PAR_t=K_d./2; % shortwave radiation in PAR waveband, W/m2
D_s_0=1.15; % kPa
%C_s_0=688; %mg/m3
C_i_0=400; % mg/m3
%T_ck_0=300; %degK


for i=1:10 % repeating 40 times to get more precise estimate of C_s, D_s and C_i
    [A_g,A_n,~,~,g_cc,Gamma,~,~,~] = surface_conductance(T_ck_0,PAR_t, C_s, D_s_0, C_i_0,LAI,theta_2);
    g_cw=g_cc*1.6; % mm/s  
    rsc=1./g_cw;
    rsc2=rsc*1000;
    rsc2(rsc2<0)=0;
    [Es,Tr]=ETsw(e_Avg,Prss_Avg,Ta_Avg,rsc2,LAI,Zh,rss,ustar,wnd_spd,As,A,VPD);
    if Tr<0
        Tr=0;
    end
    [Tc]=Tc_Taylor_Expansion_theory(Ta_Avg,Rh_Avg,rsc2,Rav,Tr,Prss_Avg);
   % Tc(abs(Tc-Ta_Avg)<10)=Ta_Avg;
    T_ck_0=Tc+273.15;  
    
    C_i = C_s - A_n/(g_cc/1000); % converting g_cc to m/s
    C_i_min = C_s - A_n./(g_cc/1000+A_g./(C_s-Gamma)); % converting g_cc to m/s
    C_i_min(C_i_min<=0)=400;
    C_i(C_i<C_i_min)=C_i_min;
    C_i_0=C_i;
    
    D_s= (Prss_Avg/0.622).*(Tr)./(rho_a.*lambda.*(g_cw/1000));
    D_s(isnan(D_s)==1)=1.15;

    D_s_0=D_s;
    if C_s<200||C_s>1000
        C_s=688;
    end
end

end














