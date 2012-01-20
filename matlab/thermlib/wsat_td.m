function result= wsat_td(ws0,press);
  %use a nested function to make shortHandle a function of a single variable
  %http://www.mathworks.com/access/helpdesk/help/techdoc/math/f2-116732.html#brfg601-2
  %input:  ws0 in kg/kg, press in Pa
  %output: Td in K
  if(press < 1000)
    fprintf('press %f is less than 1000 Pa, expecting mks',press)
  end
  shortHandle=@(Temp) wszero(Temp,ws0,press);
  result=fzero(shortHandle,[200,400]);
end

function result = wszero(Tguess,ws0,press);
% wszero evaluates the equation esat(Tguess) - e0 = 0
% and returns it to the root finder
% input Tguess (K), e0 (Pa)
   %when this difference is small enough we're done
   theWsat=wsat(Tguess,press);
   %fprintf('inside wszero rootfinder, Tguess,wsat= %f -- %f\n',Tguess,theWsat);
   result= theWsat - ws0;
end
