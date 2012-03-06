clc
clear
%plot a sounding from soundings.nc
 filename='springfield.nc';
 file_struct=nc_info(filename)
 c=constants;
 %
 % grap the first sounding pressure and temperature
 %
 sound_var = file_struct.Dataset(3).Name
 press=nc_varget(filename,sound_var,[0,0],[Inf,1]);
 temp=nc_varget(filename,sound_var,[0,2],[Inf,1]);
 dewpoint=nc_varget(filename,sound_var,[0,3],[Inf,1]);
 fh=figure(1);
 semilogy(temp,press)
 hold on;
 semilogy(dewpoint,press)
 set(gca,'yscale','log','ydir','reverse');
 ylim([400,1000]);
 ylabel('press (hPa)')
 xlabel('Temp (deg C)')
 title('sounding 1')
 hold off;
 figHandle=figure(2)
 skew=30.
 [figHandle,outputws,handlews]=makeSkew(figHandle,skew);
 xtemp=convertTempToSkew(temp,press,skew);    
 xdew=convertTempToSkew(dewpoint,press,skew);    
 semilogy(xtemp,press,'g-','linewidth',5);
 semilogy(xdew,press,'b-','linewidth',5);
 [xTemp,thePress]=ginput(1);
 Tclick=convertSkewToTemp(xTemp,thePress,skew);    
 thetaeVal=thetaes(Tclick + c.Tc,thePress*100.);
 fprintf('ready to draw moist adiabat, thetae=%8.2f\n',thetaeVal);
 ylim([400,1000.])
 hold on;
 
moistPress = 400e2:1000:thePress*100;


for i = 1:numel(moistPress)
    moistTemp(i) = findTmoist(thetaeVal,moistPress(i))  %Tdiff btw sounding and moist temp
    xmoist(i) = convertTempToSkew(moistTemp(i)-c.Tc,moistPress(i)./100,skew) %degC, hPa
end
plot(xmoist,moistPress*0.01,'bd','markerSize',6,'markerFaceColor','k');
hold off;

 presscape=400e2:1000.:750e2;
 for i = 1:numel(presscape)
     %find corresponding sounding temp with moist temp using same pressure
         pressindex=find(press*100>=presscape(i))
         pressindex=pressindex(end)
    tempdiff(i) = abs(findTmoist(thetaeVal,moistPress(i)) - (temp(pressindex)+c.Tc)  ) %K, Pa
 end
avgtempdiff=sum(tempdiff(:))/length(tempdiff)
 
CAPE=287*log(750/400)*avgtempdiff
fprintf('CAPE is %f\n',CAPE)
