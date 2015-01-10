% run simulator
[simResults{1, 1}, proc_plants, storage] = Simulation(ojObject, decisions, 1, shippingSchedule, ROJ_temp, tankersAvailable);
simResults{1,2} = recentYear + 1;

% xlWrite to write decisions onto spreadsheet to submit
% *** Phil code here ***

% moving to next year
currentYear = currentYear + 1;
save('currentYear.mat','currentYear');

% submit the file (written as a separate function so it can be called without having to rerun everything else)
% should never need this, but I'd rather write it and not need it than the reverse
subname = strcat('oriangagrande',num2str(currentYear),'.xlsm');
submit(subname); % *** Karthik, comment this out ***