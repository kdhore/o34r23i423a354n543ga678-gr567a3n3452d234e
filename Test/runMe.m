% results file and new decisions file save as'd into temporary directories
% getting the next year 
currentYear = load('currentYear.mat');
currentYear = currentYear.currentYear;
initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';

% load old year data files
oldYearFiles = dir('YearData Offline/*.mat');
YearDataRecord = [];
for i = 1:(length(oldYearFiles))
    year = load(strcat('YearData Offline/',oldYearFiles(i).name));
    yearVar = genvarname(strrep(oldYearFiles(i).name,'.mat',''));
    YearDataRecord = [YearDataRecord year.(yearVar)];
end

% update OJObject
yearFiles = dir('YearData Orianga/*.mat');
ojObject = OJGame(initial_str);
for i = 1:(length(yearFiles))
    year = load(strcat('YearData Orianga/',yearFiles(i).name));
    yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
    YearDataRecord = [YearDataRecord year.(yearVar)];
    ojObject = ojObject.update(year.(yearVar));
end

% generate yearData object for new results file
newYr = YearData(strcat('Excel Files Orianga/oriangagrande', num2str(currentYear),'Results.xlsm'), ojObject);
varName = strcat('yr',num2str(currentYear));
eval([varName '= newYr']);
save(strcat('YearData Orianga/yr',num2str(currentYear),'.mat'),strcat('yr',num2str(currentYear)));
newYear = load(strcat('YearData Orianga/yr',num2str(currentYear),'.mat'));
newYearVar = genvarname(strcat('yr',num2str(currentYear)));
YearDataRecord = [YearDataRecord newYear.(newYearVar)];
  
% move newly generated yearData to the YearData Orianga directory
% Alex, you had the below code, but I don't think we need it anymore
% after when I've done above - Karthik

%fname = strcat('yr',num2str(currentYear),'.mat');
%movefile(fname,strcat('YearData Orianga/',fname));

% *** note: above line assumes the YearData will be saved to the...
% test directory. Modifying this is easy, I just need to know the...
% name of the directory it will be saved to ***

% update demand curves
fitCensoredDemandCurves2(currentYear);

% update prices (assuming this means update the grove model forecasts)
updateModels(currentYear);

% Finish updating the OJ Object and preparing to run the simulator
yearFiles = dir('YearData Orianga/*.mat');
recentYear = str2double(strrep(strrep(yearFiles(length(yearFiles)).name,'.mat',''),'yr',''));
numIter = 1;
simResults = cell(numIter,2);

% shipping schedule from previous year
lastYear = load(strcat('YearData Orianga/',yearFiles(length(yearFiles)).name));
yearVar = genvarname(strrep(yearFiles(length(yearFiles)).name,'.mat',''));
lastYear = lastYear.(yearVar);
shippingSchedule = lastYear.shippingSchedule;
pp_open = find(ojObject.proc_plant_cap);
yrTankersAvailable = lastYear.tankersAvailable;
tankersAvailable = zeros(10,1);
for i = 1:length(pp_open)
    tankersAvailable(pp_open(i)) = lastYear.tankersAvailable(i) + lastYear.tank_car_dec(i);
end
% Filling in intial ROJ_temp
stor_open = find(ojObject.storage_cap);
ROJ_temp = cell(71,1);
for i = 1:71
    ROJ_temp{i} = zeros(48,1);
end
for i = 1:length(stor_open)
    ROJ_temp{stor_open(i)} = lastYear.storage_res(char(storageNamesInUse(stor_open(i)))).roj_temp;
end
proc_plants = cell(10,1);
storage = cell(3,1);
ojObject = ojObject.update(lastYear);

% run decisions
filename = strcat('Decisions/oriangagrande',num2str(currentYear + 1),'.xlsm');
% this is temporary way to make the prices. need to just hardcode these in
% because ojobject wont match 2018 always.
filename2 = 'Decisions/oriangagrande2018test.xlsm';
dec = YearDataforDecisions(filename2, ojObject);
pricesORA = dec.pricing_ORA_dec;
pricesPOJ = dec.pricing_POJ_dec;
pricesROJ = dec.pricing_ROJ_dec;
pricesFCOJ = dec.pricing_FCOJ_dec;
decisions = Decisions(filename,ojObject,pricesORA,pricesPOJ,pricesROJ,pricesFCOJ,YearDataRecord);

% run simulator
[simResults{i, 1}, proc_plants, storage] = Simulation(ojObject, decisions, i, shippingSchedule, ROJ_temp, tankersAvailable);
simResults{i,2} = recentYear + i;

% xlWrite to write decisions onto spreadsheet to submit
% *** Phil code here ***

% moving to next year
currentYear = currentYear + 1;
save('currentYear.mat','currentYear');

% submit the file (written as a separate function so it can be called without having to rerun everything else)
% should never need this, but I'd rather write it and not need it than the reverse
subname = strcat('oriangagrande',num2str(currentYear),'.xlsm');
submit(subname); % *** Karthik, comment this out ***