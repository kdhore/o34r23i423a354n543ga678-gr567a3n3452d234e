% For now this needs to be MANUALLY updated
% Load the year data objects
yr2004 = load('YearData Offline/yr2004.mat');
yr2004temp = genvarname('yr2004');
yr2004 = yr2004.(yr2004temp);

yr2005 = load('YearData Offline/yr2005.mat');
yr2005temp = genvarname('yr2005');
yr2005 = yr2005.(yr2005temp);

yr2006 = load('YearData Offline/yr2006.mat');
yr2006temp = genvarname('yr2006');
yr2006 = yr2006.(yr2006temp);

yr2007 = load('YearData Offline/yr2007.mat');
yr2007temp = genvarname('yr2007');
yr2007 = yr2007.(yr2007temp);

yr2008 = load('YearData Offline/yr2008.mat');
yr2008temp = genvarname('yr2008');
yr2008 = yr2008.(yr2008temp);

yr2009 = load('YearData Offline/yr2009.mat');
yr2009temp = genvarname('yr2009');
yr2009 = yr2009.(yr2009temp);

yr2010 = load('YearData Offline/yr2010.mat');
yr2010temp = genvarname('yr2010');
yr2010 = yr2010.(yr2010temp);

yr2011 = load('YearData Offline/yr2011.mat');
yr2011temp = genvarname('yr2011');
yr2011 = yr2011.(yr2011temp);

yr2012 = load('YearData Offline/yr2012.mat');
yr2012temp = genvarname('yr2012');
yr2012 = yr2012.(yr2012temp);

yr2013 = load('YearData Offline/yr2013.mat');
yr2013temp = genvarname('yr2013');
yr2013 = yr2013.(yr2013temp);

yr2014 = load('YearData Orianga/yr2014.mat');
yr2014temp = genvarname('yr2014');
yr2014 = yr2014.(yr2014temp);

yr2015 = load('YearData Orianga/yr2015.mat');
yr2015temp = genvarname('yr2015');
yr2015 = yr2015.(yr2015temp);

yr2016 = load('YearData Orianga/yr2016.mat');
yr2016temp = genvarname('yr2016');
yr2016 = yr2016.(yr2016temp);

yr2017 = load('YearData Orianga/yr2017.mat');
yr2017temp = genvarname('yr2017');
yr2017 = yr2017.(yr2017temp);

YearDataRecord = [yr2004, yr2005, yr2006, yr2007, yr2008,...
    yr2009, yr2010, yr2011, yr2012, yr2013, yr2014, yr2015, yr2016, yr2017];

initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';
yearFiles = dir('YearData Orianga/*.mat');
ojObject = OJGame(initial_str);
for i = 1:(length(yearFiles) - 1)
    year = load(strcat('YearData Orianga/',yearFiles(i).name));
    yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
    ojObject = ojObject.update(year.(yearVar));
end
recentYear = str2double(strrep(strrep(yearFiles(length(yearFiles)).name,'.mat',''),'yr',''));

%Set the number of iterations to be simulated
prompt = strcat('How many years to simulate? Starting year: ',num2str(recentYear+1), '\n');
numIter = input(prompt);
simResults = cell(numIter,2);

%shipping schedule from previous year
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
%Filling in intial ROJ_temp
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

filename1 = 'Decisions/oriangagrande2018test.xlsm';
filename2 = 'Excel Files Orianga/oriangagrande2016Results.xlsm';
decisions = YearDataforDecisions(filename1, ojObject);

decisionsMichelle(filename1,ojObject,decisions.pricing_ORA_dec,decisions.pricing_POJ_dec,decisions.pricing_ROJ_dec,decisions.pricing_FCOJ_dec,YearDataRecord,filename2);
