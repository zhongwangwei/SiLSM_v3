function [Y1,M1,D1,variable,variable_std]=dailyaverage(Year,Month,Day,Hour,Data1)
 yy = datenum(Year, Month, Day, 0, 0, 0);

count=unique(yy); 

 for i=1:length(count)
variable(i)=nanmean(Data1(yy==count(i)));
variable_std(i)=nanstd(Data1(yy==count(i)));
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
