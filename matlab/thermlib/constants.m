function out=constants;
   %source: emanuel appendix 2
   out.Tc=273.15; %0 deg C in Kelvin
   out.eps=0.622;
   out.p0=1.e5;
   out.eps=0.622;
   out.lv0=2.501e6;  %J/kg
   out.Rv=461.50; %J/kg/K
   out.Rd=287.04; %J/kg/K
   out.cpv=1870.;  %heat capacity of water vapor (J/kg/K)
   out.cl=4190.;   %heat capacity of liquid water (J/kg/K)
   out.cpd=1005.7; %heat capacity of dry air (J/kg/K)
   out.g0=9.8;      %m/s^2
   out.D=2.36e-5;%diffusivity m^2/s^1 -- note: fairly strong function of temperature
                 %and pressure -- this is at 100kPa, 10degC
   out.rhol=1000.;