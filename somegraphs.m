function [] = graphs(yeardata, oj_obj)
%Input a YearData object, plot graphs that
%will be useful to making decisions with our simulator and policies.

%% OJ game object
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
%%
weeks = zeros(1,48);
for i = 1:48
    weeks(1,i) = i;
end
hold on;

%%
%plot sales of each product over the year (weeks)
sumSalesORA = sum(yeardata.sales_week_ORA_res,1);
sumSalesPOJ = sum(yeardata.sales_week_POJ_res,1);
sumSalesROJ = sum(yeardata.sales_week_ROJ_res,1);
sumSalesFCOJ = sum(yeardata.sales_week_FCOJ_res,1);
plot(weeks, sumSalesORA,'r', weeks, sumSalesPOJ,'b',weeks, ...
    sumSalesROJ,'m',weeks, sumSalesFCOJ,'k');
xlabel('Weeks');
ylabel('Sales');
title(strcat(yeardata.year, ' Sales of Product over Weeks'));
legend('ORA','POJ','ROJ','FCOJ');

%%
%plot transportation costs of each product over the year (weeks)
sumTranspoORA = sum(yeardata.transp_cost_ORA_res,1);
sumTranspoPOJ = sum(yeardata.transp_cost_POJ_res,1);
sumTranspoROJ = sum(yeardata.transp_cost_ROJ_res,1);
sumTranspoFCOJ = sum(yeardata.transp_cost_FCOJ_res,1);
figure();
plot(weeks, sumTranspoORA,'r', weeks, sumTranspoPOJ,'b',weeks, ...
    sumTranspoROJ,'m',weeks, sumTranspoFCOJ,'k');
xlabel('Weeks');
ylabel('Transportation Cost');
title(strcat(yeardata.year, ' Transportation Cost of Product over Weeks'));
legend('ORA','POJ','ROJ','FCOJ');

%%
%plot monthly pricing vs. monthly sales for each item in each region
months = zeros(1,12);
for i = 1:12
    months(1,i) = i;
end
ORAPrice = yeardata.pricing_ORA_dec; %7x12
POJPrice = yeardata.pricing_POJ_dec;
ROJPrice = yeardata.pricing_ROJ_dec;
FCOJPrice = yeardata.pricing_FCOJ_dec;

ORASales = yeardata.sales_tons_month_ORA_res; %7x12
POJSales = yeardata.sales_tons_month_POJ_res;
ROJSales = yeardata.sales_tons_month_ROJ_res;
FCOJSales = yeardata.sales_tons_month_FCOJ_res;

regions = cell(1,10);
regions{1,1} = 'NE';
regions{1,2} = 'MA';
regions{1,3} = 'SE';
regions{1,4} = 'MW';
regions{1,5} = 'DS';
regions{1,6} = 'NW';
regions{1,7} = 'SW';

for i = 1:7
    figure();
    [ax,~,~] = plotyy(months, ORAPrice(i,:), months, ORASales(i,:));
    xlabel('Months');
    ylabel(ax(1),'Price');
    ylabel(ax(2),'Sales');
    title(strcat(num2str(yeardata.year),' ORA Pricing and Sales for ',regions(1,i)));
    
    figure();
    [ax,~,~] = plotyy(months, POJPrice(i,:), months, POJSales(i,:));
    xlabel('Months');
    ylabel(ax(1),'Price');
    ylabel(ax(2),'Sales');
    title(strcat(num2str(yeardata.year),' POJ Pricing and Sales for ',regions(1,i)));
    
    figure();
    [ax,~,~] = plotyy(months, ROJPrice(i,:), months, ROJSales(i,:));
    xlabel('Months');
    ylabel(ax(1),'Price');
    ylabel(ax(2),'Sales');
    title(strcat(num2str(yeardata.year),' ROJ Pricing and Sales for ',regions(1,i)));
    
    figure();
    [ax,~,~] = plotyy(months, FCOJPrice(i,:), months, FCOJSales(i,:));
    xlabel('Months');
    ylabel(ax(1),'Price');
    ylabel(ax(2),'Sales');
    title(strcat(num2str(yeardata.year),' FCOJ Pricing and Sales for ',regions(1,i)));


end

%%

%calculate percent sold for each storage unit
%will give you the array of open storage facilities
open_storages = find(oj_obj.storage_cap);
%spreadsheet_info = zeros(1, length(open_storages)); %each item contains a bunch of matrices
for i = 1:length(open_storages)
        name = char(storageNamesInUse(open_storages(i)));
        spreadsheet_info = yeardata.storage_res(name);
        
        ORAPercSold = zeros(1,48);
        POJPercSold = zeros(1,48);
        ROJPercSold = zeros(1,48);
        FCOJPercSold = zeros(1,48);
        
        for j = 1:48
        ORAPercSold(1,j) = spreadsheet_info.ORA_Sales(2,j)/spreadsheet_info.ORA_Sales(1,j);
        POJPercSold(1,j) = spreadsheet_info.POJ_Sales(2,j)/spreadsheet_info.POJ_Sales(1,j);
        ROJPercSold(1,j) = spreadsheet_info.ROJ_Sales(2,j)/spreadsheet_info.ROJ_Sales(1,j);
        FCOJPercSold(1,j) = spreadsheet_info.FCOJ_Sales(2,j)/spreadsheet_info.FCOJ_Sales(1,j);
        end
        
        figure();
        plot(weeks, ORAPercSold(1,:));
        xlabel('Weeks');
        ylabel('Percentage Sold');
        title(strcat('Percentage of ORA sold from ',name));
        
        figure();
        plot(weeks, POJPercSold(1,:));
        xlabel('Weeks');
        ylabel('Percentage Sold');
        title(strcat('Percentage of POJ sold from ',name));
        
        figure();
        plot(weeks, ROJPercSold(1,:));
        xlabel('Weeks');
        ylabel('Percentage Sold');
        title(strcat('Percentage of ROJ sold from ',name));
        
        figure();
        plot(weeks, FCOJPercSold(1,:));
        xlabel('Weeks');
        ylabel('Percentage Sold');
        title(strcat('Percentage of FCOJ sold from ',name));
end

% the above line of code will give you all the information about a specific storage unit
%the same can be replicated for processing plants


