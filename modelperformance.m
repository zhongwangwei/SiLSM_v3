function [RMSD,I,B,R2]=modelperformance(k1,k2)
%k1:obs
%k2:sim
RMSD=(((nansum((k1-k2).^2)))./length(k2)).^0.5;%RMSD
I=1-((nansum((k1-k2).^2)))./(nansum(((abs(k2-nanmean(k1)))+abs(k1-nanmean(k1))).^2));
B=nansum(k2-k1)/length(k2);
R1=(nansum(((k1-nanmean(k1)).*(k2-nanmean(k2)))))./sqrt((nansum((k2-nanmean(k2)).^2)).*(nansum((k1-nanmean(k1)).^2)));
R2=R1*R1;
end