function theTemp = findTmoist(thetaE0,press);
   % get temperatures along a moist adiabat with thetaE0
   %input: thetaE0 (K), press (pa)
   %output: temperature (K) of thetaE0 adiabat at pressure=press
   shortHandle=@(Temp) thetaEchange(Temp,thetaE0,press);
   % this assumes the dewpoint is somewhere between
   % 250-350K
   theTemp=fzero(shortHandle,[200,400]);
end

function result = thetaEchange(Tguess,thetaE0,press);
% input Tguess (K), thetaE0 (kg/kg), press (Pa)
% assume that the parcel stays saturated, so use thetaes
   thetaEguess=thetaes(Tguess,press);
   %{'in change: ',Tguess,press,thetaEguess,thetaE0}
   %when this result is small enough we're done
   result=thetaEguess-thetaE0;
end
