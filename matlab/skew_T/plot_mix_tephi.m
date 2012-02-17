c=constants();
figHandle=figure(1);
skew=30;
[figHandle,outputws,handlews]=makeSkew(figHandle,skew);
pressPa=70.e3;
tempEnv=c.Tc + 11.;
wtEnv=3.e-3;
tempCloud=c.Tc + 11.;
wtCloud=14.e-3;
wtMix=0.4*wtEnv + 0.6*wtCloud;
thetaeCld=thetaes(tempCloud,pressPa);
tdEnv=findTdwv(wtEnv,pressPa);
thetaeEnv=thetaep(tdEnv,tempEnv,pressPa);
thetaeMix=0.4*thetaeEnv + 0.6*thetaeCld;
press=450:1000;
for i=1:numel(press)
  [TsoundEnv(i),wv,wl]=tinvert_thetae(thetaeEnv,wtEnv,press(i)*100.);
  [TsoundCld(i),wv,wl]=tinvert_thetae(thetaeCld,wtCloud,press(i)*100.);
  [TsoundMix(i),wv,wl]=tinvert_thetae(thetaeMix,wtMix,press(i)*100.);
end  
xenvsnd=convertTempToSkew(TsoundEnv - c.Tc,press,skew);
xcldsnd=convertTempToSkew(TsoundCld - c.Tc,press,skew);
xcldmix=convertTempToSkew(TsoundMix - c.Tc,press,skew);
xleft=convertTempToSkew(-5,800.,skew);
xright=convertTempToSkew(25,800.,skew);
axis([xleft,xright,500.,800.])
clabel(outputws,handlews,[3,4,5,6,7,8,10,12,14,16]);
pressLabels=500:25:800;
set(gca,'ytick',pressLabels);
set(gca,'yticklabel',pressLabels);
tempLabels=-5:5:35;
xtemp=convertTempToSkew(tempLabels,800.,skew);
set(gca,'xtick',xtemp);
set(gca,'xticklabel',tempLabels);
print -dpdf 'mixing_blank.pdf'
plot(xenvsnd,press,'r-','linewidth',4);
print -dpdf 'mixing_env.pdf'
plot(xcldsnd,press,'b-','linewidth',4);
print -dpdf 'mixing_cloud.pdf'
plot(xcldmix,press,'g-','linewidth',4);
print -dpdf 'mixing_all.pdf'

hold off;
