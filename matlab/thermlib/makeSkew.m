function [figureHandle,outputws,handlews]=makeSkew(figHandle,skew)
    %make a blank skewT diagram
    %signature: [figureHandle,outputws,handlews]=makeSkew(figHandle,skew)
    c=constants;
    %draw a skewT diagram and return the figure handle
    %and skew so other lines can be added later
    figureHandle=figure(figHandle);
    clf;
    [xplot,yplot,temp,thetaVals,thetaeVals,ws]=makeGrid(skew);
    tempLabels= -40:5:40;
    [output,hand]=contour(xplot,yplot,temp,tempLabels,'k');
    clabel(output,hand);
    set(gca,'yscale','log','ydir','reverse');
    set(gca,'fontweight','bold');
    %draw 10 horizontal pressure lines using ygrid
    set(gca,'ytick',[100:100:1000]);
    set(gca,'ygrid','on');
    hold on;  %this locks axes for adding more lines later
    thetaLabels=200:5:340;
    [output,handle]=contour(xplot,yplot,thetaVals,thetaLabels,'b');
    clabel(output,handle);
    title('skew T - lnp chart');
    ylabel('pressure (hPa)');
    xlabel('temperature (black, degrees C)');
    wsLabels=[0.1,0.25,0.5,1,2,3,4:2:20,24,28]
    [outputws,handlews]=contour(xplot,yplot,ws*1.e3,wsLabels,'g');
    clabel(outputws,handlews);
    thetaeLabels= [300,310,320,330,340,350,360,380,400]
    [output,handle]=contour(xplot,yplot,thetaeVals,thetaeLabels,'r');
    clabel(output,handle); 
    TempTickLabels=-25:5:30;
    TempTickCoords=TempTickLabels;
    skewTickCoords=convertTempToSkew(TempTickCoords,1.e3,skew);
    set(gca,'xtick',skewTickCoords);
    set(gca,'xticklabel',TempTickLabels);
    skewLimits=convertTempToSkew([0,30],1.e3,skew);
    axis([skewLimits(1),skewLimits(2),600,1.e3]);
end