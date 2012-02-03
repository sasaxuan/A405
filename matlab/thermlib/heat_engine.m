c=constants();
eqT_bot=30 + c.Tc;
eqwv_bot=14*1.e-3;
sfT_bot=21 + c.Tc;
sfwv_bot=3.e-3;
eqwv_top=3.e-3;
sfwv_top=3.e-3;
ptop=410.e2;
pbot=1000.e2;

eqTd_bot=findTdwv(eqwv_bot,pbot);
sfTd_bot=findTdwv(sfwv_bot,pbot);
thetae_eq=thetaep(eqTd_bot,eqT_bot,pbot);
thetae_sf=thetaep(sfTd_bot,sfT_bot,pbot);

figHandle=figure(1);
[figHandle,skew]=makeSkew(figHandle);

pvec=ptop:1000.:pbot;
for i=1:numel(pvec)
  [Tvec_eq(i),wv(i),wl(i)]=tinvert_thetae(thetae_eq,eqwv_bot,pvec(i));
  xcoord_eq(i)=convertTempToSkew(Tvec_eq(i) - c.Tc,pvec(i)*0.01,skew);
  [Tvec_sf(i),wv(i),wl(i)]=tinvert_thetae(thetae_sf,sfwv_bot,pvec(i));
  xcoord_sf(i)=convertTempToSkew(Tvec_sf(i) - c.Tc,pvec(i)*0.01,skew);
end

hot_adiabat=plot(xcoord_eq,pvec*0.01,'r-','linewidth',3);
cold_adiabat=plot(xcoord_sf,pvec*0.01,'b-','linewidth',3);
axlims=axis;
axlims(1)=convertTempToSkew(-30.,1000.,skew);
axlims(2)=convertTempToSkew(35.,1000.,skew);
axlims(3)=350.;
axlims(4)=1020.;
axis(axlims);

print -dpdf heat_engine.pdf

hold off;


