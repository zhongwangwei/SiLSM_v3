%%
clc;
clear ;
%-----------------Declare constant variables-----------------%


%% 


%-----------------   Load Data matrix     -----------------%
load('test.mat')
%-----------------   Load Data matrix     -----------------%
%% 
%-----------------   Load date data     -----------------%
% continuous data is required. If data gap exist, please fill with NaN
Year	      = data	(:,	1   ); %Year
Month	      = data	(:,	2	); %Month
Day	          = data	(:,	3	); %Day
Hour	      = data	(:,	4	); %Hour

%-----------------   Load Energy data     -----------------% 
H             = data	(:,	5	); %Sensible heat, used as validation                       [W/m2]
LE            = data	(:,	6	); %Latent heat, used as validation                         [W/m2]
Gs_Avg        = data	(:,	7	); %Ground heat, used as validation                         [W/m2]
Rn_Avg        = data	(:,	8	); %Net radiation, used as model input                      [W/m2]
Rs_inc_Avg    = data	(:,	9	); %Income solar radiation, used as model input             [W/m2]

%-----------------   Load Metro data     -----------------% 
Rh_Avg        = data	(:,	10	); %Relative humidity, used as model input                  [-]
Ta_Avg        = data	(:,	11	); %Air temperature, used as model input                    [C]
U             = data	(:,	12	); %wind speed , used as model input                        [m/s]
Prss_Avg      = data	(:,	13	); %Air pressure , used as model input                      [Kpa]
VPD_Avg       = data	(:,	14	); %VPD data , used as model input                          [Kpa]
CO2           = data	(:,	15	); %CO2 concentrition                                       [mg/m3]
                %if no data available, set to NaN below
ObukhovLength = data	(:,	16	); %ObukhovLength length,used as model input                [m]
ustar         = data	(:,	17	); %Friction velocity, used as model input                  [m/s]
Rain          = data	(:,	18	); %Precipitation amount, used as Diagnostic parameters     [mm]

%-----------------   Load Surface and ground data     -----------------% 
LAI           = data	(:,	19	); %Leaf area index, used as model input                    [m2/m2]
theta         = data	(:,	20	); %Soil moisture at top layer,  used as model input        [-]
Ts_Avg	      = data	(:,	21	); %Soil temperature at top layer, used as model input      [C]
Zh            = data	(:,	22	); %Vegetation Height, used as model input                  [m]
                %if no data available, set theta_2=theta
theta_2       = data	(:,	23	); %Soil moisture at root layer, used as model input        [-] 

%-----------------   Load isotope data     -----------------% 
if MyConstants.Isotope==1
Soil_DO       = data	(:,	24	); %Soil water isotope, used as model input                 [per mil]
Xylem_DO      = data	(:,	25	); %Stem water isotope, used as model input                 [per mil]
Leaf_DO       = data	(:,	26	); %Bulk Leaf water isotope, used as Diagnostic parameters  [per mil]
Vapor_DO      = data	(:,	27	); %Vapor water isotope, used as model input                [per mil]
lwc           = data	(:,	28	); %leaf water content                                      [g/m2]
ET_DO         = data	(:,	29	);
end
%-----------------   Load other data     -----------------% 
if MyConstants.Flooding==1
WaterDepth    = data	(:,	30	); %Water depth, used as model input                        [m]
WaterTemp     = data	(:,	31	); %Water temperature, used as model input                  [C]
end

QCflag=ones(length(Year),1);
%%
%-----------------  convet     -----------------% 
theta(theta>1)         = theta(theta>1) /100;
Rh_Avg(Rh_Avg>1)       = Rh_Avg(Rh_Avg>1)/100;
Ta_Avg(Ta_Avg>50)      = Ta_Avg(Ta_Avg>50)-273.15;
Ts_Avg(Ts_Avg>50)      = Ts_Avg(Ts_Avg>50)-273.15;

%%
%----------------- linear fill LAI   -----------------% 
yy = datenum(Year, Month, Day, Hour, 0, 0);
LAI(1)=0.2;
aa=yy(~isnan(LAI));
bb=LAI(~isnan(LAI));
c=interp1(aa,bb,yy,'linear','extrap');   
LAI=c;
%for test case
LAI(Month==6&Day<11)=2.5;
clear yy aa bb c
%%
%----------------- linear fill lwc   -----------------% 
if MyConstants.Isotope==1&&MyConstants.lwc_measurement==0
   lwc=120*LAI./18.;
elseif MyConstants.Isotope==1&&MyConstants.lwc_measurement==1
   yy = datenum(Year, Month, Day, Hour, 0, 0); 
   o  = yy;
   o1 = yy((Hour==12|Hour==13|Hour==14|Hour==15)&isnan(lwc)==0);
   o2 = lwc((Hour==12|Hour==13|Hour==14|Hour==15)&isnan(lwc)==0);
   lwc_midday=interp1(o1,o2,o,'linear');
   lwc=10.*sin(yy*2*pi+pi/4)+lwc_midday+10; % g/m2  water content every leaf
   lwc(isnan(lwc)==1)=120*LAI(isnan(lwc)==1)./18.;
   clear yy o o1 o2 lwc_midday
end
%%
%----------------- linear fill Xylem_DO   -----------------% 
%Caution:  resulted large uncertainty.
if MyConstants.Isotope==1
    yy = datenum(Year, Month, Day, Hour, 0, 0); 
    aa=yy(~isnan(Xylem_DO));
    bb=Xylem_DO(~isnan(Xylem_DO));
    cc=interp1(aa,bb,yy,'linear','extrap');   
    Xylem_DO_fill=cc;
    clear aa bb cc yy
end
%%
yy = datenum(Year, Month, Day, Hour, 0, 0); 
Zh(1)=0.1;
aa=yy(~isnan(Zh));
bb=Zh(~isnan(Zh));
c=interp1(aa,bb,yy,'linear','extrap');   
Zh=c;
clear aa bb c yy 

%%
%calculate Metro varaible
e_Avg=0.6108*exp(17.27*Ta_Avg./(Ta_Avg + 237.3)).*Rh_Avg; %Kpa
esat_air=0.6108*exp(17.27*Ta_Avg./(Ta_Avg + 237.3));%Kpa
VPD_Avg(isnan(VPD_Avg)==1)=esat_air(isnan(VPD_Avg)==1)-e_Avg(isnan(VPD_Avg)==1);
%%
%----------------- Calculate ground heat and water storage heat  -----------------% 
if MyConstants.Flooding==1
    cw=4184;%water specific heat;[Jkg-1K-1]
    rouw=1000;% water density     [kgm-3]
    Gw=ones(length(Year),1);
    Gw(1)=0.0;
    for i=2:length(Year)
        Gw(i)=cw*rouw*(WaterDepth(i)).*(WaterTemp(i)-WaterTemp(i-1))/ MyConstants.dt;
    end
    G=Gs_Avg+Gw; %ground heat + water storage heat
else
    G=Gs_Avg;
end
clear Gs_Avg GW cw rouw i
%%
%%
%Check the flux imblance
imbalance=abs(1-(Rn_Avg-G)./(H+LE));
QCflag(imbalance>0.2)=0;%Mark as unrelaible data

%Force flux balance
if MyConstants.Flooding==1
    G(imbalance>0.2)=Rn_Avg(imbalance>0.2)*0.2; %if flooding,G is more unreliable, force it =0.2Rn
end 
[LE_c,H_c]=flux_c(G,H,LE,Rn_Avg);
w_T=H_c./1.23/1004;
ObukhovLength(isnan(ObukhovLength)==1)=((ustar(isnan(ObukhovLength)==1)).^3./(0.4*(9.8./Ta_Avg(isnan(ObukhovLength)==1)).*(w_T(isnan(ObukhovLength)==1))));


%QCcheck
QCflag(LE_c>800|LE_c<-100)=0;
QCflag(H_c>800|H_c<-100)=0;
QCflag(Rn_Avg>1000|Rn_Avg<-200)=0;
QCflag(Rn_Avg>1000|Rn_Avg<-200)=0;
QCflag(Rh_Avg>=1)=0;
QCflag(ustar<0.06)=0;
if MyConstants.Flooding==1
   QCflag(WaterDepth>0)=0;
end

if Rain(1)>0
   QCflag(1)=0;
end
for i=2:length(Year)-1
  if Rain(i)>0
    for j=-1:1:1
        QCflag(i+j)=0;
    end
  end
end

%%
%###############################
A=Rn_Avg-G;                              %Total available energy               [w/m2]
Rns=Rn_Avg.*exp(-(MyConstants.Kr).*LAI); %Radiation reaching the soil surface  [w/m2]
As=Rns-G;                                %Available energy for the soil surface[w/m2] 

%initialization
Es=zeros(length(Zh),1);                  %Soil evaporation                     [w/m2] 
Tr=zeros(length(Zh),1);                  %Canopy evaporation                   [w/m2] 
rsc=zeros(length(Zh),1);                 %Canopy resistance                    [s/m] 
rss=zeros(length(Zh),1);                 %Soil resistance                      [s/m] 
Tem_c=zeros(length(Zh),1);               %Canopy temperature                   [C] 
k=length(Zh);
Tc_temp=Ta_Avg+2.0;%Assume canopy temperature is 2 degree higher than air temperature
%%
%S-W model
for i=1:k
[Es(i),Tr(i),rsc(i),rss(i),Tem_c(i)]=ETestimation(Zh(i),Ta_Avg(i),e_Avg(i),CO2(i),...
    Rs_inc_Avg(i),Tc_temp(i),LAI(i),Rh_Avg(i),...
    Prss_Avg(i),ustar(i),U(i),ObukhovLength(i)...
    ,As(i),A(i),theta(i),theta_2(i),VPD_Avg(i));
end

Tr(Tr<0)=0;


LES=Es+Tr;
%plot(LE_c(LES<800&LE_c<800&LE_c>-100&QCflag==1),LES(LES<800&LE_c<800&LE_c>-100&QCflag==1))
TET_sw=(Tr./LES);
%  plot(LE_c(LES<800&LE_c<800&LE_c>-100),LES(LES<800&LE_c<800&LE_c>-100))
%cftool(LE_c(LES<800&LE_c<800&LE_c>-100&QCflag==1),LES(LES<800&LE_c<800&LE_c>-100&QCflag==1))
%  plot(T./LES)
%% 


% 
delta_Lb_s=Xylem_DO_fill;
d_T=Xylem_DO_fill;
d_L=Xylem_DO_fill;
d_e=Xylem_DO_fill;
e_Peclet=zeros(length(Zh),1);
e_Peclet(1:length(Zh))=0.9;
  [d_T(1),d_L(1),d_e(1),e_Peclet(1),delta_Lb_s(1),exitfalg(1)]...
            =nonsteadyT(Vapor_DO(1),Xylem_DO_fill(1),Tem_c(1),Tr(1), ...
            Xylem_DO_fill(1),Xylem_DO_fill(1),rsc(1),e_Avg(1),lwc(1),lwc(1),Zh(1),theta_2(1),ObukhovLength(1),LAI(1),e_Peclet(1));
        for j=2:length(Zh)
            try
                [d_T(j),d_L(j),d_e(j),e_Peclet(j),delta_Lb_s(j),exitfalg(j)]=nonsteadyT(Vapor_DO(j),Xylem_DO_fill(j), ...
                Tem_c(j),Tr(j), ...
                d_L(j-1),d_e(j-1), ...
                rsc(j),e_Avg(j),lwc(j-1),lwc(j),Zh(j),theta_2(j),ObukhovLength(j),LAI(j), e_Peclet(j-1));
             catch
                 e_Peclet(j)=0.9;
                 d_L(j)=Xylem_DO_fill(j);
                 d_e(j)=Xylem_DO_fill(j);
                 d_T(j)=Xylem_DO_fill(j);
            end
           
        end

if MyConstants.Flooding==1
    [Delta_E_O]=DE_flooding(Ta_Avg,Ts_Avg,e_Avg,Rh_Avg,Soil_DO,Vapor_DO);
else
    [Delta_E_O]=DE_nonflooding(Ta_Avg,Ts_Avg,e_Avg,Rh_Avg,Soil_DO,Vapor_DO);
end

TETisonss=(ET_DO-Delta_E_O)./(d_T-Delta_E_O);

%plot(TETisonss(LES<800&LE_c<800&LE_c>-100&QCflag==1&isnan(Xylem_DO)==0&isnan(Delta_E_O)==0),TET_sw(LES<800&LE_c<800&LE_c>-100&QCflag==1&isnan(Xylem_DO)==0&isnan(Delta_E_O)==0))