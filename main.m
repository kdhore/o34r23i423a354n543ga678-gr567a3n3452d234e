% This is the main script.  Everyone can go fuck themselves.

% Pick the year you want to start with:
%initial_str = 'MomPop2004Results.xlsm';
initial_str = 'oriangagrande2014Results.xlsm';

%Initalize the first OJGame Object
ojObject = OJGame(initial_str);

if sum(strcmp(initial_str, 'MomPop2004Results.xlsm')) == 1
    yr2004_MomPop = YearData('MomPop2004Results.xlsm', ojObject);
    ojObject.update(yr2004_MomPop);
    save('yr2004.mat','yr2004_MomPop');
    yr2005_MomPop = YearData('MomPop2005Results.xlsm', ojObject);
    ojObject.update(yr2005_MomPop);
    save('yr2005.mat','yr2005_MomPop');
    yr2006_MomPop = YearData('MomPop2006Results.xlsm', ojObject);
    ojObject.update(yr2006_MomPop);
    save('yr2006.mat','yr2006_MomPop');
    yr2007_MomPop = YearData('MomPop2007Results.xlsm', ojObject);
    ojObject.update(yr2007_MomPop);
    save('yr2007.mat','yr2007_MomPop');
    yr2008_MomPop = YearData('MomPop2008Results.xlsm', ojObject);
    ojObject.update(yr2008_MomPop);
    save('yr2008.mat','yr2008_MomPop');
    yr2009_MomPop = YearData('MomPop2009Results.xlsm', ojObject);
    ojObject.update(yr2009_MomPop);
    save('yr2009.mat','yr2009_MomPop');
    yr2010_MomPop = YearData('MomPop2010Results.xlsm', ojObject);
    ojObject.update(yr2010_MomPop);
    save('yr2010.mat','yr2010_MomPop');
    yr2011_MomPop = YearData('MomPop2011Results.xlsm', ojObject);
    ojObject.update(yr2011_MomPop);
    save('yr2011.mat','yr2011_MomPop');
    yr2012_MomPop = YearData('MomPop2012Results.xlsm', ojObject);
    ojObject.update(yr2012_MomPop);
    save('yr2012.mat','yr2012_MomPop');
    yr2013_MomPop = YearData('MomPop2013Results.xlsm', ojObject);
    ojObject.update(yr2013_MomPop);
    save('yr2013.mat','yr2013_MomPop');
else
    yr2014a_orianga = YearData('oriangagrande2014aResults.xlsm', ojObject);
    save('yr2014a.mat','yr2014a_orianga');
    yr2014b_orianga = YearData('oriangagrande2014bResults.xlsm', ojObject);
    save('yr2014b.mat','yr2014b_orianga');
    
    yr2014_orianga = YearData('oriangagrande2014Results.xlsm', ojObject);
    ojObject.update(yr2014_orianga);
    save('yr2014.mat','yr2014_orianga');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only have to run to above code once to store the files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('yr2014.mat')
ojObject = OJGame(initial_str);
ojObject.update(yr2014_orianga);

decisions = Decision(ojObject);

    