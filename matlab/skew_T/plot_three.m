%step 3:  label the temperatures and adjust the size of the plot

function plot_three()
   press=1.:0.1:1000.;
   skew=30.;
   Temp5=5;
   Temp15=15;
   Temp25=25;
   figure(3)
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
   %now make nice temperature labels
   %make the text labels in deg C, but place them
   %along the skewed coordinate
   TempTickLabels=5:5:30;
   TempTickCoords=TempTickLabels;
   skewTickCoords=convertTempToSkew(TempTickCoords,1.e3,skew);
   set(gca,'xtick',skewTickCoords);
   set(gca,'xticklabel',TempTickLabels);
   %
   %plot only 5-30 degrees and 100-600 hPa
   skewLimits=convertTempToSkew([5,30],1.e3,skew);
   axis([skewLimits(1),skewLimits(2),600,1.e3]);
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
