function [xplot,yplot,temp,thetaVals,thetaeVals,ws]=makeGrid(skew)
%make the grid for a tephigram
%get a dense range of p, t0 to contour
    c=constants;
    yplot=[1000:-10:100];
    xplot=[-300:1:-140];
    [rows,pvals]=size(yplot);
    [rows,tvals]=size(xplot);
    [pvals,tvals]
    temp=zeros([pvals,tvals]);
    thetaVals=zeros([pvals,tvals]);
    thetaeVals=zeros([pvals,tvals]);
    ws=zeros([pvals,tvals]);
    %lay down a reference grid that labels xplot,yplot points 
    %in the new (skewT-lnP) coordinate system .
    % Each value of the temp matrix holds the actual (data) temperature
    % label (in deg C)  of the xplot, yplot coordinate pairs
    for i=1:pvals,
       for j=1:tvals,
          %note that we don't have to transform the y coordinate
          %it's still the pressure
          temp(i,j)=convertSkewToTemp(xplot(j),yplot(i),skew);
          Tk=temp(i,j) + c.Tc; %convert from C to K for use in
                                 %thermo functios
          %use the real (data) value to get the potential temperature
          %theta function needs T in (K) and press in Pa
          press=yplot(i)*100.; %convert from hPa to Pa
          thetaVals(i,j)=theta(Tk,press); %theta labels
          %add the mixing ratio
          ws(i,j)=wsat(Tk,press);  %wsat labels
          %saturated adiabat, so Tdew=Tk
          thetaeVals(i,j)=thetaep(Tk,Tk,press); %thetae labels
       end
    end
fprintf('through makeGrid\n')
end