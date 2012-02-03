from netCDF3 import Dataset
import numpy as np

in_file='/home/phil/public_html/courses/atsc500/code/matlab/BOMEX_256x256x150_25m_20m_2s_16_0000009240.nc'
out_file='subset.nc'
new_x=np.arange(128,178)
new_y=np.arange(128,198)
nc_in=Dataset(in_file)
try:
    nc_out=Dataset(out_file,'ws','NETCDF3_CLASSIC')
except:
    os.unlink('outfile.nc')
    nc_out=Dataset('outfile.nc','ws','NETCDF3_CLASSIC')

## copy attributes
for the_att in nc_in.ncattrs():
    setattr(nc_out,the_att,getattr(nc_in,the_att).strip())

##get one-d vars
npz_vars={}
one_d={}
out_vars={}
for the_dim in ['x','y','z']:
    one_d[the_dim]=nc_in.variables[the_dim]

npz_vars={}

sub_x=one_d['x'][new_x]
sub_y=one_d['y'][new_y]
sub_z=one_d['z'][:]
nc_out.createDimension('x',len(sub_x))
nc_out.createDimension('y',len(sub_y))
nc_out.createDimension('z',len(sub_z))
for the_dim in ['x','y','z']:
    out_vars[the_dim]=nc_out.createVariable(the_dim,sub_x.dtype,(the_dim,))
press_var=nc_in.variables['p']
npz_vars['p']=press_var
out_vars['p']=nc_out.createVariable('p',press_var.dtype,press_var.dimensions)
out_vars['p'][...]=nc_in.variables['p'][...]
npz_vars['p']=nc_in.variables['p'][...]

for the_att in nc_in.variables['p'].ncattrs():
    setattr(out_vars['p'],the_att,getattr(nc_in.variables['p'],the_att))

out_vars['x'][:]=sub_x[:]
npz_vars['x']=sub_x
out_vars['y'][:]=sub_y[:]
npz_vars['y']=sub_y
out_vars['z'][:]=sub_z[:]
npz_vars['z']=sub_z
for var_name in ['x','y','z']:
    old_var=one_d[var_name]
    for the_att in old_var.ncattrs():
        new_var=out_vars[var_name]
        setattr(new_var,the_att,getattr(old_var,the_att))

varnames=['W','PP','QV','QN', 'TABS']
for var_name in varnames:
    old_var=nc_in.variables[var_name]
    dim_list=old_var.dimensions[1:]
    out_var=nc_out.createVariable(var_name,old_var.dtype,dim_list)
    data=old_var[0,:,new_y,new_x]
    if var_name in ['W','TABS','QV','QN']:
        npz_vars[var_name]=data
    print data.shape
    out_var[:,:,:]=data[...]
    for the_att in old_var.ncattrs():
        setattr(out_var,the_att,getattr(old_var,the_att).strip())

for var_name in ['x','y','z']:
    old_var=one_d[var_name]
    for the_att in old_var.ncattrs():
        new_var=out_vars[var_name]
        setattr(new_var,the_att,getattr(old_var,the_att))

nc_out.description='subset of BOMEX run created with make_subset.py'
nc_out.in_file=in_file

nc_in.close()
nc_out.close()

var_descrip={'W':{'long_name':'vertical velocity','units':'m/s'},
             'TABS':{'long_name':'temperature','units':'K'},
             'p':{'long_name':'pressure','units':'hPa'},
             'QV':{'long_name':'vapor mixing ratio','units':'g/kg'},
             'z':{'long_name':'height','units':'m'},
             'x':{'long_name':'xcoord','units':'m'},
             'y':{'long_name':'ycoord','units':'m'},
             }

var__file="""output from SAM LES run BOMEX_256x256x150_25m_20m_2s_16_0000009240.nc
             written by make_sub_set.py on 2012/Jan/30"""

npz_vars['var_descrip']=var_descrip

with open('les_out.npz','w') as f:
    np.savez(f,**npz_vars)

