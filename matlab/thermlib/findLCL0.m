function [plcl,Tlcl]= findLCL0(wv,press0,Temp0);
  %input:  wv in kg/kg, press0 in Pa, Temp0 in K
  %output: [LCL press (Pa), LCL temp (K)]
  if(press0 < 1000)
    fprintf('press %f is less than 1000 Pa, expecting mks',press)
  end
  theta0=theta(Temp0,press0,wv);
  shortHandle=@(press) lclzero(press,wv,theta0);
  result=fzero(shortHandle,[1000.e2,400.e2]);
  plcl=result;
  Tlcl=invtheta(theta0,plcl,wv);
end

function result = lclzero(pguess,wv0,theta0);
% lcl evaluates the equation Temp - Td = 0
% where Temp is temperature at pressure pguess on dry adiabat theta0
% when this difference is near 0 we have found the LCL
% input pguess (hPa), wv0 (kg/kg), theta0 (K)
   Temp=invtheta(theta0,pguess,wv0);
   Td=wsat_td(wv0,pguess);
   %fprintf('inside wszero rootfinder, Tguess,wsat= %f -- %f\n',Tguess,theWsat);
   result= Temp - Td;
end
