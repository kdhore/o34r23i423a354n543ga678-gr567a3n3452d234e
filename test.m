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
%yr2014b = YearData('oriangagrande2014bResults.xlsm',current_OJ);
%current_OJ.update(yr2014b);

for i = 1:7 %regions
    figure();
    hold all;
    scatter(yr2004.pricing_ORA_dec(i,:),yr2004.sales_tons_month_ORA_res(i,:));
    scatter(yr2005.pricing_ORA_dec(i,:),yr2005.sales_tons_month_ORA_res(i,:));
    scatter(yr2006.pricing_ORA_dec(i,:),yr2006.sales_tons_month_ORA_res(i,:));
    scatter(yr2007.pricing_ORA_dec(i,:),yr2007.sales_tons_month_ORA_res(i,:));
    scatter(yr2008.pricing_ORA_dec(i,:),yr2008.sales_tons_month_ORA_res(i,:));
    scatter(yr2009.pricing_ORA_dec(i,:),yr2009.sales_tons_month_ORA_res(i,:));
    scatter(yr2010.pricing_ORA_dec(i,:),yr2010.sales_tons_month_ORA_res(i,:));
    scatter(yr2011.pricing_ORA_dec(i,:),yr2011.sales_tons_month_ORA_res(i,:));
    scatter(yr2012.pricing_ORA_dec(i,:),yr2012.sales_tons_month_ORA_res(i,:));
    scatter(yr2013.pricing_ORA_dec(i,:),yr2013.sales_tons_month_ORA_res(i,:));
    scatter(yr2014a.pricing_ORA_dec(i,:),yr2014a.sales_tons_month_ORA_res(i,:));
    title('ORA, ' + 'Region' + i);
end


for i = 1:7 %regions
    figure;
    hold all;
    scatter(yr2004.pricing_POJ_dec(i,:),yr2004.sales_tons_month_POJ_res(i,:));
    scatter(yr2005.pricing_POJ_dec(i,:),yr2005.sales_tons_month_POJ_res(i,:));
    scatter(yr2006.pricing_POJ_dec(i,:),yr2006.sales_tons_month_POJ_res(i,:));
    scatter(yr2007.pricing_POJ_dec(i,:),yr2007.sales_tons_month_POJ_res(i,:));
    scatter(yr2008.pricing_POJ_dec(i,:),yr2008.sales_tons_month_POJ_res(i,:));
    scatter(yr2009.pricing_POJ_dec(i,:),yr2009.sales_tons_month_POJ_res(i,:));
    scatter(yr2010.pricing_POJ_dec(i,:),yr2010.sales_tons_month_POJ_res(i,:));
    scatter(yr2011.pricing_POJ_dec(i,:),yr2011.sales_tons_month_POJ_res(i,:));
    scatter(yr2012.pricing_POJ_dec(i,:),yr2012.sales_tons_month_POJ_res(i,:));
    scatter(yr2013.pricing_POJ_dec(i,:),yr2013.sales_tons_month_POJ_res(i,:));
    scatter(yr2014a.pricing_POJ_dec(i,:),yr2014a.sales_tons_month_POJ_res(i,:));
    title('POJ, ' + 'Region i');
end

for i = 1:7 %regions
    figure;
    hold all;
    scatter(yr2004.pricing_FCOJ_dec(i,:),yr2004.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2005.pricing_FCOJ_dec(i,:),yr2005.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2006.pricing_FCOJ_dec(i,:),yr2006.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2007.pricing_FCOJ_dec(i,:),yr2007.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2008.pricing_FCOJ_dec(i,:),yr2008.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2009.pricing_FCOJ_dec(i,:),yr2009.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2010.pricing_FCOJ_dec(i,:),yr2010.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2011.pricing_FCOJ_dec(i,:),yr2011.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2012.pricing_FCOJ_dec(i,:),yr2012.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2013.pricing_FCOJ_dec(i,:),yr2013.sales_tons_month_FCOJ_res(i,:));
    scatter(yr2014a.pricing_FCOJ_dec(i,:),yr2014a.sales_tons_month_FCOJ_res(i,:));
    title('FCOJ, ' + 'Region i');
end

for i = 1:7 %regions
    figure;
    hold all;
    scatter(yr2004.pricing_ROJ_dec(i,:),yr2004.sales_tons_month_ROJ_res(i,:));
    scatter(yr2005.pricing_ROJ_dec(i,:),yr2005.sales_tons_month_ROJ_res(i,:));
    scatter(yr2006.pricing_ROJ_dec(i,:),yr2006.sales_tons_month_ROJ_res(i,:));
    scatter(yr2007.pricing_ROJ_dec(i,:),yr2007.sales_tons_month_ROJ_res(i,:));
    scatter(yr2008.pricing_ROJ_dec(i,:),yr2008.sales_tons_month_ROJ_res(i,:));
    scatter(yr2009.pricing_ROJ_dec(i,:),yr2009.sales_tons_month_ROJ_res(i,:));
    scatter(yr2010.pricing_ROJ_dec(i,:),yr2010.sales_tons_month_ROJ_res(i,:));
    scatter(yr2011.pricing_ROJ_dec(i,:),yr2011.sales_tons_month_ROJ_res(i,:));
    scatter(yr2012.pricing_ROJ_dec(i,:),yr2012.sales_tons_month_ROJ_res(i,:));
    scatter(yr2013.pricing_ROJ_dec(i,:),yr2013.sales_tons_month_ROJ_res(i,:));
    scatter(yr2014a.pricing_ROJ_dec(i,:),yr2014a.sales_tons_month_ROJ_res(i,:));
    title('ROJ, ' + 'Region i');
end