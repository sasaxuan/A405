from sounding_dir.readsoundings import readsound
import numpy as np
import string
import glob
import matplotlib.pyplot as plt
import pickle


def findz(press,temp,z0):
    Rd=287.
    rho=press*100./((temp+273.15)*Rd)
    delz=-np.diff(press*100.)/(rho[:-1]*9.8)
    the_z=z0 + delz
    return np.concatenate(([z0],the_z))

picfile='s_alburqurque.pic'
picfile=open(picfile,'r')
the_data=pickle.load(picfile)
picfile.close()
newDict=the_data['data']
theKeys=newDict.keys()
theKeys.sort()
outArray=np.empty([len(theKeys),],dtype='object')
for count,the_key in enumerate(theKeys):
    outArray[count]=newDict[the_key]

figcount=0    
allkeys=newDict.keys()
firstsound=newDict[allkeys[0]]
figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
ax1.plot(firstsound.temp,firstsound.height*1.e-3)
for key in allkeys[1:]:
    thesound=newDict[key]
    ax1.plot(thesound.temp,thesound.height*1.e-3)
ax1.set_title('Albuquerque NM, July 2010 -- 62 soundings')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('height (km)')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_height.png',dpi=200)


figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
ax1.plot(firstsound.mixr,firstsound.height*1.e-3)
for key in allkeys[1:]:
    thesound=newDict[key]
    ax1.plot(thesound.mixr,thesound.height*1.e-3)
ax1.set_title('Albuquerque NM, July 2010 --h2o mixing ratio')
ax1.set_xlabel('h2o mixing ratio  g/kg')
ax1.set_ylabel('height (km)')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_mix_height.png',dpi=200)

figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
ax1.plot(firstsound.temp,firstsound.press)
ax1.invert_yaxis()
for key in allkeys[1:]:
    thesound=newDict[key]
    ax1.plot(thesound.temp,thesound.press)
ax1.set_title('Albuquerque NM, July 2010 - 62 soundings')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('pressure (hPa)')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_press.png',dpi=200)


figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
ax1.semilogy(firstsound.temp,firstsound.press)
ax1.invert_yaxis()
for key in allkeys[1:]:
    thesound=newDict[key]
    ax1.semilogy(thesound.temp,thesound.press)
ax1.set_title('Albuquerque NM, July 2010 - 62 soundings')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('pressure (hPa)')
ax1.set_ylim([900.,2.])
ax1.figure.canvas.draw()
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_press_logy.png',dpi=200)


figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
for key in allkeys:
    if '12Z' in key:
        thesound=newDict[key]
        ax1.plot(thesound.temp,thesound.height*1.e-3)

the_z=np.linspace(1600,7000,10)
the_temp= 37. - 9.8/1004.*(the_z - 1600)
ax1.plot(the_temp,the_z*1.e-3,'r',lw=3)
ax1.set_ylim([1.5,7])
ax1.set_xlim([-20,40])
ax1.set_title('Albuquerque July 2010 - 5am soundings')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('height (km)')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_height_5am.png',dpi=200)

figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
for key in allkeys:
    if '0Z' in key:
        thesound=newDict[key]
        ax1.plot(thesound.temp,thesound.height*1.e-3)

the_z=np.linspace(1600,7000,10)
the_temp= 37. - 9.8/1004.*(the_z - 1600)
ax1.plot(the_temp,the_z*1.e-3,'r',lw=3)
ax1.set_ylim([1.5,7])
ax1.set_xlim([-20,40])
ax1.set_title('Albuquerque July 2010 - 5pm soundings')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('height (km)')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_height_5pm.png',dpi=200)


p0=[]
for key in allkeys:
    p0.append(thesound.press[0])

minpress=np.min(p0)
presslevs=np.linspace(305,minpress-1,150)
import scipy.interpolate
night_tempsounds=[]
night_heightsounds=[]
night_mixsounds=[]
day_tempsounds=[]
day_heightsounds=[]
day_mixsounds=[]
origpress=[]
origtemp=[]
origheight=[]
for key in allkeys:
    thesound=newDict[key]
    press=thesound.press[::-1]
    temp=thesound.temp[::-1]
    mixr=thesound.mixr[::-1]
    height=thesound.height[::-1]
    closepress=(press - 300.)**2.
    minarg=np.atleast_1d(np.argmin(closepress))[0]
    press=press[minarg:]
    temp=temp[minarg:]
    mixr=mixr[minarg:]
    height=height[minarg:]
    origheight.append(height)
    origtemp.append(temp)
    origpress.append(press)
    try:
        interptemp=scipy.interpolate.UnivariateSpline(press,temp)
        interpheight=scipy.interpolate.UnivariateSpline(press,height)
        interpmix=scipy.interpolate.UnivariateSpline(press,mixr)
        newtemps=interptemp(presslevs)
        newheights=interpheight(presslevs)
        newmix=interpmix(presslevs)
    except:
        print "interpolation failed for ",key
        pass
    if '12Z' in key:
        night_tempsounds.append(newtemps)
        night_heightsounds.append(newheights)
        night_mixsounds.append(newmix)
    else:
        day_tempsounds.append(newtemps)
        day_heightsounds.append(newheights)
        day_mixsounds.append(newmix)

figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
mean_heights=np.array(day_heightsounds)
mean_heights=mean_heights.mean(axis=0)
mean_temps=np.array(day_tempsounds)
mean_temps=mean_temps.mean(axis=0)
dayline=ax1.plot(mean_temps,mean_heights*1.e-3,'g-',lw=3)
ax1.set_ylim([1.5,7])
ax1.set_xlim([-20,40])
mean_heights=np.array(night_heightsounds)
mean_heights=mean_heights.mean(axis=0)
mean_temps=np.array(night_tempsounds)
mean_temps=mean_temps.mean(axis=0)
nightline=ax1.plot(mean_temps,mean_heights*1.e-3,'k-',lw=3)
the_z=np.linspace(1600,7000,10)
the_temp= 32. - 9.8/1004.*(the_z - 1600)
adialine=ax1.plot(the_temp,the_z*1.e-3,'r',lw=1.5)
ax1.grid(True)
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('height (km)')
ax1.set_title('Albuquerque NM, July 2010 -- July average')
ax1.legend([dayline,nightline,adialine],('day','night','adiabat'))
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_avgtemps.png',dpi=200)


figfac=simplots()
figcount+=1
figfac.fignum=figcount
ax1=figfac.singleplot()
mean_heights=np.array(day_heightsounds)
mean_heights=mean_heights.mean(axis=0)
mean_mixr=np.array(day_mixsounds)
mean_mixr=mean_mixr.mean(axis=0)
dayline=ax1.plot(mean_mixr,mean_heights*1.e-3,'g-',lw=3)
ax1.set_ylim([1.5,7])
mean_heights=np.array(night_heightsounds)
mean_heights=mean_heights.mean(axis=0)
mean_mixr=np.array(night_mixsounds)
mean_mixr=mean_mixr.mean(axis=0)
nightline=ax1.plot(mean_mixr,mean_heights*1.e-3,'k-',lw=3)
the_z=np.linspace(1600,7000,10)
ax1.grid(True)
ax1.set_xlabel('mixing ratio (g/kg)')
ax1.set_ylabel('height (km)')
ax1.set_title('h2o mixing ratio Albuquerque NM, July 2010 -- July average')
ax1.legend([dayline,nightline],('day','night'))
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/alb_avgmix.png',dpi=200)

plt.show()


    
    




