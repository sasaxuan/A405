import numpy as np
import string
import glob
import matplotlib.pyplot as plt
import pickle
import scipy.io as io
import os

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

from netCDF4 import Dataset

try:
    ncfile=Dataset('output.nc','ws','NETCDF3_CLASSIC')
except:
    os.unlink('output.nc')
    ncfile=Dataset('output.nc','ws','NETCDF3_CLASSIC')
keep_arrays=list()
array_lengths=list()
for a_day in outArray:
    the_array=np.frombuffer(a_day.data)
    n_cols=len(a_day.dtype)
    the_array=np.reshape(the_array,(-1,n_cols))
    keep_arrays.append((the_array.shape,the_array))
    array_lengths.append(the_array.shape[0])
array_lengths.sort()
array_lengths=set(array_lengths)
ncfile.close()

