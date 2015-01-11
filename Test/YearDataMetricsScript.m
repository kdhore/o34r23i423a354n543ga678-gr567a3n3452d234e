%metrics script
clear;
prompt = strcat('Starting year\n');
currentYear = input(prompt);

%create relevant oj object
initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';
yearFiles = dir('YearData Orianga/*.mat');
ojObject = OJGame(initial_str);
for i = 1:(length(yearFiles))
    year = load(strcat('YearData Orianga/',yearFiles(i).name));
    yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
    ojObject = ojObject.update(year.(yearVar));
end

% generate yearData object for new results file
newYr = YearData(strcat('Excel Files Orianga/oriangagrande', num2str(currentYear),'Results.xlsm'), ojObject);
varName = strcat('yr',num2str(currentYear));
eval([varName '= newYr']);
save(strcat('YearData Orianga/yr',num2str(currentYear),'.mat'),strcat('yr',num2str(currentYear)));
newYear = load(strcat('YearData Orianga/yr',num2str(currentYear),'.mat'));
newYearVar = genvarname(strcat('yr',num2str(currentYear)));
newYear = newYear.(newYearVar);
%YearDataRecord = [YearDataRecord newYear.(newYearVar)];

YearDataMetrics(newYear, ojObject);