%% Small demonstration on how to use XLWRITE

%% Initialisation of POI Libs
% Add Java POI Libs to matlab javapath
javaaddpath('poi_library/poi-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('poi_library/xmlbeans-2.3.0.jar');
javaaddpath('poi_library/dom4j-1.6.1.jar');
javaaddpath('poi_library/stax-api-1.0.1.jar');

%% Data Generation for XLSX
% Define an xls name
fileName = 'Decisions/oriangagrande2018test_PC.xlsm';
sheetName = 'shipping_manufacturing';

location = 'C1';
for i = 1:40
    xlsread('Decisions/oriangagrande2018test_PC.xlsm', sheetName,...
            strcat('C',num2str(i)))
    if strcmp(xlsread('Decisions/oriangagrande2018test_PC.xlsm', sheetName,...
            strcat('C',num2str(i))), 'Sep'); 
        location = strcat('C',num2str(i+1)); %find first empty cell after Sep
    end
end

xlwrite(fileName, 1, sheetName, location);


