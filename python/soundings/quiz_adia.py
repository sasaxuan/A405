from sounding_dir.readsoundings import readsound
import numpy as np
import string
from scipy.io import savemat
import glob
import matplotlib.pyplot as plt
import matplotlib as mpl
from ubcplot.stdplot import simplots
import pickle

mpl.rcParams['font.size'] = 20

figfac=simplots()
figfac.fignum=1
ax1=figfac.singleplot()
the_z=np.linspace(0,7000,10)
the_temp= 30. - 9.8/1004.*(the_z - 0)
dry_line=ax1.plot(the_temp,the_z*1.e-3,'g',lw=3)
the_temp= 30. - 6/1004.*(the_z - 0)
wet_line=ax1.plot(the_temp,the_z*1.e-3,'b',lw=3)
ax1.legend((dry_line,wet_line),('s1','s2'))
ax1.set_title('idealized soundings')
ax1.set_xlabel('temperature (deg C)')
ax1.set_ylabel('height (km)')
ax1.figure.savefig('/home/phil/public_html/courses/eosc340/textfiles/figures1/quiz_sounding.png',dpi=200)
plt.show()

