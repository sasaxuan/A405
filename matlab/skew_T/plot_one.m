%step 1:  plot the 5, 15 and 25 degC isotherms so that they make
%about a 45 degree slope on a graph of log(press) vs. temp

function plot_one()
   press=1.:0.1:1000.;
   skew=30.;
   Temp5=5;
   Temp15=15;
   Temp25=25;
   figure(1)
   clf;
   semilogx(press,convertTempToSkew(Temp5,press,skew));
   hold on;
   semilogx(press,convertTempToSkew(Temp15,press,skew));
   semilogx(press,convertTempToSkew(Temp25,press,skew));
   hold off;
   title('5,15,25 degree isotherms in skew T - log(press) coords')
   xlabel('pressure (hPa) -- semilog')
   ylabel('transformed Temperature')
end

function skewX=convertTempToSkew(Temp,press,skew)
     %input Temp  in degC and press in hPa
     %output transformed Temp in potting coords
     if(press > 1000);
       fprintf('press %f is more than 1000 hPa, expecting mililbars',press)
     end
     if(Temp > 100);
       fprintf('Temp %f is more than 100 degC, expecting centigrade',Temp)
     end
     skewX=Temp - skew*log(press);
end     

