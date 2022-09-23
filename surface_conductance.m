% surface conductance (and gross primary production
%
% input variables
% T_sk: skin temperature (degK)
% PAR_t: PAR at the top of the canopy (W/m2)
% C_s: CO2 concentrattion at the leaf surface (mg/m3)
% D_s: vapor pressure deficient at the leaf (kPa)
% C_i: internal CO2 concentration (mg/m3)

% 
% input constants
% LAI: Leaf area index, dimensionless
% K_x: Light extinction coefficient, dimensionless
% a_1: empirical coefficient in the g_c model (dimensionless)
% (MyConstants.D0): empirical coefficient (saturation deficit) in the g_c model (kPa)
% g_min_c: cuticular conductance for CO2 (mm/s)
% 
% output
% A_g: gross primary production (mg/m2s)
% A_n: net primary productivity (mg/m2s)
% g_cc: surface conductance for CO2 (mm/s)
function [A_g,A_n,A_m,g_m,g_cc,Gamma,d1,d2,R_d] = surface_conductance(T_sk,PAR_t, C_s, D_s, C_i,LAI,theta)
    function [g_m]=mesophyll_conductance(T_sk)
        % mesophyll conductance
        % input variables
        % T_sk: skin temperature (degK)
        % input constants
        %  g_m_298: mesophyll conductance at 298 degK (7.0 mm/s)
        %  Q_10_g_m: Q10 value (2.0)
        %  T_1_g_m: lower temperature threshold (278 degK)
        %  T_2_g_m: upper temperature threshold (301 degK)
        % output
        % g_m: mm/s
        if MyConstants.C3==1
            g_m_298 = 7; % g_m_298: mesophyll conductance at 298 degK (7.0 mm/s)
            Q_10_g_m = 2.0; % Q_10_g_m: Q10 value (2.0)
            T_1_g_m = 278; % T_1_g_m: lower temperature threshold (278 degK)
            T_2_g_m = 301; % T2_g_m: upper temperature threshold
            g_m = g_m_298*Q_10_g_m^((T_sk-298)/10);
            g_m=g_m/((1+exp(0.3*(T_1_g_m-T_sk)))*(1+exp(0.3*(T_sk-T_2_g_m))));
        else
            g_m_298 = 17.5; % g_m_298: mesophyll conductance at 298 degK 
            Q_10_g_m = 2.0; % Q_10_g_m: Q10 value (2.0)
            T_1_g_m = 286; % T_1_g_m: lower temperature threshold 
            T_2_g_m = 309; % T2_g_m: upper temperature threshold 
            g_m = g_m_298*Q_10_g_m^((T_sk-298)/10);
            g_m=g_m/((1+exp(0.3*(T_1_g_m-T_sk)))*(1+exp(0.3*(T_sk-T_2_g_m))));      
        end
    end
    function [Gamma] = CO2_compensation_point(T_sk)
        % CO2 compensation point
        % input variables
        % 	T_sk: skin temperature (degK)
        % input constants
        %  Gamma_298: CO2 compensation point at 298 degK (68.5*1.2 mg/m3; assuming air density is 1.2 kg/m3)
        %  Q_10_Gamma: Q10 value (1.5)
        % output
        % Gamma: mg/m3
        if MyConstants.C3==1
            Gamma_298 = 68.5*1.23; % CO2 compensation point at 298 degK (68.5*rho_a mg/m3; air density in kg/m3)
        else
            Gamma_298 = 4.3*1.23; % CO2 compensation point at 298 degK (68.5*rho_a mg/m3; air density in kg/m3)
        end

        Q_10_Gamma = 1.5; %Q_10_Gamma: Q10 value for Gamma
        Gamma = Gamma_298 * Q_10_Gamma^((T_sk-298)/10);
    end
    function [alpha] = light_use_efficiency(Gamma,C_s)
        % light use efficiency
        % input variables
        % Gamma: CO2 compensation point (mg/m3)
        % C_s: CO2 concentration at the leaf surface (mg/m3)
        % input constants
        % alpha_0: light use efficiency at low light (mg/J)
        % output
        % alpha: mg/J
        if MyConstants.C3==1
            alpha_0 = 0.017; % alpha_0: light use efficiency at low light ( mg/J)
        else
            alpha_0 = 0.014;
        end
        alpha = alpha_0*(C_s-Gamma)/(C_s+2*Gamma);
    end                     
    function [A_m]=prim_prod(T_sk_0,g_m,Gamma,C_i_0)
        %to calculate A_m (primary_productivity)
        %       ++++++++++++++++++++++++++++
        %    We need call intl_co2_con to calculate C_i
        if MyConstants.C3==1
            A_m_max_298 = 2.2;
            Q_10_A_m    = 2.0;
            T_1_A_m     = 281.0;
            T_2_A_m     = 311.0;
        else
            A_m_max_298 = 1.7;
            Q_10_A_m=2.0;
            T_1_A_m = 286.0;
            T_2_A_m = 311.0;
        end
        A_m_max     = A_m_max_298.*(Q_10_A_m.^((T_sk_0-298.)/10.));
        A_m_max     = A_m_max./((1+exp(0.3*(T_1_A_m-T_sk_0))).*(1+exp(0.3*(T_sk_0-T_2_A_m))));
        A_m         = A_m_max.*(1-exp(-g_m*1e-3.*(C_i_0-Gamma)./A_m_max));
    end
    if MyConstants.C3==1 
        f0=0.89;%see egea et al. 2011
    else
        f0=0.85;
    end
    a_1=1./(1-f0);



%#########soil moisture stress#################################
    FC=0.36; % adjust according to John Baker's suggestion
    WP=0.18; % adjust according to John Baker's suggestion
    beta=max(0,min(1,(theta-WP)/(FC-WP))); %opt result 0.51679 0.52234 1.1982*
    f5=2*beta-beta.*beta;

%#########soil moisture stress#################################
    [g_m]   = mesophyll_conductance(T_sk);
    [Gamma] = CO2_compensation_point(T_sk); 
    [alpha] = light_use_efficiency(Gamma,C_s);
    [A_m]   = prim_prod(T_sk,g_m,Gamma,C_i);
    R_d     = 0.11*A_m;

if PAR_t<=0.001 % nighttime
    A_g=0;
    A_n=A_g-R_d*LAI;
    g_cc=MyConstants.g_min_c*LAI;
    d1=0;
    d2=0;
else
   d1=expint(alpha*(MyConstants.Kr)*PAR_t/(A_m+R_d)*exp(-(MyConstants.Kr)*LAI));
   d2=expint(alpha*(MyConstants.Kr)*PAR_t/(A_m+R_d));
   A_g=(A_m+R_d)*(LAI-(d1-d2)/(MyConstants.Kr)).*f5;% 
   A_n=(A_g-R_d*LAI); % A_n with soil water stress
  % g_cc=(g_min_c*LAI +1000* a_1*(A_m+R_d)*f_theta/((C_s-Gamma)*(1+D_s/(MyConstants.D0)))*(LAI-(d1-d2)/K_x));% g_cc with soil water stress
   g_cc=(MyConstants.g_min_c*LAI +1000* a_1*(A_m+R_d).*f5/((C_s-Gamma)*(1+D_s/(MyConstants.D0)))*(LAI-(d1-d2)/(MyConstants.Kr)));% g_cc with soil water stress
end
end


