function pangs_littlerock
    filename='littlerock.nc';
    fprintf('reading file: %s\n',filename);
    file_struct=nc_info(filename);
    c=constants;
    sound_var = file_struct.Dataset(4).Name;
    fprintf('found sounding: %s\n',sound_var);
    press=nc_varget(filename,sound_var,[0,0],[Inf,1]);
    height=nc_varget(filename,sound_var,[0,1],[Inf,1]);
    temp=nc_varget(filename,sound_var,[0,2],[Inf,1]);
    dewpoint=nc_varget(filename,sound_var,[0,3],[Inf,1]);
    newHeight=nudgeHeight(height);
    interpTenv=@(zVals) interp1(newHeight,temp,zVals);
    interpTdEnv=@(zVals) interp1(newHeight,dewpoint,zVals);
    interpPress=@(zVals) interp1(newHeight,press,zVals);
    p900_level=find(abs(900 - press) < 2.);
    p800_level=find(abs(800 - press) < 7.);
    thetaeVal=thetaep(dewpoint(p900_level) + c.Tc,temp(p900_level) + c.Tc,press(p900_level)*100.);
    height_800=height(p800_level)
    yinit=[0.5,height_800];
    tspan=0:10:2500;
    derivs=@(t,y) F(t,y,thetaeVal,interpTenv,interpTdEnv,interpPress);
    [t,y]=ode45(derivs,tspan,yinit);
    wvel=y(:,1);
    height=y(:,2);  
    %limit the plot to the updraft
    updraft=wvel > 0;
    figure(1);
    clf;
    plot(wvel(updraft),height(updraft))
    xlabel('vertical velocity');
    ylabel('height above surface');
    title('wvel vs. height')
    grid on;
      figure(2);
    clf;
     plot(t,y(:,1));
    title('wvel vs. time, stop when 0');
 %%%%%%%%%%%%%%%%%% stop when wvel=0  
    stopwvel=0;
  options=odeset('Events',@events);
  [t2,y2]=ode45(derivs,tspan,yinit,options);
    wvel2=y2(:,1);
    height2=y2(:,2);  
    updraft2=wvel2 > 0;
    
    figure(3);
    clf;
    plot(wvel2(updraft2),height2(updraft2))
    xlabel('vertical velocity');
    ylabel('height above surface');
    title('wvel vs. height, stop when wvel=0')
    grid on;
    figure(4);
    clf;
     plot(t2,y2(:,1));
    title('wvel vs. time, stop when wvel0');
  
  function [value,isterminal,direction] = events(t,y)
        % Locate the time when height passes through stopHeight in a decreasing direction
        % and stop integration.  Here we use a nested function to avoid
        % passing the additional parameter stopHeight as an input argument.
        value = y(1) - stopwvel;     % detect height = 0
        isterminal = 1;   % stop the integration
        direction = -1;   % only when approaching stopHeight from above
  end

end

function yp=F(t,y,thetae0,interpTenv,interpTdEnv,interpPress)
  yp=zeros(2,1); % since output must be a column vector
  %first variable is velocity in m/s
  yp(1)=calcBuoy(y(2),thetae0,interpTenv,interpTdEnv,interpPress);
  %second variable is height in m
  yp(2)= y(1);
end

function Bout=calcBuoy(height,thetae0,interpTenv,interpTdEnv,interpPress)
    %calcBuoy(height,thetae0,interpTenv,interpTdenv,interpPress)
    %input: height (m), thetae0 (K), plus function handles for
    %T,Td, press soundings
    %output: Bout = buoyant acceleration in m/s^2
    %neglect liquid water loading in the virtual temperature
    c=constants;
    press=interpPress(height)*100.;%hPa
    Tcloud=findTmoist(thetae0,press); %K
    wvcloud=wsat(Tcloud,press); %kg/kg
    Tvcloud=Tcloud*(1. + c.eps*wvcloud);
    Tenv=interpTenv(height) + c.Tc;
    Tdenv=interpTdEnv(height) + c.Tc;
    wvenv=wsat(Tdenv,press); %kg/kg
    Tvenv=Tenv*(1. + c.eps*wvenv);
    TvDiff=Tvcloud - Tvenv;
    fprintf('%10.3f %10.3f %10.3f\n',press*0.01,height,TvDiff);
    Bout=c.g0*(TvDiff/Tvenv);
end


function newHeight=nudgeHeight(zVec)
    %if two balloon pressure levels are idential
    %add a factor of 0.1% to the second one
    %so interpolation will work
    newHeight=zVec;
    hit=find(diff(newHeight) < 0);
    newHeight(hit+1)=zVec(hit) + 1.e-3*zVec(hit);
end
