% results file and new decisions file save as'd into temporary directories
% getting the next year 
currentYear = load('currentYear.mat');
currentYear = currentYear.currentYear;

% generate yearData object for new results file
% *** Karthik code here ***

% move newly generated yearData to the YearData Orianga directory
fname = strcat('yr',num2str(currentYear),'.mat');
movefile(fname,strcat('YearData Orianga/',fname));
% *** note: above line assumes the YearData will be saved to the...
% test directory. Modifying this is easy, I just need to know the...
% name of the directory it will be saved to ***

% update OJObject
% *** Karthik code here ***

% update demand curves
fitCensoredDemandCurves2(currentYear);

% update prices (assuming this means update the grove model forecasts)
updateModels(currentYear);

% run decisions
% *** Karthik code here ***

% run simulator
% *** Karthik code here ***

% xlWrite to write decisions onto spreadsheet to submit
% *** Phil code here ***

% moving to next year
currentYear = currentYear + 1;
save('currentYear.mat','currentYear');

% submit the file (written as a separate function so it can be called without having to rerun everything else)
% should never need this, but I'd rather write it and not need it than the reverse
subname = strcat('oriangagrande',num2str(currentYear),'.xlsm');
submit(subname); % *** Karthik, comment this out ***