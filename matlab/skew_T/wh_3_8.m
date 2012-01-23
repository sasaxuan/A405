% $$$   Exercise 3.8: Air at 1000 hPa and 18 °C has a mixing
% $$$   ratio of 6 g/kg. What are the relative humidity
% $$$   and dew point of the air?

c=constants;
press=1000.e2
temp=18 + c.Tc;
wv=6.e-3;
theWs=wsat(temp,press);
%W&H 3.64
rh=wv/theWs;
theTd=findTdwv(wv,press);

out_mesg={'\nrelative humidity is %8.2f %%\n',...
          'dew point temperature is %8.3f deg C\n'};
fprintf(strcat(out_mesg{:}),rh*1.e2,theTd - c.Tc);

