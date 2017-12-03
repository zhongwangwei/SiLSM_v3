function [Y1,M1,D1,iso]=dailyaverageweight(Year,Month,Day,Hour,Data1,Data2)
 yy = datenum(Year, Month, Day, 0, 0, 0);
Data3=Data1.*Data2;
count=unique(yy); 

 


for i=1:length(count)
variable(i)=sum(Data3(yy==count(i)&~isnan(Data3)));
variable1(i)=sum(Data2(yy==count(i)&~isnan(Data3)));
iso(i)=variable(i)/variable1(i);

 end
 
 
 
 
variable=variable';
%variable_std=variable_std';
[Y1,M1,D1]=datevec(count);
if D1(1)-Day(1)==0
fprintf( 'date OK\n')
else
fprintf('Warning\n')
end

end
