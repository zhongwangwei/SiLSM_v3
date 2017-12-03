function [LE_f,H_f]=flux_c(G,H,LE,Rn_Avg)

Br=LE./(LE+H);%calibrated by Bowen Ratio.
LE_u=(Rn_Avg-G-H-LE).*Br;
LE_f=LE_u+LE;%final LE
H_f=H+(Rn_Avg-G-H-LE).*(1-Br);
end