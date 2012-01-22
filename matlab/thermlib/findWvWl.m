function [wv,wl]=findWvWl(T,wT,p)
   %
   % input T (K), wT (kg/kg), p (Pa)
   % output wv (kg/kg), wl(kg/kg)
   %
   wsVal=wsat(T,p);
   if wsVal > wT %unsaturated
     wv=wT;
     wl=0;
   else  %saturated
     wv=wsVal;
     wl=wT - wv;
   end
