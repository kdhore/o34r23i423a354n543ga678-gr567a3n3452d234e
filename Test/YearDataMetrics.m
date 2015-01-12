function [] = YearDataMetrics(YearData, ojObject)


% %create relevant oj object
% initial_str = 'Excel Files Orianga/oriangagrande2014Results.xlsm';
% yearFiles = dir('YearData Orianga/*.mat');
% ojObject = OJGame(initial_str);
% for i = 1:(length(yearFiles))
%     year = load(strcat('YearData Orianga/',yearFiles(i).name));
%     yearVar = genvarname(strrep(yearFiles(i).name,'.mat',''));
%     ojObject = ojObject.update(year.(yearVar));
% end

%find storages open
stor_open = find(ojObject.storage_cap);

prompt = strcat('Report for year', num2str(YearData.year), '\n',...
    'What graph do you want to see? Options are: \n',...
    'a Sales v Availability for each storage','\n',...
    'b Sales by product for each month over a region','\n',...
    'c Product wasted per week for each storage unit','\n',...
    'd All','\n');
option = input(prompt);


if strcmp(option,'a') || strcmp(option,'d')
    %for each storage unit, plot available vs. sold for each product
    weeks = zeros(1,48);
    for i = 1:48
        weeks(1,i) = i;
    end
    
    capacity_adj = input('Enter parameter n of scaling capacity = n * mean \n');
    
    
    for i = 1:length(stor_open)
        
        total_cap = zeros(1,48);
        for j = 1:48
            total_cap(1,j) = ojObject.storage_cap(stor_open(i));
        end
        
        figure();
        subplot(2,2,1);
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(2,:));
            title(strcat('ORA Available and Sales for Storage Index ', char...
            (storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('ORA Amount');
        legend('Available', 'Sold');
        
        
        subplot(2,2,2);
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(2,:));
        title(strcat('POJ Available and Sales for Storage Index ', char...
            (storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('POJ Amount');
        legend('Available', 'Sold');
        
        
        subplot(2,2,3);
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(2,:));

        title(strcat('ROJ Available and Sales for Storage Index ', char...
            (storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('ROJ Amount');
        legend('Available', 'Sold');
        
        
        subplot(2,2,4);
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(2,:));
        title(strcat('FCOJ Available and Sales for Storage Index', char...
            (storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('FCOJ Amount');
        legend('Available', 'Sold');
        
        total_available = (YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(1,:)+...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(1,:)+...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(1,:)+...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(1,:));
        total_sold = (YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(2,:)+...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(2,:)+...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(2,:)+...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(2,:));
        
        proposed_cap = zeros(1,48);
        for k = 1:48
            proposed_cap(1,k) = (mean(total_available)+mean(total_sold))/2*capacity_adj;
        end
        
        figure(); %plot total available, total sold, capacity, proposed capacity
        plot(weeks,total_available, weeks, total_sold,...
            weeks,total_cap, weeks, proposed_cap);
        legend('Total Available', 'Total Sold', strcat(num2str(YearData.year),'Capacity'),...
            strcat(num2str(YearData.year),'Proposed Decision =', ...
            num2str(proposed_cap(1,1)-total_cap(1,1)),...
            'using parameter of ', num2str(capacity_adj)));
        ylim([0,ojObject.storage_cap(stor_open(i)) + 1000]);
        xlabel('Weeks');
        ylabel('Product (Tons)');
        title(strcat('Total Products for Storage ',char...
            (storageNamesInUse(stor_open(i)))));
    end
end

if strcmp(option,'b') || strcmp(option,'d')
    %plot product sales vs availability by month to visualize seasonality
    months = zeros(1,12);
    for i = 1:12
        months(1,i) = i;
    end
    regions = ['NE';'MA';'SE';'MW';'DS';'NW';'SW'];
    
    for i = 1:7 %over each region
        figure();
        subplot(2,2,1);
        plot(months,YearData.sales_tons_month_ORA_res(i,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of ORA over region ',regions(i,1),regions(i,2)));
        ylim([0,2000]);
        
        
        
        subplot(2,2,2);
        plot(months,YearData.sales_tons_month_POJ_res(i,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of POJ over region ',regions(i,1),regions(i,2)));
        ylim([0,2000]);
        
        subplot(2,2,3);
        plot(months,YearData.sales_tons_month_ROJ_res(i,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of ROJ over region ',regions(i,1),regions(i,2)));
        ylim([0,2000]);
        
        subplot(2,2,4);
        plot(months,YearData.sales_tons_month_FCOJ_res(i,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of FCOJ over region ',regions(i,1),regions(i,2)));
        ylim([0,2000]);
    end
    
end

if strcmp(option,'c') || strcmp(option,'d')
    %for each storage unit, plot amount wasted vs. months
    weeks = zeros(1,48);
    for i = 1:48
        weeks(1,i) = i;
    end
    
    for i = 1:length(stor_open)
        ORA_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Inv(5,1:48)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(1,:)); %1x49
        POJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Inv(9,1:48)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(1,:));
        ROJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Inv(13,1:48)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(1,:));
        FCOJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Inv(49,1:48)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(1,:));
        
        ORA_cap = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Tossed_Out)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(1,:)); %1x48
        POJ_cap = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Tossed_Out)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(1,:));
        ROJ_cap = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Tossed_Out)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(1,:));
        FCOJ_cap = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Tossed_Out)/...
            mean(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(1,:));
        
        
        figure();
        subplot(2,2,1);
        plot(weeks,ORA_rot,weeks,ORA_cap,weeks,ORA_rot+ORA_cap);
        title(strcat('ORA rotted and capacity tossed out for Storage ',...
            char(storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('ORA Lost as % Available');
        ylim([-0.1,1]);
        legend('Rotted', 'Capacity', 'Total Lost');
        
        subplot(2,2,2);
        plot(weeks,POJ_rot,weeks,POJ_cap,weeks,POJ_rot+POJ_cap);
        title(strcat('POJ rotted and capacity tossed out for Storage ',...
            char(storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('POJ Lost as % Available');
        ylim([-0.1,1]);
        legend('Rotted', 'Capacity', 'Total Lost');
        
        subplot(2,2,3);
        plot(weeks,ROJ_rot,weeks,ROJ_cap,weeks,ROJ_rot+ROJ_cap);
        title(strcat('ROJ rotted and capacity tossed out for Storage ',...
            char(storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('ROJ Lost as % Available');
        ylim([-0.1,1]);
        legend('Rotted', 'Capacity', 'Total Lost');
        
        
        subplot(2,2,4);
        plot(weeks,FCOJ_rot,weeks,FCOJ_cap,weeks,FCOJ_rot+FCOJ_cap);
        title(strcat('FCOJ rotted and capacity tossed out for Storage ',...
            char(storageNamesInUse(stor_open(i)))));
        xlabel('Weeks');
        ylabel('FCOJ Lost as % Available');
        ylim([-0.1,1]);
        legend('Rotted', 'Capacity', 'Total Lost');
        
    end
end


end

