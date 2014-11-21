% This is the main method that calls brings together all the classes
% of the program. edit

% First, for every year result file we have, we need to create a YearData
% object. 
% Pseudocode:
%    arrayofyeardataobjects = new array 
%    for (all the year results)
%         fill in the array of year data objects
  
% Now we create a new instance of the OJGame object.  And then we 
% update this object by calling the update function with all the YearData
% objects (only do the online runs, basically not the two test runs of 
% 2014.

% After we do this for the data that we have, we can simply save
% the state  of the OJGame object and the array of year data.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now we can do anything we want with the yearly data or whatever.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We now call the decisions class and make decisions.  We then convert to
% an excel file to upload.  