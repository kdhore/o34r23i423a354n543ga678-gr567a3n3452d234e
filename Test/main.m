% This is the main script.  Everyone can go fuck themselves.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only run this to create all the YearData files.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pick the year you want to start with:
%initial_str = 'Excel Files/MomPop2004Results.xlsm';
initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';

% %Initalize the first OJGame Object
ojObject = OJGame(initial_str);
% 
% if sum(strcmp(initial_str, 'Excel Files/MomPop2004Results.xlsm')) == 1
%     yr2004 = YearData('Excel Files/MomPop2004Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2004);
%     save('YearData Offline/yr2004.mat','yr2004');
%     yr2005 = YearData('Excel Files/MomPop2005Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2005);
%     save('YearData Offline/yr2005.mat','yr2005');
%     yr2006 = YearData('Excel Files/MomPop2006Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2006);
%     save('YearData Offline/yr2006.mat','yr2006');
%     yr2007 = YearData('Excel Files/MomPop2007Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2007);
%     save('YearData Offline/yr2007.mat','yr2007');
%     yr2008 = YearData('Excel Files/MomPop2008Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2008);
%     save('YearData Offline/yr2008.mat','yr2008');
%     yr2009 = YearData('Excel Files/MomPop2009Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2009);
%     save('YearData Offline/yr2009.mat','yr2009');
%     yr2010 = YearData('Excel Files/MomPop2010Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2010);
%     save('YearData Offline/yr2010.mat','yr2010');
%     yr2011 = YearData('Excel Files/MomPop2011Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2011);
%     save('YearData Offline/yr2011.mat','yr2011');
%     yr2012 = YearData('Excel Files/MomPop2012Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2012);
%     save('YearData Offline/yr2012.mat','yr2012');
%     yr2013 = YearData('Excel Files/MomPop2013Results.xlsm', ojObject);
%     ojObject = ojObject.update(yr2013);
%     save('YearData Offline/yr2013.mat','yr2013');
% end
% yr2014a = YearData('Excel Files/oriangagrande2014aResults.xlsm', ojObject);
% save('YearData Offline/yr2014a.mat','yr2014a');
% yr2014b = YearData('Excel Files/oriangagrande2014bResults.xlsm', ojObject);
% save('YearData Offline/yr2014b.mat','yr2014b');
% 
% %Online Trials
% yr2014 = YearData('Excel Files Orianga/oriangagrande2014Results.xlsm', ojObject);
% ojObject = ojObject.update(yr2014);
% save('YearData Orianga/yr2014.mat','yr2014');
% yr2015 = YearData('Excel Files Orianga/oriangagrande2015Results.xlsm', ojObject);
% ojObject = ojObject.update(yr2015);
% save('YearData Orianga/yr2015.mat','yr2015');
% yr2016 = YearData('Excel Files Orianga/oriangagrande2016Results.xlsm', ojObject);
% ojObject = ojObject.update(yr2016);
% save('YearData Orianga/yr2016.mat','yr2016');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only have to run to above code once to store the files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yearFiles = dir('YearData Orianga/*.mat');
ojObject = OJGame(initial_str);
for i = 1:(length(yearFiles) - 1)
   year = load(strcat('YearData Orianga/',yearFiles(i).name));
   yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
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
%updateModels(ojObject.year_start - 1);

% Running the simulation
for i = 1:numIter
    prompt = strcat('Type in the file path of decisions. Year: ',num2str(recentYear+i), '\n');   
    if i == 1
        decisions = YearDataforDecisions(input(prompt), ojObject);
        [simResults{i, 1}, proc_plants, storage] = Simulation(ojObject, decisions, i, shippingSchedule, ROJ_temp, tankersAvailable);
        simResults{i,2} = recentYear + i;
        ojObject = ojObject.updatefromSim(decisions, proc_plants, storage);
    else
        stor_open = find(ojObject.storage_cap);
        ROJ_temp = cell(71,1);
        for j = 1:71
            ROJ_temp{j} = zeros(48,1);
        end
        for j = 1:length(stor_open)
            ROJ_temp{stor_open(j)} = storage{j}.roj_temp;
        end
        [simResults{i, 1}, proc_plants, storage] = Simulation(ojObject, decisions, i, proc_plants, ROJ_temp);
        simResults{i,2} = recentYear + i;
        ojObject = ojObject.updatefromSim(decisions, proc_plants, storage);
    end
end