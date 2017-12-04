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
|[aerodynamicresistance.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/aerodynamicresistance.m)|Aerodynamic resistance calculation|
|[flux_c.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/flux_c.m)|Force flux balance|
|[modelperformance.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/modelperformance.m)|Check model performance|
|[metalib.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/metalib.m)|Meta lib calculation|
|[nonsteadyT.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/nonsteadyT.m)|Isotopic composition of transpiration under the steady-state assumption |
|[Tc_Taylor_Expansion_theory.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/Tc_Taylor_Expansion_theory.m)|Canopy temperature calulated using Taylor expansion theory|
|[test.mat](https://github.com/zhongwangwei/SiLSM_v3/blob/master/test.mat)|Test data for the model|
|[DE_flooding.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/DE_flooding.m)|Soil evaporation isotope calculation under flooding condition|
|[DE_nonflooding.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/DE_nonflooding.m)|Soil evaporation isotope calculation under nonflooding condition|
|[dailyaverage.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/dailyaverage.m)|Average data to daily|
|[dailyaverageweight.m](https://github.com/zhongwangwei/SiLSM_v3/blob/master/dailyaverageweight.m)|Average data to daily with weight function|
# MIT License

Copyright (c) 2017 Zhongwang Wei

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
