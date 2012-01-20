function Temp=convertSkewToTemp(xcoord,press,skew)
     %inverse of Wallace and Hobbs 3.56
     %xcoord in temperature plotting coordinates
     %press in hPa
     %output Temp in degC
     Temp= xcoord  + skew*log(press);