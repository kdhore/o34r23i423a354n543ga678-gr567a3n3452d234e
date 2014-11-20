clear
clc
current_OJ = OJGame();
yr2004 = YearData('MomPop2004Results.xlsm',current_OJ);
current_OJ.update(yr2004);
yr2005 = YearData('MomPop2005Results.xlsm',current_OJ);
current_OJ.update(yr2005);
yr2006 = YearData('MomPop2006Results.xlsm',current_OJ);
current_OJ.update(yr2006);
yr2007 = YearData('MomPop2007Results.xlsm',current_OJ);
current_OJ.update(yr2007);
yr2008 = YearData('MomPop2008Results.xlsm',current_OJ);
current_OJ.update(yr2008);
yr2009 = YearData('MomPop2009Results.xlsm',current_OJ);
current_OJ.update(yr2009);
yr2010 = YearData('MomPop2010Results.xlsm',current_OJ);
current_OJ.update(yr2010);
yr2011 = YearData('MomPop2011Results.xlsm',current_OJ);
current_OJ.update(yr2011);
yr2012 = YearData('MomPop2012Results.xlsm',current_OJ);
current_OJ.update(yr2012);
yr2013 = YearData('MomPop2013Results.xlsm',current_OJ);
current_OJ.update(yr2013);
yr2014a = YearData('oriangagrande2014aResults.xlsm',current_OJ);
current_OJ.update(yr2014a);
yr2014b = YearData('oriangagrande2014bResults.xlsm',current_OJ);
current_OJ.update(yr2014b);

region = {'NE'; 'MA'; 'SE';'MW';'DS';'NW';'SW'};

% Find which years for which products are UNCENSORED
isCensoredS15 = zeros(4,12);
isCensoredS61 = zeros(4,12);

% 2004
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S15').ORA_Sales(1,i) == yr2004.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S15').POJ_Sales(1,i) == yr2004.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S15').ROJ_Sales(1,i) == yr2004.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S15').FCOJ_Sales(1,i) == yr2004.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,1) = 1;
end

% 2004
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S61').ORA_Sales(1,i) == yr2004.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S61').POJ_Sales(1,i) == yr2004.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S61').ROJ_Sales(1,i) == yr2004.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S61').FCOJ_Sales(1,i) == yr2004.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,1) = 1;
end


% 2005
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2005.storage_res('S15').ORA_Sales(1,i) == yr2005.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2005.storage_res('S15').POJ_Sales(1,i) == yr2005.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2005.storage_res('S15').ROJ_Sales(1,i) == yr2005.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2005.storage_res('S15').FCOJ_Sales(1,i) == yr2005.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,2) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,2) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,2) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,2) = 1;
end

% 2005
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2005.storage_res('S61').ORA_Sales(1,i) == yr2005.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2005.storage_res('S61').POJ_Sales(1,i) == yr2005.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2005.storage_res('S61').ROJ_Sales(1,i) == yr2005.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2005.storage_res('S61').FCOJ_Sales(1,i) == yr2005.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,2) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,2) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,2) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,2) = 1;
end


% 2006
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2006.storage_res('S15').ORA_Sales(1,i) == yr2006.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2006.storage_res('S15').POJ_Sales(1,i) == yr2006.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2006.storage_res('S15').ROJ_Sales(1,i) == yr2006.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2006.storage_res('S15').FCOJ_Sales(1,i) == yr2006.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,3) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,3) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,3) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,3) = 1;
end

% 2004
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2006.storage_res('S61').ORA_Sales(1,i) == yr2006.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2006.storage_res('S61').POJ_Sales(1,i) == yr2006.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2006.storage_res('S61').ROJ_Sales(1,i) == yr2006.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2006.storage_res('S61').FCOJ_Sales(1,i) == yr2006.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,3) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,3) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,3) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,3) = 1;
end


% 2007
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2007.storage_res('S15').ORA_Sales(1,i) == yr2007.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2007.storage_res('S15').POJ_Sales(1,i) == yr2007.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2007.storage_res('S15').ROJ_Sales(1,i) == yr2007.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2007.storage_res('S15').FCOJ_Sales(1,i) == yr2007.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,4) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,4) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,4) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,4) = 1;
end

% 2007
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2007.storage_res('S61').ORA_Sales(1,i) == yr2007.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2007.storage_res('S61').POJ_Sales(1,i) == yr2007.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2007.storage_res('S61').ROJ_Sales(1,i) == yr2007.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2007.storage_res('S61').FCOJ_Sales(1,i) == yr2007.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,4) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,4) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,4) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,4) = 1;
end


% 2008
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2008.storage_res('S15').ORA_Sales(1,i) == yr2008.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2008.storage_res('S15').POJ_Sales(1,i) == yr2008.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2008.storage_res('S15').ROJ_Sales(1,i) == yr2008.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2008.storage_res('S15').FCOJ_Sales(1,i) == yr2008.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,5) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,5) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,5) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,5) = 1;
end

% 2008
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2008.storage_res('S61').ORA_Sales(1,i) == yr2008.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2008.storage_res('S61').POJ_Sales(1,i) == yr2008.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2008.storage_res('S61').ROJ_Sales(1,i) == yr2008.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2008.storage_res('S61').FCOJ_Sales(1,i) == yr2008.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,5) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,5) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,5) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,5) = 1;
end


% 2009
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2009.storage_res('S15').ORA_Sales(1,i) == yr2009.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2009.storage_res('S15').POJ_Sales(1,i) == yr2009.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2009.storage_res('S15').ROJ_Sales(1,i) == yr2009.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2009.storage_res('S15').FCOJ_Sales(1,i) == yr2009.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,6) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,6) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,6) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,6) = 1;
end

% 2009
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2009.storage_res('S61').ORA_Sales(1,i) == yr2009.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2009.storage_res('S61').POJ_Sales(1,i) == yr2009.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2009.storage_res('S61').ROJ_Sales(1,i) == yr2009.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2009.storage_res('S61').FCOJ_Sales(1,i) == yr2009.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,6) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,6) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,6) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,6) = 1;
end

% 2010
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2010.storage_res('S15').ORA_Sales(1,i) == yr2010.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2010.storage_res('S15').POJ_Sales(1,i) == yr2010.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2010.storage_res('S15').ROJ_Sales(1,i) == yr2010.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2010.storage_res('S15').FCOJ_Sales(1,i) == yr2010.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,7) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,7) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,7) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,7) = 1;
end

% 2010
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2010.storage_res('S61').ORA_Sales(1,i) == yr2010.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2010.storage_res('S61').POJ_Sales(1,i) == yr2010.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2010.storage_res('S61').ROJ_Sales(1,i) == yr2010.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2010.storage_res('S61').FCOJ_Sales(1,i) == yr2010.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,7) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,7) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,7) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,7) = 1;
end


% 2011
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2011.storage_res('S15').ORA_Sales(1,i) == yr2011.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2011.storage_res('S15').POJ_Sales(1,i) == yr2011.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2011.storage_res('S15').ROJ_Sales(1,i) == yr2011.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2011.storage_res('S15').FCOJ_Sales(1,i) == yr2011.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,8) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,8) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,8) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,8) = 1;
end

% 2011
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2011.storage_res('S61').ORA_Sales(1,i) == yr2011.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2011.storage_res('S61').POJ_Sales(1,i) == yr2011.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2011.storage_res('S61').ROJ_Sales(1,i) == yr2011.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2011.storage_res('S61').FCOJ_Sales(1,i) == yr2011.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,8) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,8) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,8) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,8) = 1;
end


% 2012
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2012.storage_res('S15').ORA_Sales(1,i) == yr2012.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2012.storage_res('S15').POJ_Sales(1,i) == yr2012.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2012.storage_res('S15').ROJ_Sales(1,i) == yr2012.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2012.storage_res('S15').FCOJ_Sales(1,i) == yr2012.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,9) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,9) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,9) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,9) = 1;
end

% 2012
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S61').ORA_Sales(1,i) == yr2004.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S61').POJ_Sales(1,i) == yr2004.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S61').ROJ_Sales(1,i) == yr2004.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S61').FCOJ_Sales(1,i) == yr2004.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,1) = 1;
end


% 2013
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S15').ORA_Sales(1,i) == yr2004.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S15').POJ_Sales(1,i) == yr2004.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S15').ROJ_Sales(1,i) == yr2004.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S15').FCOJ_Sales(1,i) == yr2004.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,1) = 1;
end

% 2013
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S61').ORA_Sales(1,i) == yr2004.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S61').POJ_Sales(1,i) == yr2004.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S61').ROJ_Sales(1,i) == yr2004.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S61').FCOJ_Sales(1,i) == yr2004.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,1) = 1;
end


% 2014a
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S15').ORA_Sales(1,i) == yr2004.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S15').POJ_Sales(1,i) == yr2004.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S15').ROJ_Sales(1,i) == yr2004.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S15').FCOJ_Sales(1,i) == yr2004.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,1) = 1;
end

% 2014a
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S61').ORA_Sales(1,i) == yr2004.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S61').POJ_Sales(1,i) == yr2004.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S61').ROJ_Sales(1,i) == yr2004.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S61').FCOJ_Sales(1,i) == yr2004.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,1) = 1;
end


% 2014b
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S15').ORA_Sales(1,i) == yr2004.storage_res('S15').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S15').POJ_Sales(1,i) == yr2004.storage_res('S15').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S15').ROJ_Sales(1,i) == yr2004.storage_res('S15').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S15').FCOJ_Sales(1,i) == yr2004.storage_res('S15').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS15(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS15(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS15(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS15(4,1) = 1;
end

% 2014b
countORA = 0;
countPOJ = 0;
countFCOJ = 0;
countROJ = 0;
for i = 1:48
    if (yr2004.storage_res('S61').ORA_Sales(1,i) == yr2004.storage_res('S61').ORA_Sales(2,i))
        countORA = countORA + 1;
    end
     if (yr2004.storage_res('S61').POJ_Sales(1,i) == yr2004.storage_res('S61').POJ_Sales(2,i))
        countPOJ = countPOJ + 1;
     end
     if (yr2004.storage_res('S61').ROJ_Sales(1,i) == yr2004.storage_res('S61').ROJ_Sales(2,i))
        countROJ = countROJ + 1;
     end
     if (yr2004.storage_res('S61').FCOJ_Sales(1,i) == yr2004.storage_res('S61').FCOJ_Sales(2,i))
        countFCOJ = countFCOJ + 1;
    end
end
if (countORA > 3)
    isCensoredS61(1,1) = 1;
end
if (countPOJ > 3)
    isCensoredS61(2,1) = 1;
end
if (countROJ > 3)
    isCensoredS61(3,1) = 1;
end
if (countFCOJ > 3)
    isCensoredS61(4,1) = 1;
end

% Fits for ORA data, removing points that have zero sales.
yr2004_adjSales_tons_month_ORA_res = yr2004.sales_tons_month_ORA_res(1:7,:);
yr2004_adjPricing_ORA_dec = yr2004.pricing_ORA_dec;
yr2005_adjSales_tons_month_ORA_res = yr2005.sales_tons_month_ORA_res(1:7,:);
yr2005_adjPricing_ORA_dec = yr2005.pricing_ORA_dec;
yr2006_adjSales_tons_month_ORA_res = yr2006.sales_tons_month_ORA_res(1:7,:);
yr2006_adjPricing_ORA_dec = yr2006.pricing_ORA_dec;
yr2007_adjSales_tons_month_ORA_res = yr2007.sales_tons_month_ORA_res(1:7,:);
yr2007_adjPricing_ORA_dec = yr2007.pricing_ORA_dec;
yr2008_adjSales_tons_month_ORA_res = yr2008.sales_tons_month_ORA_res(1:7,:);
yr2008_adjPricing_ORA_dec = yr2008.pricing_ORA_dec;
yr2009_adjSales_tons_month_ORA_res = yr2009.sales_tons_month_ORA_res(1:7,:);
yr2009_adjPricing_ORA_dec = yr2009.pricing_ORA_dec;
yr2010_adjSales_tons_month_ORA_res = yr2010.sales_tons_month_ORA_res(1:7,:);
yr2010_adjPricing_ORA_dec = yr2010.pricing_ORA_dec;
yr2011_adjSales_tons_month_ORA_res = yr2011.sales_tons_month_ORA_res(1:7,:);
yr2011_adjPricing_ORA_dec = yr2011.pricing_ORA_dec;
yr2012_adjSales_tons_month_ORA_res = yr2012.sales_tons_month_ORA_res(1:7,:);
yr2012_adjPricing_ORA_dec = yr2012.pricing_ORA_dec;
yr2013_adjSales_tons_month_ORA_res = yr2013.sales_tons_month_ORA_res(1:7,:);
yr2013_adjPricing_ORA_dec = yr2013.pricing_ORA_dec;
yr2014a_adjSales_tons_month_ORA_res = yr2014a.sales_tons_month_ORA_res(1:7,:);
yr2014a_adjPricing_ORA_dec = yr2014a.pricing_ORA_dec;
yr2014b_adjSales_tons_month_ORA_res = yr2014b.sales_tons_month_ORA_res(1:7,:);
yr2014b_adjPricing_ORA_dec = yr2014b.pricing_ORA_dec;
ORA_fits = zeros(7, 3);
for i = 1:7 %regions
    compiled_prices_ORA = [yr2004_adjPricing_ORA_dec(i,:) yr2005_adjPricing_ORA_dec(i,:) yr2006_adjPricing_ORA_dec(i,:)...
        yr2007_adjPricing_ORA_dec(i,:) yr2008_adjPricing_ORA_dec(i,:) yr2009_adjPricing_ORA_dec(i,:) ...
        yr2010_adjPricing_ORA_dec(i,:) yr2011_adjPricing_ORA_dec(i,:) yr2012_adjPricing_ORA_dec(i,:)...
        yr2013_adjPricing_ORA_dec(i,:) yr2014a_adjPricing_ORA_dec(i,:) yr2014b_adjPricing_ORA_dec(i,:)];
    compiled_sales_ORA = [yr2004_adjSales_tons_month_ORA_res(i,:) yr2005_adjSales_tons_month_ORA_res(i,:) yr2006_adjSales_tons_month_ORA_res(i,:)...
        yr2007_adjSales_tons_month_ORA_res(i,:) yr2008_adjSales_tons_month_ORA_res(i,:) yr2009_adjSales_tons_month_ORA_res(i,:) ...
        yr2010_adjSales_tons_month_ORA_res(i,:) yr2011_adjSales_tons_month_ORA_res(i,:) yr2012_adjSales_tons_month_ORA_res(i,:)...
        yr2013_adjSales_tons_month_ORA_res(i,:) yr2014a_adjSales_tons_month_ORA_res(i,:) yr2014b_adjSales_tons_month_ORA_res(i,:)];
    removed = 0;
    for j = 1:length(compiled_sales_ORA)
        counter = j - removed;
        if (compiled_sales_ORA(counter) == 0)
            compiled_sales_ORA(counter) = [];
            compiled_prices_ORA(counter) = [];
            removed = removed + 1;
        end
    end
     ORA_fits(i,:) = polyfit(compiled_prices_ORA, compiled_sales_ORA, 2);
     x2 = 0:.02:4;
     y2 = polyval(ORA_fits(i,:),x2);
     figure();
     hold all;
     %plot(compiled_prices_ORA, compiled_sales_ORA, 'o', x2, y2);
     
     %below, to plot revenue vs. price
     plot(compiled_prices_ORA, compiled_sales_ORA, 'o', x2, y2.*x2);
     title(['ORA, Region ', region{i}]);

end

% Fits for POJ data, removing points that have zero sales.
yr2004_adjSales_tons_month_POJ_res = yr2004.sales_tons_month_POJ_res(1:7,:);
yr2004_adjPricing_POJ_dec = yr2004.pricing_POJ_dec;
yr2005_adjSales_tons_month_POJ_res = yr2005.sales_tons_month_POJ_res(1:7,:);
yr2005_adjPricing_POJ_dec = yr2005.pricing_POJ_dec;
yr2006_adjSales_tons_month_POJ_res = yr2006.sales_tons_month_POJ_res(1:7,:);
yr2006_adjPricing_POJ_dec = yr2006.pricing_POJ_dec;
yr2007_adjSales_tons_month_POJ_res = yr2007.sales_tons_month_POJ_res(1:7,:);
yr2007_adjPricing_POJ_dec = yr2007.pricing_POJ_dec;
yr2008_adjSales_tons_month_POJ_res = yr2008.sales_tons_month_POJ_res(1:7,:);
yr2008_adjPricing_POJ_dec = yr2008.pricing_POJ_dec;
yr2009_adjSales_tons_month_POJ_res = yr2009.sales_tons_month_POJ_res(1:7,:);
yr2009_adjPricing_POJ_dec = yr2009.pricing_POJ_dec;
yr2010_adjSales_tons_month_POJ_res = yr2010.sales_tons_month_POJ_res(1:7,:);
yr2010_adjPricing_POJ_dec = yr2010.pricing_POJ_dec;
yr2011_adjSales_tons_month_POJ_res = yr2011.sales_tons_month_POJ_res(1:7,:);
yr2011_adjPricing_POJ_dec = yr2011.pricing_POJ_dec;
yr2012_adjSales_tons_month_POJ_res = yr2012.sales_tons_month_POJ_res(1:7,:);
yr2012_adjPricing_POJ_dec = yr2012.pricing_POJ_dec;
yr2013_adjSales_tons_month_POJ_res = yr2013.sales_tons_month_POJ_res(1:7,:);
yr2013_adjPricing_POJ_dec = yr2013.pricing_POJ_dec;
yr2014a_adjSales_tons_month_POJ_res = yr2014a.sales_tons_month_POJ_res(1:7,:);
yr2014a_adjPricing_POJ_dec = yr2014a.pricing_POJ_dec;
yr2014b_adjSales_tons_month_POJ_res = yr2014b.sales_tons_month_POJ_res(1:7,:);
yr2014b_adjPricing_POJ_dec = yr2014b.pricing_POJ_dec;
POJ_fits = zeros(7, 3);
for i = 1:7 %regions
    compiled_prices_POJ = [yr2004_adjPricing_POJ_dec(i,:) yr2005_adjPricing_POJ_dec(i,:) yr2006_adjPricing_POJ_dec(i,:)...
        yr2007_adjPricing_POJ_dec(i,:) yr2008_adjPricing_POJ_dec(i,:) yr2009_adjPricing_POJ_dec(i,:) ...
        yr2010_adjPricing_POJ_dec(i,:) yr2011_adjPricing_POJ_dec(i,:) yr2012_adjPricing_POJ_dec(i,:)...
        yr2013_adjPricing_POJ_dec(i,:) yr2014a_adjPricing_POJ_dec(i,:) yr2014b_adjPricing_POJ_dec(i,:)];
    compiled_sales_POJ = [yr2004_adjSales_tons_month_POJ_res(i,:) yr2005_adjSales_tons_month_POJ_res(i,:) yr2006_adjSales_tons_month_POJ_res(i,:)...
        yr2007_adjSales_tons_month_POJ_res(i,:) yr2008_adjSales_tons_month_POJ_res(i,:) yr2009_adjSales_tons_month_POJ_res(i,:) ...
        yr2010_adjSales_tons_month_POJ_res(i,:) yr2011_adjSales_tons_month_POJ_res(i,:) yr2012_adjSales_tons_month_POJ_res(i,:)...
        yr2013_adjSales_tons_month_POJ_res(i,:) yr2014a_adjSales_tons_month_POJ_res(i,:) yr2014b_adjSales_tons_month_POJ_res(i,:)];
    removed = 0;
    for j = 1:length(compiled_sales_POJ)
        counter = j - removed;
        if (compiled_sales_POJ(counter) == 0)
            compiled_sales_POJ(counter) = [];
            compiled_prices_POJ(counter) = [];
            removed = removed + 1;
        end
    end
     POJ_fits(i,:) = polyfit(compiled_prices_POJ, compiled_sales_POJ, 2);
     x2 = 0:.02:4;
     y2 = polyval(POJ_fits(i,:),x2);
     figure();
     hold all;
     %plot(compiled_prices_POJ, compiled_sales_POJ, 'o', x2, y2);
     plot(compiled_prices_POJ, compiled_sales_POJ, 'o', x2, y2.*x2);
     title(['POJ, Region ', region{i}]);

end

% Fits for FCOJ data, removing points that have zero sales.
yr2004_adjSales_tons_month_FCOJ_res = yr2004.sales_tons_month_FCOJ_res(1:7,:);
yr2004_adjPricing_FCOJ_dec = yr2004.pricing_FCOJ_dec;
yr2005_adjSales_tons_month_FCOJ_res = yr2005.sales_tons_month_FCOJ_res(1:7,:);
yr2005_adjPricing_FCOJ_dec = yr2005.pricing_FCOJ_dec;
yr2006_adjSales_tons_month_FCOJ_res = yr2006.sales_tons_month_FCOJ_res(1:7,:);
yr2006_adjPricing_FCOJ_dec = yr2006.pricing_FCOJ_dec;
yr2007_adjSales_tons_month_FCOJ_res = yr2007.sales_tons_month_FCOJ_res(1:7,:);
yr2007_adjPricing_FCOJ_dec = yr2007.pricing_FCOJ_dec;
yr2008_adjSales_tons_month_FCOJ_res = yr2008.sales_tons_month_FCOJ_res(1:7,:);
yr2008_adjPricing_FCOJ_dec = yr2008.pricing_FCOJ_dec;
yr2009_adjSales_tons_month_FCOJ_res = yr2009.sales_tons_month_FCOJ_res(1:7,:);
yr2009_adjPricing_FCOJ_dec = yr2009.pricing_FCOJ_dec;
yr2010_adjSales_tons_month_FCOJ_res = yr2010.sales_tons_month_FCOJ_res(1:7,:);
yr2010_adjPricing_FCOJ_dec = yr2010.pricing_FCOJ_dec;
yr2011_adjSales_tons_month_FCOJ_res = yr2011.sales_tons_month_FCOJ_res(1:7,:);
yr2011_adjPricing_FCOJ_dec = yr2011.pricing_FCOJ_dec;
yr2012_adjSales_tons_month_FCOJ_res = yr2012.sales_tons_month_FCOJ_res(1:7,:);
yr2012_adjPricing_FCOJ_dec = yr2012.pricing_FCOJ_dec;
yr2013_adjSales_tons_month_FCOJ_res = yr2013.sales_tons_month_FCOJ_res(1:7,:);
yr2013_adjPricing_FCOJ_dec = yr2013.pricing_FCOJ_dec;
yr2014a_adjSales_tons_month_FCOJ_res = yr2014a.sales_tons_month_FCOJ_res(1:7,:);
yr2014a_adjPricing_FCOJ_dec = yr2014a.pricing_FCOJ_dec;
yr2014b_adjSales_tons_month_FCOJ_res = yr2014b.sales_tons_month_FCOJ_res(1:7,:);
yr2014b_adjPricing_FCOJ_dec = yr2014b.pricing_FCOJ_dec;
FCOJ_fits = zeros(7, 3);
for i = 1:7 %regions
    compiled_prices_FCOJ = [yr2004_adjPricing_FCOJ_dec(i,:) yr2005_adjPricing_FCOJ_dec(i,:) yr2006_adjPricing_FCOJ_dec(i,:)...
        yr2007_adjPricing_FCOJ_dec(i,:) yr2008_adjPricing_FCOJ_dec(i,:) yr2009_adjPricing_FCOJ_dec(i,:) ...
        yr2010_adjPricing_FCOJ_dec(i,:) yr2011_adjPricing_FCOJ_dec(i,:) yr2012_adjPricing_FCOJ_dec(i,:)...
        yr2013_adjPricing_FCOJ_dec(i,:) yr2014a_adjPricing_FCOJ_dec(i,:) yr2014b_adjPricing_FCOJ_dec(i,:)];
    compiled_sales_FCOJ = [yr2004_adjSales_tons_month_FCOJ_res(i,:) yr2005_adjSales_tons_month_FCOJ_res(i,:) yr2006_adjSales_tons_month_FCOJ_res(i,:)...
        yr2007_adjSales_tons_month_FCOJ_res(i,:) yr2008_adjSales_tons_month_FCOJ_res(i,:) yr2009_adjSales_tons_month_FCOJ_res(i,:) ...
        yr2010_adjSales_tons_month_FCOJ_res(i,:) yr2011_adjSales_tons_month_FCOJ_res(i,:) yr2012_adjSales_tons_month_FCOJ_res(i,:)...
        yr2013_adjSales_tons_month_FCOJ_res(i,:) yr2014a_adjSales_tons_month_FCOJ_res(i,:) yr2014b_adjSales_tons_month_FCOJ_res(i,:)];
    removed = 0;
    for j = 1:length(compiled_sales_FCOJ)
        counter = j - removed;
        if (compiled_sales_FCOJ(counter) == 0)
            compiled_sales_FCOJ(counter) = [];
            compiled_prices_FCOJ(counter) = [];
            removed = removed + 1;
        end
    end
     FCOJ_fits(i,:) = polyfit(compiled_prices_FCOJ, compiled_sales_FCOJ, 2);
     x2 = 0:.02:4;
     y2 = polyval(FCOJ_fits(i,:),x2);
     figure();
     hold all;
     %plot(compiled_prices_FCOJ, compiled_sales_FCOJ, 'o', x2, y2);
     plot(compiled_prices_FCOJ, compiled_sales_FCOJ, 'o', x2, y2.*x2);
     title(['FCOJ, Region ', region{i}]);

end

% Fits for ROJ data, removing points that have zero sales.
yr2004_adjSales_tons_month_ROJ_res = yr2004.sales_tons_month_ROJ_res(1:7,:);
yr2004_adjPricing_ROJ_dec = yr2004.pricing_ROJ_dec;
yr2005_adjSales_tons_month_ROJ_res = yr2005.sales_tons_month_ROJ_res(1:7,:);
yr2005_adjPricing_ROJ_dec = yr2005.pricing_ROJ_dec;
yr2006_adjSales_tons_month_ROJ_res = yr2006.sales_tons_month_ROJ_res(1:7,:);
yr2006_adjPricing_ROJ_dec = yr2006.pricing_ROJ_dec;
yr2007_adjSales_tons_month_ROJ_res = yr2007.sales_tons_month_ROJ_res(1:7,:);
yr2007_adjPricing_ROJ_dec = yr2007.pricing_ROJ_dec;
yr2008_adjSales_tons_month_ROJ_res = yr2008.sales_tons_month_ROJ_res(1:7,:);
yr2008_adjPricing_ROJ_dec = yr2008.pricing_ROJ_dec;
yr2009_adjSales_tons_month_ROJ_res = yr2009.sales_tons_month_ROJ_res(1:7,:);
yr2009_adjPricing_ROJ_dec = yr2009.pricing_ROJ_dec;
yr2010_adjSales_tons_month_ROJ_res = yr2010.sales_tons_month_ROJ_res(1:7,:);
yr2010_adjPricing_ROJ_dec = yr2010.pricing_ROJ_dec;
yr2011_adjSales_tons_month_ROJ_res = yr2011.sales_tons_month_ROJ_res(1:7,:);
yr2011_adjPricing_ROJ_dec = yr2011.pricing_ROJ_dec;
yr2012_adjSales_tons_month_ROJ_res = yr2012.sales_tons_month_ROJ_res(1:7,:);
yr2012_adjPricing_ROJ_dec = yr2012.pricing_ROJ_dec;
yr2013_adjSales_tons_month_ROJ_res = yr2013.sales_tons_month_ROJ_res(1:7,:);
yr2013_adjPricing_ROJ_dec = yr2013.pricing_ROJ_dec;
yr2014a_adjSales_tons_month_ROJ_res = yr2014a.sales_tons_month_ROJ_res(1:7,:);
yr2014a_adjPricing_ROJ_dec = yr2014a.pricing_ROJ_dec;
yr2014b_adjSales_tons_month_ROJ_res = yr2014b.sales_tons_month_ROJ_res(1:7,:);
yr2014b_adjPricing_ROJ_dec = yr2014b.pricing_ROJ_dec;
ROJ_fits = zeros(7, 3);
for i = 1:7 %regions
    compiled_prices_ROJ = [yr2004_adjPricing_ROJ_dec(i,:) yr2005_adjPricing_ROJ_dec(i,:) yr2006_adjPricing_ROJ_dec(i,:)...
        yr2007_adjPricing_ROJ_dec(i,:) yr2008_adjPricing_ROJ_dec(i,:) yr2009_adjPricing_ROJ_dec(i,:) ...
        yr2010_adjPricing_ROJ_dec(i,:) yr2011_adjPricing_ROJ_dec(i,:) yr2012_adjPricing_ROJ_dec(i,:)...
        yr2013_adjPricing_ROJ_dec(i,:) yr2014a_adjPricing_ROJ_dec(i,:) yr2014b_adjPricing_ROJ_dec(i,:)];
    compiled_sales_ROJ = [yr2004_adjSales_tons_month_ROJ_res(i,:) yr2005_adjSales_tons_month_ROJ_res(i,:) yr2006_adjSales_tons_month_ROJ_res(i,:)...
        yr2007_adjSales_tons_month_ROJ_res(i,:) yr2008_adjSales_tons_month_ROJ_res(i,:) yr2009_adjSales_tons_month_ROJ_res(i,:) ...
        yr2010_adjSales_tons_month_ROJ_res(i,:) yr2011_adjSales_tons_month_ROJ_res(i,:) yr2012_adjSales_tons_month_ROJ_res(i,:)...
        yr2013_adjSales_tons_month_ROJ_res(i,:) yr2014a_adjSales_tons_month_ROJ_res(i,:) yr2014b_adjSales_tons_month_ROJ_res(i,:)];
    removed = 0;
    for j = 1:length(compiled_sales_ROJ)
        counter = j - removed;
        if (compiled_sales_ROJ(counter) == 0)
            compiled_sales_ROJ(counter) = [];
            compiled_prices_ROJ(counter) = [];
            removed = removed + 1;
        end
    end
     ROJ_fits(i,:) = polyfit(compiled_prices_ROJ, compiled_sales_ROJ, 2);
     x2 = 0:.02:4;
     y2 = polyval(ROJ_fits(i,:),x2);
     figure();
     hold all;
     %plot(compiled_prices_ROJ, compiled_sales_ROJ, 'o', x2, y2);
     plot(compiled_prices_ROJ, compiled_sales_ROJ, 'o', x2, y2.*x2);
     title(['ROJ, Region ', region{i}]);

function [ ORA_demand, POJ_demand, FCOJ_demand, ROJ_demand, transport_cost ] = getDemand(cities)
    % Will return the demand for each city
    ORA_demand = 0;
    POJ_demand = 0;
    FCOJ_demand = 0;
    ROJ_demand = 0;
    for i = 1:numel(cities/3)
       ora = oraDemand(cities{i,1});
       poj = pojDemand(cities{i,1});
       fcoj = fcojDemand(cities{i,1});
       roj = rojDemand(cities{i,1});
       transport_cost = 1.2*cities{i,3}*(ora+poj+fcoj+roj);
       ORA_demand = ORA_demand + ora;
       POJ_demand = POJ_demand + poj;
       FCOJ_demand = FCOJ_demand + fcoj;
       ROJ_demand = ROJ_demand + roj;
    end
end

