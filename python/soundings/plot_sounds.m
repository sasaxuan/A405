filename='soundings.nc';
%first dump everything in the netcdf file
nc_dump(filename)
%now get same information as a structure
file_struct=nc_info(filename)
%each variable is a Dataset, which are stored in the 
%Dataset structure
num_vars=length(file_struct.Dataset);
%get all the variable names for later access
for i=1:num_vars
  var_name{i} = file_struct.Dataset(i).Name;
end
%Get all global attributes and print them out
%i.e. no comma
num_global_atts=length(file_struct.Attribute)
for i=1:num_global_atts
  att_value{i}=file_struct.Attribute(i).Value
end
%get the first and second columns and save them
%into separate structures.  Note that a matrix
%won't work because each sounding has a different
%number of levels
for i=1:num_vars
  z_vectors{i}=nc_varget(filename,var_name{i},[0,1],[Inf,1]);
  T_vectors{i}=nc_varget(filename,var_name{i},[0,2],[Inf,1]);
end

%plot them all
figure(1)
plot(T_vectors{1},z_vectors{1})
hold on
for i=2:num_vars
  plot(T_vectors{i},z_vectors{i})
end
%interplolate first sounding onto a regular 100 m grid
z_interp=100:100:25000;
T_interp=interp1(z_vectors{1},T_vectors{1},z_interp);
plot(T_interp,z_interp,'g-','Linewidth',3)
hold off

