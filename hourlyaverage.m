function [Y1,M1,D1,H1,variable,variable_std]=hourlyaverage(Year,Month,Day,Hour,Min,Data1)
 yy = datenum(Year, Month, Day, Hour, 0, 0);

count=unique(yy); 

 for i=1:length(count)
variable(i)=nanmean(Data1(yy==count(i)));
variable_std(i)=nanstd(Data1(yy==count(i)));
 end
variable=variable';
%variable_std=variable_std';
[Y1,M1,D1,H1]=datevec(count);


end