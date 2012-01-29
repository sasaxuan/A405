%convec.m
%calculate thermodynamic variables
%for a convectively unstable layer
%uses these thermo libraries
%  makeSkew,convertTempToSkew,LCLfind, thetaep, wsat,
%  pseudoAdiabat,thetal,Tdfind,tinver
c=constants();

Tbot=20.;
Ttop=17.5;
Tdewbot=15;
Tdewtop=5.5;

Pbot=900.;
Ptop=800.;

%calculate the temperature and dewpoint sounding
%assuming linear profiles
slope=(Ttop - Tbot)/(Ptop - Pbot);
press=Pbot:(-10.):Ptop;
Temp=(Tbot + slope*(press - Pbot));
slope=(Tdewtop - Tdewbot)/(Ptop - Pbot);
Tdew = (Tdewbot + slope*(press - Pbot));

%how big is the pressure vector?
[rows,numPoints]=size(press);

figHandle=figure(1);
[figHandle,skew]=makeSkew(figHandle);
%zoom the axis to focus on layer
skewLimits=convertTempToSkew([5,30],1.e3,skew);
axis([skewLimits(1),skewLimits(2),600,1000]);
xplot1=convertTempToSkew(Temp,press,skew);
Thandle=plot(xplot1,press,'k-');
set(Thandle,'LineWidth',2.5);
xplot2=convertTempToSkew(Tdew,press,skew);
TdHandle=plot(xplot2,press,'b--');
set(TdHandle,'LineWidth',2.5);
title('convectively unstable sounding: base at 900 hPa');
print -dpdf initial_sound.pdf

% $$$ %put on the top and bottom LCLs and the thetae sounding
Tlcl=zeros([1 numPoints]);
pLCL=zeros([1 numPoints]);
theTheta=zeros([1 numPoints]);
theThetae=zeros([1 numPoints]);
Tpseudo=zeros([1 numPoints]);
wtotal=zeros([1 numPoints]);
for i=1:numPoints
  wtotal(i)=wsat(Tdew(i) + c.Tc,press(i)*100.);
  [Tlcl(i),pLCL(i)]=LCLfind(Tdew(i) + c.Tc,Temp(i)+c.Tc,press(i)*100.);
  theThetae(i)=thetaep(Tdew(i) + c.Tc,Temp(i) + c.Tc,press(i)*100.);
  %find the temperature along the pseudo adiabat at press(i)
  Tpseudo(i)=findTmoist(theThetae(i),press(i)*100.);
  %no liquid water in sounding
end
xplot=convertTempToSkew(Tlcl(1) - c.Tc,pLCL(1)*0.01,skew);
bot=plot(xplot,pLCL(1)*0.01,'ro','markerSize',12,'markerFaceColor','r');
xplot=convertTempToSkew(Tlcl(numPoints) - c.Tc,pLCL(numPoints)*0.01,skew);
top=plot(xplot,pLCL(end)*0.01,'bd','markerSize',12,'markerFaceColor','b');
print -dpdf initial_lcls.pdf
xplot=convertTempToSkew(Tpseudo - c.Tc,press,skew);
thetaEhandle=plot(xplot,press,'c-','LineWidth',2.5);
h=legend([Thandle,TdHandle,thetaEhandle,bot,top],'Temp (C)','Dewpoint (C)',...
       '$\theta_e$','LCL bot (835 hPa)','LCL top (768 hPa)');
set(h,'interpreter','latex');
print -dpdf base900_thetae.pdf
hold off;


%figure 2 --------------------------------
%lift by 50 hPa to base at 850 hPa
for i=1:numPoints
  press(i)=press(i) - 50;
  %find the temperature along the pseudoadiabats at press(i)
  Tpseudo(i)=findTmoist(theThetae(i),press(i)*100.);
  %find the actual temperature  and dewpoint
  [Temp(i),wv,wl]=tinvert_thetae(theThetae(i),wtotal(i),press(i)*100.);
  Tdew(i)=findTdwv(wv,press(i)*100.);
end
% $$$ 
figHandle=figure(2);
[figHandle,skew]=makeSkew(figHandle);
skewLimits=convertTempToSkew([5,30],1.e3,skew);
axis([skewLimits(1),skewLimits(2),600,1000]);
xplot1=convertTempToSkew(Temp - c.Tc,press,skew);
Thandle=plot(xplot1,press,'k-');
set(Thandle,'LineWidth',2.5);
xplot2=convertTempToSkew(Tdew -c.Tc,press,skew);
TdHandle=plot(xplot2,press,'b--');
set(TdHandle,'LineWidth',2.5);
xplot=convertTempToSkew(Tpseudo - c.Tc,press,skew);
thetaEhandle=plot(xplot,press,'c-','LineWidth',2.5);
xplot=convertTempToSkew(Tlcl(1) - c.Tc,pLCL(1)*0.01,skew);
bot=plot(xplot,pLCL(1)*0.01,'ro','markerSize',12,'markerFaceColor','r');
xplot=convertTempToSkew(Tlcl(numPoints) - c.Tc,pLCL(numPoints)*0.01,skew);
top=plot(xplot,pLCL(end)*0.01,'bd','markerSize',12,'markerFaceColor','b');
h=legend([Thandle,TdHandle,thetaEhandle,bot,top],'Temp (C)','Dewpoint (C)',...
       '$\theta_e$','LCL bot (835 hPa)','LCL top (768 hPa)');
set(h,'interpreter','latex');
title('convectively unstable sounding: base at 850 hPa');
print -dpdf base_850.pdf
hold off;

%figure 3 --------------------------------
%lift by another 1470 Pa to base at 835.3 hPa
for i=1:numPoints
  press(i)=press(i) - 14.7;
  %find the temperature along the pseudoadiabats at press(i)
  Tpseudo(i)=findTmoist(theThetae(i),press(i)*100.);
  %find the actual temperature  and dewpoint
  [Temp(i),wv,wl]=tinvert_thetae(theThetae(i),wtotal(i),press(i)*100.);
  Tdew(i)=findTdwv(wv,press(i)*100.);
end
figHandle=figure(3);
[figHandle,skew]=makeSkew(figHandle);
skewLimits=convertTempToSkew([5,30],1.e3,skew);
axis([skewLimits(1),skewLimits(2),600,1000]);
xplot1=convertTempToSkew(Temp - c.Tc,press,skew);
Thandle=plot(xplot1,press,'k-');
set(Thandle,'LineWidth',2.5);
xplot2=convertTempToSkew(Tdew -c.Tc,press,skew);
TdHandle=plot(xplot2,press,'b--');
set(TdHandle,'LineWidth',2.5);
xplot=convertTempToSkew(Tpseudo - c.Tc,press,skew);
thetaEhandle=plot(xplot,press,'c-','LineWidth',2.5);
xplot=convertTempToSkew(Tlcl(1) - c.Tc,pLCL(1)*0.01,skew);
bot=plot(xplot,pLCL(1)*0.01,'ro','markerSize',12,'markerFaceColor','r');
xplot=convertTempToSkew(Tlcl(numPoints) - c.Tc,pLCL(numPoints)*0.01,skew);
top=plot(xplot,pLCL(end)*0.01,'bd','markerSize',12,'markerFaceColor','b');
h=legend([Thandle,TdHandle,thetaEhandle,bot,top],'Temp (C)','Dewpoint (C)',...
       '$\theta_e$','LCL bot (835 hPa)','LCL top (768 hPa)');
set(h,'interpreter','latex');
title('convectively unstable sounding: base at 835.3 hPa');
print -dpdf base_835.pdf
hold off;

%figure 4 --------------------------------
%lift by another 10.30 hPa to base at 825 hPa
for i=1:numPoints
  press(i)=press(i) - 10.3;
  %find the temperature along the pseudoadiabats at press(i)
  Tpseudo(i)=findTmoist(theThetae(i),press(i)*100.);
  %find the actual temperature  and dewpoint
  [Temp(i),wv,wl]=tinvert_thetae(theThetae(i),wtotal(i),press(i)*100.);
  Tdew(i)=findTdwv(wv,press(i)*100.);
end
figHandle=figure(4);
[figHandle,skew]=makeSkew(figHandle);
skewLimits=convertTempToSkew([5,30],1.e3,skew);
axis([skewLimits(1),skewLimits(2),600,1000]);
xplot1=convertTempToSkew(Temp - c.Tc,press,skew);
Thandle=plot(xplot1,press,'k-');
set(Thandle,'LineWidth',2.5);
xplot2=convertTempToSkew(Tdew -c.Tc,press,skew);
TdHandle=plot(xplot2,press,'b--');
set(TdHandle,'LineWidth',2.5);
xplot=convertTempToSkew(Tpseudo - c.Tc,press,skew);
thetaEhandle=plot(xplot,press,'c-','LineWidth',2.5);
xplot=convertTempToSkew(Tlcl(1) - c.Tc,pLCL(1)*0.01,skew);
bot=plot(xplot,pLCL(1)*0.01,'ro','markerSize',12,'markerFaceColor','r');
xplot=convertTempToSkew(Tlcl(numPoints) - c.Tc,pLCL(numPoints)*0.01,skew);
top=plot(xplot,pLCL(end)*0.01,'bd','markerSize',12,'markerFaceColor','b');
h=legend([Thandle,TdHandle,thetaEhandle,bot,top],'Temp (C)','Dewpoint (C)',...
       '$\theta_e$','LCL bot (835 hPa)','LCL top (768 hPa)');
set(h,'interpreter','latex');
title('convectively unstable sounding: base at 825 hPa');
print -dpdf base_825.pdf
hold off;
%figure 5 --------------------------------
%lift by another 25 Pa to base at 800 hPa
for i=1:numPoints
  press(i)=press(i) - 25.;
  %find the temperature along the pseudoadiabats at press(i)
  Tpseudo(i)=findTmoist(theThetae(i),press(i)*100.);
  %find the actual temperature  and dewpoint
  [Temp(i),wv,wl]=tinvert_thetae(theThetae(i),wtotal(i),press(i)*100.);
  Tdew(i)=findTdwv(wv,press(i)*100.);
end
figHandle=figure(5);
[figHandle,skew]=makeSkew(figHandle);
skewLimits=convertTempToSkew([5,30],1.e3,skew);
axis([skewLimits(1),skewLimits(2),600,1000]);
xplot1=convertTempToSkew(Temp - c.Tc,press,skew);
Thandle=plot(xplot1,press,'k-');
set(Thandle,'LineWidth',2.5);
xplot2=convertTempToSkew(Tdew -c.Tc,press,skew);
TdHandle=plot(xplot2,press,'b--');
set(TdHandle,'LineWidth',2.5);
xplot=convertTempToSkew(Tpseudo - c.Tc,press,skew);
thetaEhandle=plot(xplot,press,'c-','LineWidth',2.5);
xplot=convertTempToSkew(Tlcl(1) - c.Tc,pLCL(1)*0.01,skew);
bot=plot(xplot,pLCL(1)*0.01,'ro','markerSize',12,'markerFaceColor','r');
xplot=convertTempToSkew(Tlcl(numPoints) - c.Tc,pLCL(numPoints)*0.01,skew);
top=plot(xplot,pLCL(end)*0.01,'bd','markerSize',12,'markerFaceColor','b');
h=legend([Thandle,TdHandle,thetaEhandle,bot,top],'Temp (C)','Dewpoint (C)',...
       '$\theta_e$','LCL bot (835 hPa)','LCL top (768 hPa)');
set(h,'interpreter','latex');
title('convectively unstable sounding: base at 800 hPa');
print -dpdf base_800.pdf
hold off;
%figure 6 --------------------------------
%lift by another 32.25 Pa to base at 768 hPa
for i=1:numPoints
  press(i)=press(i) - 25.;
  %find the temperature along the pseudoadiabats at press(i)
  Tpseudo(i)=findTmoist(theThetae(i),press(i)*100.);
  %find the actual temperature  and dewpoint
  [Temp(i),wv,wl]=tinvert_thetae(theThetae(i),wtotal(i),press(i)*100.);
  Tdew(i)=findTdwv(wv,press(i)*100.);
end
figHandle=figure(6);
[figHandle,skew]=makeSkew(figHandle);
skewLimits=convertTempToSkew([5,30],1.e3,skew);
axis([skewLimits(1),skewLimits(2),600,1000]);
xplot1=convertTempToSkew(Temp - c.Tc,press,skew);
Thandle=plot(xplot1,press,'k-');
set(Thandle,'LineWidth',2.5);
xplot2=convertTempToSkew(Tdew -c.Tc,press,skew);
TdHandle=plot(xplot2,press,'b--');
set(TdHandle,'LineWidth',2.5);
xplot=convertTempToSkew(Tpseudo - c.Tc,press,skew);
thetaEhandle=plot(xplot,press,'c-','LineWidth',2.5);
xplot=convertTempToSkew(Tlcl(1) - c.Tc,pLCL(1)*0.01,skew);
bot=plot(xplot,pLCL(1)*0.01,'ro','markerSize',12,'markerFaceColor','r');
xplot=convertTempToSkew(Tlcl(numPoints) - c.Tc,pLCL(numPoints)*0.01,skew);
top=plot(xplot,pLCL(end)*0.01,'bd','markerSize',12,'markerFaceColor','b');
h=legend([Thandle,TdHandle,thetaEhandle,bot,top],'Temp (C)','Dewpoint (C)',...
       '$\theta_e$','LCL bot (835 hPa)','LCL top (768 hPa)');
set(h,'interpreter','latex');
title('convectively unstable sounding: base at 768 hPa');
print -dpdf base_768.pdf
hold off;
