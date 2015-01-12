% run main for 1 year (up to line 101)
% This is the main script.  Everyone can go fuck themselves.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only run this to create all the YearData files.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pick the year you want to start with:
%initial_str = 'Excel Files/MomPop2004Results.xlsm';
%initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';

% %Initalize the first OJGame Object
%ojObject = OJGame(initial_str);
% 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only have to run to above code once to store the files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
for i = 1:(length(yearFiles)-1)
    year = load(strcat('YearData Orianga/',yearFiles(i).name));
    yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
    YearDataRecord = [YearDataRecord year.(yearVar)];
    ojObject = ojObject.update(year.(yearVar));
end
recentYear = str2double(strrep(strrep(yearFiles(length(yearFiles)).name,'.mat',''),'yr',''));

% Set the number of iterations to be simulated
prompt = strcat('How many years to simulate? Starting year: ',num2str(recentYear+1), '\n');
numIter = input(prompt);
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

yr2017 = load('YearData Orianga/yr2017.mat');
yr2017temp = genvarname('yr2017');
yr2017 = yr2017.(yr2017temp);
filename = 'decisions/oriangagrande2018test.xlsm';
pricesORA = yr2017.pricing_ORA_dec;
pricesPOJ = yr2017.pricing_POJ_dec;
pricesROJ = yr2017.pricing_ROJ_dec;
pricesFCOJ = yr2017.pricing_FCOJ_dec;
decisions = Decisions(filename,ojObject,pricesORA,pricesPOJ,pricesROJ,pricesFCOJ,YearDataRecord);

% give it 2018 decisions, run
% run lines 109 - 111
[simResults{1, 1}, proc_plants, storage] = Simulation(ojObject, decisions, 1, shippingSchedule, ROJ_temp, tankersAvailable);
simResults{1,2} = recentYear + 1;

% then run linear program from runMe3 (line 95-99

% run simulator (main lines 113 - 122) modified inputs
stor_open = find(ojObject.storage_cap);
ROJ_temp = cell(71,1);
for j = 1:71
    ROJ_temp{j} = zeros(48,1);
end
for j = 1:length(stor_open)
    ROJ_temp{stor_open(j)} = storage{j}.roj_temp;
end
ojObject = ojObject.updatefromSim(decisions, proc_plants, storage);
array = [33,43];
results = zeros(length(array),1);
for i= 1:length(array)
    if i ==1
       ojObject.storage_cap(array(i)) = 10000;
       filename = 'decisions/oriangagrande2019test.xlsm';
        decisions = Decisions(filename,ojObject,pricesORA,pricesPOJ,pricesROJ,pricesFCOJ,YearDataRecord);
       [simResults{i, 1}, proc_plants, storage] = Simulation(ojObject, decisions, 2, proc_plants, ROJ_temp);
        simResults{i,2} = recentYear + 2;
        results(i) = simResults{i,1}{10};
    else
        ojObject.storage_cap(array(i-1)) = 0;
        ojOjbect.storage_cap(array(i)) = 10000;
        filename = 'decisions/oriangagrande2019test.xlsm';
        decisions = Decisions(filename,ojObject,pricesORA,pricesPOJ,pricesROJ,pricesFCOJ,YearDataRecord);
        [simResults{i, 1}, proc_plants, storage] = Simulation(ojObject, decisions, 2, proc_plants, ROJ_temp);
        simResults{i,2} = recentYear + 2;
        results(i) = simResults{i,1}{10};
    end
end
    
filename = 'decisions/oriangagrande2019test.xlsm';
decisions = Decisions(filename,ojObject,pricesORA,pricesPOJ,pricesROJ,pricesFCOJ,YearDataRecord);
[simResults{2, 1}, proc_plants, storage] = Simulation(ojObject, decisions, 2, proc_plants, ROJ_temp);
simResults{2,2} = recentYear + 2;
%ojObject = ojObject.updatefromSim(decisions, proc_plants, storage);