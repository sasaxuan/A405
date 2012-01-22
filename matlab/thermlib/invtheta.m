function [Tempout]=invtheta(varargin);
    % find temperature given theta, pressure and (optional) wv
    % allow for either theta,p or theta,p,wv using vargin
    % in:     either theta = temperature in Kelvin, 
    %                p = pressure Pa
    %         or
    %                theta = temperature in Kelvin
    %                p = pressure in Pa
    %                wv = vapor mixing ratio in kg/kg
    % out:    Temp = temperature in Kelvin
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
    theta=varargin{1};
    p=varargin{2};
    power = c.Rd/c.cpd*(1. - 0.24*wv);
    Tempout=theta/(c.p0/p)^power;
end
