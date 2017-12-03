function [stab_m,stab_h]=brutsaertstability(ZL)
 for i=1:length(ZL)
 if ZL(i)>=0
 stab_m(i)=-6.1*log(ZL(i)+(1+ZL(i).^2.5).^(1/2.5));
 stab_h(i)=stab_m(i);
 end
     
 if ZL(i)<0
 a=0.33;
b=0.41;
c=0.33;
d=0.057;
n=0.78;

y(i)=-ZL(i);
S0=(-log(a)+(3.^0.5)*b*(a.^0.3333)*pi/6);
stab_h(i)=((1-d)/n)*log((c+y(i).^n)./c);
x(i)=((y(i)/a).^(1/3));

if(y(i)<=14.509)
stab_m(i)=log(a+y(i))-3*b*(y(i).^(1/3))+b*(a.^(1/3))/2*log(((1+x(i)).^2)./(1-x(i)+x(i).*x(i)))+(3.^0.5)*b*(a.^(1/3))*atan((2*x(i)-1)/(3.^0.5))+S0;
else
y1=14.509;
x1=((y1/a).^(1/3));
stab_m(i)=log(a+y1)-3*b*(y1.^(1/3))+b*(a.^(1/3))/2*log(((1+x1).^2)./(1-x1+x1.*x1))+(3.^0.5)*b*(a.^(1/3))*atan((2*x1-1)/(3.^0.5))+S0;

end
 
 end

if isnan(ZL(i))==1
    stab_m(i)=0;
    stab_h(i)=0;
 end
stab_m=stab_m';
stab_h=stab_h';

end
