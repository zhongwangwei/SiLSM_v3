function[Cp,Psy,rou,sigma,delta]= metalib(e,p,Ta_Avg)
  Cp = 0.24 * 4185.5 * (1 + 0.8 * (0.622 * e ./ (p - e)));%  [J kg-1C-1],
  Psy=0.000665*p;%Psy psychrometic constant [KPaC-1]
  rou=1.293*(273.15./(Ta_Avg+273.15)).*(p/101.325).*(1-0.378*(e./p)); % air density  [kgm-3]  
  sigma=5.67*(10.^(-8.0));
  delta=4098.*(0.6108.*exp(17.27*Ta_Avg./(Ta_Avg+237.3)))./((Ta_Avg+237.3).^2);% slope of the saturated wapor-temperature curve[kPaC-1]
end