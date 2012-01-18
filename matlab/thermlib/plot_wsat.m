%test script for esat.m
Trange=270:0.1:300;
figure(1)
clf;
pressPa=900.e2;
%convert wsat to g/kg
plot(Trange,wsat(Trange,pressPa)*1.e3);
title('wsat (g/kg) vs. Temperature (K) at 900 hPa')
xlabel('Temperature (K)')
ylabel('wsat (g/kg)')
grid minor;
