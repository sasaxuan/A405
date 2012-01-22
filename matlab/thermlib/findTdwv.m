function [Td]=findTdwv(wv,p)
    % in:         wv = mixing ratio in kg/kg, p= pressure (Pa)
    % out:        dewpoint temperature in K
    % reference: Emanuel 4.4.14 p. 117
  c=constants;
  c.eps=0.622;
  e= wv*p/(c.eps + wv);
  denom=(17.67/log(e/611.2)) - 1.;
  Td = 243.5/denom;
  Td = Td + 273.15;
end  
