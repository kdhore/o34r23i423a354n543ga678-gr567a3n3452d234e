% clear
% clc
% current_OJ = OJGame();
% yr2004 = YearData('MomPop2004Results.xlsm',current_OJ);
% current_OJ.update(yr2004);
% yr2005 = YearData('MomPop2005Results.xlsm',current_OJ);
% current_OJ.update(yr2005);
% yr2006 = YearData('MomPop2006Results.xlsm',current_OJ);
% current_OJ.update(yr2006);
% yr2007 = YearData('MomPop2007Results.xlsm',current_OJ);
% current_OJ.update(yr2007);
% yr2008 = YearData('MomPop2008Results.xlsm',current_OJ);
% current_OJ.update(yr2008);
% yr2009 = YearData('MomPop2009Results.xlsm',current_OJ);
% current_OJ.update(yr2009);
% yr2010 = YearData('MomPop2010Results.xlsm',current_OJ);
% current_OJ.update(yr2010);
% yr2011 = YearData('MomPop2011Results.xlsm',current_OJ);
% current_OJ.update(yr2011);
% yr2012 = YearData('MomPop2012Results.xlsm',current_OJ);
% current_OJ.update(yr2012);
% yr2013 = YearData('MomPop2013Results.xlsm',current_OJ);
% current_OJ.update(yr2013);
% yr2014a = YearData('oriangagrande2014aResults.xlsm',current_OJ);
% current_OJ.update(yr2014a);
% yr2014b = YearData('oriangagrande2014bResults.xlsm',current_OJ);
% current_OJ.update(yr2014b);
% numCities = 110;

% find which years are censored
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
for i = 1:7
    for j = 1:12
        if (yr2004.sales_tons_month_ORA_res(i,j) == 0)
            yr2004_adjSales_tons_month_ORA_res(i,j) = [];
            yr2004_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2005.sales_tons_month_ORA_res(i,j) == 0)
            yr2005_adjSales_tons_month_ORA_res(i,j) = [];
            yr2005_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2006.sales_tons_month_ORA_res(i,j) == 0)
            yr2006_adjSales_tons_month_ORA_res(i,j) = [];
            yr2006_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2007.sales_tons_month_ORA_res(i,j) == 0)
            yr2007_adjSales_tons_month_ORA_res(i,j) = [];
            yr2007_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2008.sales_tons_month_ORA_res(i,j) == 0)
            yr2008_adjSales_tons_month_ORA_res(i,j) = [];
            yr2008_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2009.sales_tons_month_ORA_res(i,j) == 0)
            yr2009_adjSales_tons_month_ORA_res(i,j) = [];
            yr2009_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2010.sales_tons_month_ORA_res(i,j) == 0)
            yr2010_adjSales_tons_month_ORA_res(i,j) = [];
            yr2010_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2011.sales_tons_month_ORA_res(i,j) == 0)
            yr2011_adjSales_tons_month_ORA_res(i,j) = [];
            yr2011_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2012.sales_tons_month_ORA_res(i,j) == 0)
            yr2012_adjSales_tons_month_ORA_res(i,j) = [];
            yr2012_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2013.sales_tons_month_ORA_res(i,j) == 0)
            yr2013_adjSales_tons_month_ORA_res(i,j) = [];
            yr2013_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2014a.sales_tons_month_ORA_res(i,j) == 0)
            yr2014a_adjSales_tons_month_ORA_res(i,j) = [];
            yr2014a_adjPricing_ORA_dec(i,j) = [];
        end
        if (yr2014b.sales_tons_month_ORA_res(i,j) == 0)
            yr2014b_adjSales_tons_month_ORA_res(i,j) = [];
            yr2014b_adjPricing_ORA_dec(i,j) = [];
        end
    end
end

for i = 1:7 %regions
    compiled_prices_ORA = [yr2004_adjPricing_ORA_dec(i,:) yr2005_adjPricing_ORA_dec(i,:) yr2006_adjPricing_ORA_dec(i,:)...
        yr2007_adjPricing_ORA_dec(i,:) yr2008_adjPricing_ORA_dec(i,:) yr2009_adjPricing_ORA_dec(i,:) ...
        yr2010_adjPricing_ORA_dec(i,:) yr2011_adjPricing_ORA_dec(i,:) yr2012_adjPricing_ORA_dec(i,:)...
        yr2013_adjPricing_ORA_dec(i,:) yr2014a_adjPricing_ORA_dec(i,:) yr2014b_adjPricing_ORA_dec(i,:)];
    compiled_sales_ORA = [yr2004_adjSales_tons_month_ORA_res(i,:) yr2005_adjSales_tons_month_ORA_res(i,:) yr2006_adjSales_tons_month_ORA_res(i,:)...
        yr2007_adjSales_tons_month_ORA_res(i,:) yr2008_adjSales_tons_month_ORA_res(i,:) yr2009_adjSales_tons_month_ORA_res(i,:) ...
        yr2010_adjSales_tons_month_ORA_res(i,:) yr2011_adjSales_tons_month_ORA_res(i,:) yr2012_adjSales_tons_month_ORA_res(i,:)...
        yr2013_adjSales_tons_month_ORA_res(i,:) yr2014a_adjSales_tons_month_ORA_res(i,:) yr2014b_adjSales_tons_month_ORA_res(i,:)];

    p = polyfit(compiled_prices_ORA, compiled_sales_ORA, 2);
    x2 = 0:.02:4;
    y2 = polyval(p,x2);
    figure();
    hold all;
    plot(compiled_prices_ORA, compiled_sales_ORA, 'o', x2, y2);
end


for i = 1:7 %regions
    figure;
    hold all;
    scatter(yr2004.pricing_POJ_weekly_dec(i,:),yr2004.sales_week_POJ_res(i,:));
    scatter(yr2005.pricing_POJ_weekly_dec(i,:),yr2005.sales_week_POJ_res(i,:));
    scatter(yr2006.pricing_POJ_weekly_dec(i,:),yr2006.sales_week_POJ_res(i,:));
    scatter(yr2007.pricing_POJ_weekly_dec(i,:),yr2007.sales_week_POJ_res(i,:));
    scatter(yr2008.pricing_POJ_weekly_dec(i,:),yr2008.sales_week_POJ_res(i,:));
    scatter(yr2009.pricing_POJ_weekly_dec(i,:),yr2009.sales_week_POJ_res(i,:));
    scatter(yr2010.pricing_POJ_weekly_dec(i,:),yr2010.sales_week_POJ_res(i,:));
    scatter(yr2011.pricing_POJ_weekly_dec(i,:),yr2011.sales_week_POJ_res(i,:));
    scatter(yr2012.pricing_POJ_weekly_dec(i,:),yr2012.sales_week_POJ_res(i,:));
    scatter(yr2013.pricing_POJ_weekly_dec(i,:),yr2013.sales_week_POJ_res(i,:));
    scatter(yr2014a.pricing_POJ_weekly_dec(i,:),yr2014a.sales_week_POJ_res(i,:));
    scatter(yr2014b.pricing_POJ_weekly_dec(i,:),yr2014b.sales_week_POJ_res(i,:));
    title('POJ, ' + 'Region i');
end

for i = 1:7 %regions
    figure;
    hold all;
    scatter(yr2004.pricing_FCOJ_weekly_dec(i,:),yr2004.sales_week_FCOJ_res(i,:));
    scatter(yr2005.pricing_FCOJ_weekly_dec(i,:),yr2005.sales_week_FCOJ_res(i,:));
    scatter(yr2006.pricing_FCOJ_weekly_dec(i,:),yr2006.sales_week_FCOJ_res(i,:));
    scatter(yr2007.pricing_FCOJ_weekly_dec(i,:),yr2007.sales_week_FCOJ_res(i,:));
    scatter(yr2008.pricing_FCOJ_weekly_dec(i,:),yr2008.sales_week_FCOJ_res(i,:));
    scatter(yr2009.pricing_FCOJ_weekly_dec(i,:),yr2009.sales_week_FCOJ_res(i,:));
    scatter(yr2010.pricing_FCOJ_weekly_dec(i,:),yr2010.sales_week_FCOJ_res(i,:));
    scatter(yr2011.pricing_FCOJ_weekly_dec(i,:),yr2011.sales_week_FCOJ_res(i,:));
    scatter(yr2012.pricing_FCOJ_weekly_dec(i,:),yr2012.sales_week_FCOJ_res(i,:));
    scatter(yr2013.pricing_FCOJ_weekly_dec(i,:),yr2013.sales_week_FCOJ_res(i,:));
    scatter(yr2014a.pricing_FCOJ_weekly_dec(i,:),yr2014a.sales_week_FCOJ_res(i,:));
    scatter(yr2014b.pricing_FCOJ_weekly_dec(i,:),yr2014b.sales_week_FCOJ_res(i,:));
    title('FCOJ, ' + 'Region i');
end

for i = 1:7 %regions
    figure;
    hold all;
    scatter(yr2004.pricing_ROJ_weekly_dec(i,:),yr2004.sales_week_ROJ_res(i,:));
    scatter(yr2005.pricing_ROJ_weekly_dec(i,:),yr2005.sales_week_ROJ_res(i,:));
    scatter(yr2006.pricing_ROJ_weekly_dec(i,:),yr2006.sales_week_ROJ_res(i,:));
    scatter(yr2007.pricing_ROJ_weekly_dec(i,:),yr2007.sales_week_ROJ_res(i,:));
    scatter(yr2008.pricing_ROJ_weekly_dec(i,:),yr2008.sales_week_ROJ_res(i,:));
    scatter(yr2009.pricing_ROJ_weekly_dec(i,:),yr2009.sales_week_ROJ_res(i,:));
    scatter(yr2010.pricing_ROJ_weekly_dec(i,:),yr2010.sales_week_ROJ_res(i,:));
    scatter(yr2011.pricing_ROJ_weekly_dec(i,:),yr2011.sales_week_ROJ_res(i,:));
    scatter(yr2012.pricing_ROJ_weekly_dec(i,:),yr2012.sales_week_ROJ_res(i,:));
    scatter(yr2013.pricing_ROJ_weekly_dec(i,:),yr2013.sales_week_ROJ_res(i,:));
    scatter(yr2014a.pricing_ROJ_weekly_dec(i,:),yr2014a.sales_week_ROJ_res(i,:));
    scatter(yr2014b.pricing_ROJ_weekly_dec(i,:),yr2014b.sales_week_ROJ_res(i,:));
    title('ROJ, ' + 'Region i');
end