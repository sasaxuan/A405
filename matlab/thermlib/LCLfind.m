function [Tlcl,plcl]=LCLfind(Td,T,p);
%   in: Td = dewpoint temperature in Kelvin
%       T  = temperature in Kelvin
%       p  = pressure in Pa
%  out: Tlcl, pcl = temperature and pressure at the LCL in K,Pa
%
%   Reference: Emanuel 4.6.24 p. 130 and 4.6.22 p. 129
    c=constants;
    hit = Td > T;
    if(sum(hit) > 1)
      error('parcel is saturated at this pressure');
    end
    e=esat(Td);
    ehPa=e*0.01; %Bolton's formula requires hPa
    % this is is an empircal fit from for LCL temp
    % from Bolton, 1980
    Tlcl=(2840./(3.5*log(T) - log(ehPa) - 4.805)) + 55.;
    r=c.eps*e./(p - e);
    %disp(sprintf('r=%0.5g',r'))
    cp=c.cpd + r*c.cpv;
    logplcl=log(p) + cp./(c.Rd*(1 + r/c.eps))*log(Tlcl./T);
    plcl=exp(logplcl);
    %disp(sprintf('plcl=%0.5g',plcl))