% This is the main script.  Everyone can go fuck themselves.

% Pick the year you want to start with:
initial_str = 'MomPop2004Results.xlsm';
%initial_str = 'oriangagrande2014Results.xlsm';

%Initalize the first OJGame Object
ojObject = OJGame(initial_str);

if sum(strcmp(initial_str, 'MomPop2004Results.xlsm')) == 1
    yr2004 = YearData('MomPop2004Results.xlsm', ojObject);
    ojObject.update(yr2004);
    save('yr2004.mat','yr2004');
    yr2005 = YearData('MomPop2005Results.xlsm', ojObject);
    ojObject.update(yr2005);
    save('yr2005.mat','yr2005');
    yr2006 = YearData('MomPop2006Results.xlsm', ojObject);
    ojObject.update(yr2006);
    save('yr2006.mat','yr2006');
    yr2007 = YearData('MomPop2007Results.xlsm', ojObject);
    ojObject.update(yr2007);
    save('yr2007.mat','yr2007');
    yr2008 = YearData('MomPop2008Results.xlsm', ojObject);
    ojObject.update(yr2008);
    save('yr2008.mat','yr2008');
    yr2009 = YearData('MomPop2009Results.xlsm', ojObject);
    ojObject.update(yr2009);
    save('yr2009.mat','yr2009');
    yr2010 = YearData('MomPop2010Results.xlsm', ojObject);
    ojObject.update(yr2010);
    save('yr2010.mat','yr2010');
    yr2011 = YearData('MomPop2011Results.xlsm', ojObject);
    ojObject.update(yr2011);
    save('yr2011.mat','yr2011');
    yr2012 = YearData('MomPop2012Results.xlsm', ojObject);
    ojObject.update(yr2012);
    save('yr2012.mat','yr2012');
    yr2013 = YearData('MomPop2013Results.xlsm', ojObject);
    ojObject.update(yr2013);
    save('yr2013.mat','yr2013');
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

    