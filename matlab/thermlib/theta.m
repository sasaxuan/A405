function [thetaout]=theta(varargin);
    % allow for either T,p or T,p,wv using vargin
    % in:     either T = temperature in Kelvin, 
    %                p = pressure Pa
    %         or
    %                T = temperature in Kelvin
    %                p = pressure in Pa
    %                wv = vapor mixing ratio in kg/kg
    % out:    theta = potential temperature in Kelvin
    % reference emanuel p. 111 4.2.11
    % this is slightly more accurate than W&H 3.54 because it
    % uses the heat capacity of the air/vapor mixture
    c=constants;
    if nargin==2
      wv=0;
    elseif nargin==3
      wv=varargin{3};
    else
      error('need either T,p or T,p,wv');
    end
    T=varargin{1};
    p=varargin{2};
    power = c.Rd/c.cpd*(1. - 0.24*wv);
    thetaout=T*(c.p0/p)^power;
end
