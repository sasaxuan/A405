from sounding_dir.readsoundings import readsound
import numpy as np
import string
from scipy.io import savemat
import glob
import matplotlib.pyplot as plt
from ubcplot.stdplot import simplots
import pickle
from atsc405_zming.thermlib import esat
from atsc405_zming.thermconst import EPS
import matplotlib as mpl

mpl.rcParams['font.size'] = 20
the_celt=np.linspace(0,30,20)
theK=the_celt + 273.15
evals=esat(theK)
the_wvals=EPS*evals/80.*1.e3

figfac=simplots()
figcount=1
figfac.fignum=figcount
ax1=figfac.singleplot()
ax1.plot(the_celt,the_wvals)
ax1.set_title('saturation mixing ratio at 800 mbars')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel(r'$w_{sat}\ (g/kg^{-1})$')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/wsat.png',dpi=200)
plt.show()
