%test script for esat.m
Trange=270:0.1:300;
figure(1)
clf;
plot(Trange,esat(Trange));
title('esat (Pa) vs. Temperature (K)')
xlabel('Temperature (K)')
ylabel('esat (Pa)')
grid minor;