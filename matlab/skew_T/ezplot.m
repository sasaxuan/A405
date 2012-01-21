 c=constants;
 %
 % yplot -- range of pressures in hPa
 % xplot -- range of temperatures in skew coords
 % the xplot,yplot grid defines the space over which
 % isotherms can be drawn
 yplot=[1000:-10:200];
 xplot=[-300:1:-140];
 [rows,pvals]=size(yplot);
 [rows,tvals]=size(xplot);
 temp=zeros([pvals,tvals]);
 theTheta=zeros([pvals,tvals]);
 skew=30; %skewness factor (deg C)
 %lay down a xplot,yplot reference grid that labels xplot,yplot points 
 %in the new (skewT-lnP) coordinate system .
 % Each value of the temp matrix holds the actual (data) temperature
 % label (in deg C)  of the xplot, yplot coordinate pairs
 % The transformation is given by W&H 3.56, p. 78.  
 % Here's an example of how the 5 degree isotherm is plotted:
 % At 800 hPa, the transformed X coordinate is:
 % convertTempToSkew(5,800.,30)=-195.5384 and at 400 hPa it's
 % convertTempToSkew(5,400.,30)=-174.7439.  So the contour will
 % be a straight line passing through (-195,800) and (-174,400)
 % That line will slope from lower left to upper right when the 
 % pressure axis direction is reversed so that pressure decreases
 % upward.  The temp(i,j) matrix for
 % points near that line will be 5, and a contour will be labeled
 % with the 5 label
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
 
      