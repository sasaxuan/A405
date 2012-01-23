function theWs=wsat(TempK,pressPa)
  %usage: wsat(TempK,pressPa)
  % in:  Temp = temperature in Kelvin (vector) 
  % in:  ppress = pressure in Pa (scalar)
  % out: theWs = saturation water vapor mixing ratio in (kg/kg)
  %note the vector multiplication and division
  c=constants;
  es=esat(TempK);
  theWs = c.eps .* esat(TempK)./ (pressPa - es);
  if (pressPa - es ) < 0;
    theWs = 0.06;
  end
    
  %
  % limit ws values so rootfinder doesn't blow up
  %
  hit=theWs > 0.060;
  theWs(hit)= 0.060;
  hit=theWs < 0.;
  theWs(hit)=0.;
end