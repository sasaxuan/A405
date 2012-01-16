from netCDF3 import Dataset
from scipy.interpolate import UnivariateSpline
import matplotlib.pyplot as plt
import numpy as np
filename='soundings.nc';
nc_file=Dataset(filename)
var_names=nc_file.variables.keys()
print "variable names: ",var_names
print "global attributes: ",nc_file.ncattrs()
print "col_names: ",nc_file.col_names
fig=plt.figure(1)
fig.clf()
ax1=fig.add_subplot(111)
for var_name,the_var in nc_file.variables.items():
    ax1.plot(the_var[:,2],the_var[:,1])
#now interpolate the first variable onto a 100 m grid
the_var=nc_file.variables[var_names[0]]
interp_temp=UnivariateSpline(the_var[:,1],the_var[:,2])
z_interp=np.arange(300.,25000.,100.)
ax1.plot(interp_temp(z_interp),z_interp,'g-',linewidth=3)
fig.canvas.draw()
plt.show()
