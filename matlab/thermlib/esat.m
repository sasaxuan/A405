function [esatout]=esat(T)
  % in:         T = temperature in Kelvin (vector),
  % out:     esat = saturation water vapour pressure over water in Pa 
  % reference: Emanuel 4.4.14 p. 117
  Tc = T - 273.15;
  esatout = 611.2*exp(17.67.*Tc./(Tc + 243.5));
