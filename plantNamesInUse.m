function [ plant_name ] = plantNamesInUse( index )

% Map from index to plant name
%   
all_names = ['P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', ...
             'P08', 'P09', 'P10'];

plant_name = all_names(index);
end