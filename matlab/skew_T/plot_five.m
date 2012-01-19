%adjust the graph and label the x axis

function plot_five()
%
% we want temperature labels to appear along the
% isotherms.  The easiest way to do that is to
% use contour labels
%
% step 1, set up a grid to contour in the
% transformed x coordinate
    yplot=[1000:-10:200];
    xplot=[-300:1:-140];
    [rows,pvals]=size(yplot);
    [rows,tvals]=size(xplot);
    temp=zeros([pvals,tvals]);
    skew=30
 %step 2
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
       %it's still the pressure.  After these loops complete
       %temp(i,j) will contain temperatures in degrees C
       %corresponding to the x,y points on the grid
       temp(i,j)=convertSkewToTemp(xplot(j),yplot(i),skew);
    end
 end
 %
 % contour the temperature matrix
 %
 figure(5)
 clf
 tempLabels= [5,15,25];
 [output,handles]=contour(xplot,yplot,temp,tempLabels,'k');
 clabel(output,handles);
 %
 % flip the y axis
 %
 set(gca,'yscale','log','ydir','reverse');
 set(gca,'fontweight','bold');
 set(gca,'ytick',[100:100:1000]);
 set(gca,'ygrid','on');
 title('5,15,25 degC isotherms done by grid contouring')
 %
 %size the plot and label the xaxis tickmarks
 %
 TempTickLabels=5:5:30;
 TempTickCoords=TempTickLabels;
 skewTickCoords=convertTempToSkew(TempTickCoords,1.e3,skew);
 set(gca,'xtick',skewTickCoords);
 set(gca,'xticklabel',TempTickLabels);
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

function Temp=convertSkewToTemp(xcoord,press,skew)
     %inverse of Wallace and Hobbs 3.56
     %xcoord in temperature plotting coordinates
     %press in hPa
     %output Temp in degC
     Temp= xcoord  + skew*log(press);
end    
 