function skewX=convertTempToSkew(Temp,press,skew)
     %input Temp  in degC and press in hPa
     %output transformed Temp in potting coords
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
          if(press > 1000);
       fprintf('press %f is more than 1000 hPa, expecting mililbars\n',press)
     end
     if(Temp > 100);
       fprintf('Temp %f is more than 100 degC, expecting centigrade\n',Temp)
     end
     skewX=Temp - skew*log(press);
