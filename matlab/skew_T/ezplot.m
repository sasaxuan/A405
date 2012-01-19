 c=constants;
 %
 % PLO -- range of pressures in hPa
 % xplot -- range of temperatures in skew coords
 yplot=[1000:-10:200];
 xplot=[-300:1:-140];
 [rows,pvals]=size(yplot);
 [rows,tvals]=size(xplot);
 temp=zeros([pvals,tvals]);
 theTheta=zeros([pvals,tvals]);
 skew=30; %skewness factor (deg C)
 %lay down a reference grid that labels xplot,yplot points 
 %in the new (skewT-lnP) coordinate system .
 % Each value of the temp matrix holds the actual (data) temperature
 % label (in deg C)  of the xplot, yplot coordinate pairs
 % The transformation is given by W&H 3.56, p. 78.  Note
 % that there is a sign difference, because rather than
 % taking y= -log(P) like W&H, I take y= +log(P) and
 % then reverse the y axis
 %
 %
 %
 for i=1:pvals,
    for j=1:tvals,
       %
       %note that we don't have to transform the y coordinate
       %it's still the pressure
       %
       temp(i,j)=convertSkewToTemp(xplot(j),yplot(i),skew);
       Tk=c.Tc + temp(i,j);
       pressPa=yplot(i)*100.;
       theTheta(i,j)=theta(Tk,pressPa);
    end
 end
 %
 % contour the temperature matrix
 %
 figure(1)
 clf
 tempLabels= -40:10:40;
 [output,handles]=contour(xplot,yplot,temp,tempLabels,'k');
 clabel(output,handles);
 %
 % flip the y axis
 %
 set(gca,'yscale','log','ydir','reverse');
 set(gca,'fontweight','bold');
 set(gca,'ytick',[100:100:1000]);
 set(gca,'ygrid','on');
 hold on;
 thetaLabels=200:10:370;
 [output,handle]=contour(xplot,yplot,theTheta,thetaLabels,'b');
 clabel(output,handle);
 %transform the temperature,dewpoint  from data coordinates to plotting coordinates
 title('skew T - lnp chart');
 ylabel('pressure (hPa)');
 xlabel('temperature (deg C)');
 TempTickLabels=5:5:30;
 TempTickCoords=TempTickLabels;
 skewTickCoords=convertTempToSkew(TempTickCoords,1.e3,skew);
 set(gca,'xtick',skewTickCoords);
 set(gca,'xticklabel',TempTickLabels);
 skewLimits=convertTempToSkew([5,30],1.e3,skew);
 axis([skewLimits(1),skewLimits(2),600,1.e3]);
 
 figure(2)
 clf
 %plot a sounding from soundings.nc
 filename='soundings.nc';
 file_struct=nc_info(filename)
 %
 % grap the first sounding pressure and temperature
 %
 sound_var = file_struct.Dataset(1).Name
 press=nc_varget(filename,sound_var,[0,0],[Inf,1]);
 temp=nc_varget(filename,sound_var,[0,2],[Inf,1]);
 semilogy(temp,press)
 set(gca,'yscale','log','ydir','reverse');
 ylabel('press (hPa)')
 xlabel('Temp (K)')
 title('sounding 1')
 
      