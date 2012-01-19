%step 2:  now flip the x,y coords

function plot_two()
   press=1.:0.1:1000.;
   skew=30.;
   Temp5=5;
   Temp15=15;
   Temp25=25;
   figure(2)
   clf;
   semilogy(convertTempToSkew(Temp5,press,skew),press);
   hold on;
   semilogy(convertTempToSkew(Temp15,press,skew),press);
   semilogy(convertTempToSkew(Temp25,press,skew),press);
   set(gca,'yscale','log','ydir','reverse');
   hold off;
   title('flipped 15,25 degree isotherms in skew T - log(press) coords')
   ylabel('pressure (hPa) -- semilog')
   xlabel('transformed Temperature')
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

 