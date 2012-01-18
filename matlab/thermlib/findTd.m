function result= findTd(e0);
  %use a nested function to make shortHandle a function of a single variable
  %http://www.mathworks.com/access/helpdesk/help/techdoc/math/f2-116732.html#brfg601-2
  shortHandle=@(Temp) ezero(Temp,e0);
  result=fzero(shortHandle,[200,400]);
  
function result = ezero(Tguess,e0);
% ezero evaluates the equation esat(Tguess) - e0 = 0
% and returns it to the root finder
% input Tguess (K), e0 (Pa)
   %when this difference is small enough we're done
   %fprintf('inside ezero rootfinder, Tguess= %f\n',Tguess);
   result=esat(Tguess) - e0;
