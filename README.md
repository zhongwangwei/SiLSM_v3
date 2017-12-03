# SiLSM_v3
An Modified Shuttleworth-Wallace model with isotopic tracers

# Model Description
Our isotope-enabled two source model is applicable for evaluating evapotranspiration and its sub-components for different vegetation types with contrasting moisture conditions (even under flooding condition), and useful as an independent tool for investigating the discrepancies between isotope and non-isotope method. This model has been validated with observed isotope composition in the bulk leaf water and with the ET flux for variable vegetation covers, including crops (Rice, Wheat and Corn) and mangrove.

If you have questions regarding our model and website,  any suggestions to improve our work, or want to use this model, please contact me.
# Index of matlab Files

| **File** | **Description** | 
|:--------------------|:---------------------------------------------------------------------------------|
|[SiLSMv3.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/SiLSMv3.m)|The main function.|
|[MyConstants.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/MyConstants.m)|The MyConstants.m file is a text file that defines parameters that used in model calculation |
|[ETestimation.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/ETestimation.m)|The ETestimation.m file handles the interation processes occurs in the model|
|[ETsw.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/ETsw.m)|ET calculated by Shuttleworth-Wallace model|
|[brutsaertstability.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/ETsw.m)|Stability correction calulated based on Brutsaerts [2005]|
|[Solar_zenith_angle.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/Solar_zenith_angle.m)|Solar zenith angle calculation, optional|
|[sun_position.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/sun_position.m)|Sunposition calculation, optional|
|[surface_conductance.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/surface_conductance.m)|Canopy conductance calculation|
|[aerodynamicresistance.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/aerodynamicresistance.m)|aerodynamic resistance calculation|
|[flux_c.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/flux_c.m)|Force flux balance|
|[modelperformance.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/modelperformance.m)|Check model performance|
|[metalib.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/metalib.m)|meta lib calculation|
|[nonsteadyT.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/nonsteadyT.m)|isotopic composition of transpiration under the steady-state assumption |
|[Tc_Taylor_Expansion_theory.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/Tc_Taylor_Expansion_theory.m)|canopy temperature calulated using Taylor expansion theory|
