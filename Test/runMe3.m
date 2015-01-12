% results file and new decisions file save as'd into temporary directories
% getting the next year 
clear;
%currentYear = load('currentYear.mat');
%currentYear = currentYear.currentYear;
prompt = strcat('Starting year\n');
currentYear = input(prompt);
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
yr2017 = load('YearData Orianga/yr2017.mat');
yr2017temp = genvarname('yr2017');
yr2017 = yr2017.(yr2017temp);
pricesORA = yr2017.pricing_ORA_dec;
pricesPOJ = yr2017.pricing_POJ_dec;
pricesROJ = yr2017.pricing_ROJ_dec;
pricesFCOJ = yr2017.pricing_FCOJ_dec;
decisions = Decisions(filename,ojObject,pricesORA,pricesPOJ,pricesROJ,pricesFCOJ,YearDataRecord);


%% Initialisation of POI Libs
% Add Java POI Libs to matlab javapath
javaaddpath('poi_library/poi-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('poi_library/xmlbeans-2.3.0.jar');
javaaddpath('poi_library/dom4j-1.6.1.jar');
javaaddpath('poi_library/stax-api-1.0.1.jar');

%% Data Generation for XLSX / XLSM
% Define an xls name
decisionFile = strcat('Decisions/oriangagrande',num2str(decisions.year),'.xlsm');

%% Facilities
%processing plants; 10x1
xlwrite(decisionFile, decisions.proc_plant_dec, 'facilities', 'C6:C15');

%tank cars; 10x1
xlwrite(decisionFile, decisions.tank_car_dec, 'facilities', 'C21:C30');

%storage units; 71x1
xlwrite(decisionFile, decisions.storage_dec, 'facilities', 'C36:C106');

%% Raw materials
%spot market purchases
xlwrite(decisionFile, decisions.purchase_spotmkt_dec, 'raw_materials', 'C6:N11');

%quantity multipliers
xlwrite(decisionFile, decisions.quant_mult_dec, 'raw_materials', 'C17:H22');


%futures purchases
xlwrite(decisionFile, decisions.future_mark_dec_ORA, 'raw_materials', 'O31:O35');
xlwrite(decisionFile, decisions.future_mark_dec_FCOJ, 'raw_materials', 'O37:O41');

%arrival of futures distribution
xlwrite(decisionFile, decisions.arr_future_dec_ORA, 'raw_materials', 'C47:N47');
xlwrite(decisionFile, decisions.arr_future_dec_FCOJ, 'raw_materials', 'C48:N48');


%% Shipping / Manufacturing
%shipping ORA
xlwrite(decisionFile, decisions.ship_grove_dec, 'shipping_manufacturing', 'C6:G11');

%manufacturing -- process ORA --> POJ or FCOJ
%currently 2 (each product) by 10 (all the processing plants).
%transform into only printing each POJ fraction.
stringIndex = 'CEGIKMOQSU'; %Excel column references
%U is the last column in Excel that manufacturing could go to

plants_open = find(ojObject.proc_plant_cap);

for i = 1:length(plants_open)
    xlwrite(decisionFile, ...
        decisions.manufac_proc_plant_dec(1,plants_open(i)),...
        'shipping_manufacturing', strcat(stringIndex(i),'19'));
end

%Shipping
%Futures
newFutures = zeros(length(stor_open),1);
for i = 1:length(stor_open)
    newFutures(i,1) = decisions.futures_ship_dec(stor_open(i),1);
end
xlwrite(decisionFile, newFutures, 'shipping_manufacturing', 'C27');
%this prints the [length(stor_open) x 1] array downwards

%POJ, FCOJ from plants to storages
newShipping = zeros(length(stor_open), 2*length(plants_open));
for i = 1:length(stor_open)
    for j = 1:length(plants_open)
        newShipping(i,2*j-1) = decisions.ship_proc_plant_storage_dec(stor_open(i),...
            plants_open(j)).POJ;
        newShipping(i,2*j) = decisions.ship_proc_plant_storage_dec(stor_open(i),...
            plants_open(j)).FCOJ;
    end
end
xlwrite(decisionFile, newShipping, 'shipping_manufacturing', 'D27');
%this prints the [length(stor_open) x length(plants_open)]
%array down and to the right.

%Reconstitution
%currently 71 x 12
newReconst = zeros(length(stor_open), 12);
for i = 1:length(stor_open)
    newReconst(i,:) = decisions.reconst_storage_dec(stor_open(i),:);
end

xlwrite(decisionFile, newReconst, 'shipping_manufacturing',...
    strcat('C',num2str(34+length(stor_open)))); %proper index

%% Pricing
%ORA prices
xlwrite(decisionFile, decisions.pricing_ORA_dec, 'pricing', 'D6');

%POJ prices
xlwrite(decisionFile, decisions.pricing_POJ_dec, 'pricing', 'D15');

%ROJ prices
xlwrite(decisionFile, decisions.pricing_ROJ_dec, 'pricing', 'D24');

%FCOJ prices
xlwrite(decisionFile, decisions.pricing_FCOJ_dec, 'pricing', 'D33');

% run simulator
[simResults{1, 1}, proc_plants, storage] = Simulation(ojObject, decisions, 1, shippingSchedule, ROJ_temp, tankersAvailable);
simResults{1,2} = recentYear + 1;

%metrics
%YearDataMetrics(newYr, ojObject)

% moving to next year
currentYear = currentYear + 1;
%save('currentYear.mat','currentYear');

% submit the file (written as a separate function so it can be called without having to rerun everything else)
% should never need this, but I'd rather write it and not need it than the reverse
subname = strcat('oriangagrande',num2str(currentYear),'.xlsm');
submit(subname); % *** Karthik, comment this out ***