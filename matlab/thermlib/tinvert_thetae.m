function [theTemp,wv,wl]=tinvert_thetae(thetaeVal,wT,p)
%   in: thetaeVal -- thetae of parcel (K)
%       wtotal  = total water mixing ratio (kg/kg)
%       p  = pressure pressure of parcel (Pa)
%  out: [T,wv,wl]  temperature T (K), vapor mixing ratio wv, (kg/kg), liquid
%  water mixing ratio wl (kg/kg) at p
    if p > 1.e5;
      error('expecting pressure level less than 100000 Pa');
    end
    %the temperature has to be somewhere between thetae (T at surface)
    % -40 deg. C (no ice)
   theTemp=fzero(@Tchange,[233.15,thetaeVal],[],thetaeVal,wT,p);
   [wv,wl]=findWvWl(theTemp,wT,p);
end


function result = Tchange(Tguess,thetaeVal,wT,p);
   [wv,wl]=findWvWl(Tguess,wT,p);
   tdGuess=findTdwv(wv,p);
   %iterate on Tguess until this function is zero to within tolerance
   result = thetaeVal - thetaep(tdGuess,Tguess,p);
end

    