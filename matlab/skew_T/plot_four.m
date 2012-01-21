%use contour to get in-line labels

function plot_four()
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
       %it's still the pressure.  After these loops complete
       %temp(i,j) will contain temperatures in degrees C
       %corresponding to the x,y points on the grid
       temp(i,j)=convertSkewToTemp(xplot(j),yplot(i),skew);
    end
 end
 %
 % contour the temperature matrix
 %
 figure(4)
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
 