function [] = YearDataMetrics(YearData, ojObject)

%plants_open = find(ojObject.proc_plant_cap);
stor_open = find(ojObject.storage_cap);

prompt = strcat('Report for year', YearData.year, '\n',...
    'What graph do you want to see? Options are: \n',...
    'a Sales v Availability for each storage','\n',...
    'b Sales by product for each month over a region','\n',...
    'c Product wasted per week for each storage unit','\n',...
    'd All','\n');
option = input(prompt);

if strcmp(option,'a')
    %for each storage unit, plot available vs. sold for each product
    weeks = zeros(1,48);
    for i = 1:48
        weeks(1,i) = i;
    end
    for i = 1:length(stor_open)
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(2,:));
        title(strcat('ORA Available and Sales for Storage Index ', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('ORA Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
        
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(2,:));
        title(strcat('POJ Available and Sales for Storage Index ', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('POJ Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
        
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(2,:));
        title(strcat('ROJ Available and Sales for Storage Index ', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('ROJ Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
        
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(2,:));
        title(strcat('FCOJ Available and Sales for Storage Index', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('FCOJ Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
    end
    
    
elseif strcmp(option,'b')
    %plot product sales vs availability by month to visualize seasonality
    months = zeros(1,12);
    for i = 1:12
        months(1,i) = i;
    end
    regions = ['NE';'MA';'SE';'MW';'DS';'NW';'SW'];
    
    for i = 1:7 %over each region
        figure();
        plot(months,YearData.sales_tons_month_ORA_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of ORA over region ',regions(i,1),regions(i,2)));
        
        
        
        figure();
        plot(months,YearData.sales_tons_month_POJ_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of POJ over region ',regions(i,1),regions(i,2)));
        
        
        figure();
        plot(months,YearData.sales_tons_month_ROJ_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of ROJ over region ',regions(i,1),regions(i,2)));
        
        
        figure();
        plot(months,YearData.sales_tons_month_FCOJ_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of FCOJ over region ',regions(i,1),regions(i,2)));
    end
elseif strcmp(option,'c')
    %for each storage unit, plot amount wasted vs. months
    ORA_cap = zeros(1,49);
    POJ_cap = zeros(1,49);
    ROJ_cap = zeros(1,49);
    FCOJ_cap = zeros(1,49);
    weeksAdj = zeros(1,49);
    for i = 2:49
        weeksAdj(1,i) = i-1;
    end
    for i = 1:length(stor_open)
        ORA_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Inv(5,:); %1x49
        POJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Inv(9,:);
        ROJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Inv(13,:);
        FCOJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Inv(49,:);
        
        ORA_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Tossed_Out); %1x48
        POJ_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Tossed_Out);
        ROJ_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Tossed_Out);
        FCOJ_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Tossed_Out);
        
        
        figure();
        plot(weeksAdj,ORA_rot,weeksAdj,ORA_cap,weeksAdj,ORA_rot+ORA_cap);
        title(strcat('ORA rotted and capacity tossed out for Storage Index ',...
            num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('ORA Amount');
        legend('Rotted', 'Capacity', 'Total Lost');
        
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
    end
elseif strcmp(option,'d')
    weeks = zeros(1,48);
    for i = 1:48
        weeks(1,i) = i;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %for each storage unit, plot available vs. sold for each product
    for i = 1:length(stor_open)
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Sales(2,:));
        title(strcat('ORA Available and Sales for Storage Index ', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('ORA Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
        
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Sales(2,:));
        title(strcat('POJ Available and Sales for Storage Index ', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('POJ Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
        
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Sales(2,:));
        title(strcat('ROJ Available and Sales for Storage Index ', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('ROJ Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
        
        figure();
        plot(weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(1,:),...
            weeks,...
            YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Sales(2,:));
        title(strcat('FCOJ Available and Sales for Storage Index', num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('FCOJ Amount');
        legend('Available', 'Sold');
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %plot product sales vs availability by month to visualize seasonality
    months = zeros(1,12);
    for i = 1:12
        months(1,i) = i;
    end
    regions = ['NE';'MA';'SE';'MW';'DS';'NW';'SW'];
    
    for i = 1:7 %over each region
        figure();
        plot(months,YearData.sales_tons_month_ORA_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of ORA over region ',regions(i,1),regions(i,2)));
        
        
        
        figure();
        plot(months,YearData.sales_tons_month_POJ_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of POJ over region ',regions(i,1),regions(i,2)));
        
        
        figure();
        plot(months,YearData.sales_tons_month_ROJ_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of ROJ over region ',regions(i,1),regions(i,2)));
        
        
        figure();
        plot(months,YearData.sales_tons_month_FCOJ_res(1,:));
        xlabel('Month');
        ylabel('Sales (tons)');
        title(strcat('Sales by month of FCOJ over region ',regions(i,1),regions(i,2)));
    end
    % productSales = cell(4,1); %4 different products
    % productAvailability = cell(4,1);
    % totalProductSales = cell(4,1);
    % productSales{1,1} = YearData.sales_tons_month_ORA_res; %7x12
    % productSales{2,1} = YearData.sales_tons_month_POJ_res; %7x12
    % productSales{3,1} = YearData.sales_tons_month_ROJ_res; %7x12
    % productSales{4,1} = YearData.sales_tons_month_FCOJ_res; %7x12
    %
    % productAvailability{1,1} = zeros(7,12);
    % totalProductSales{2,1} = zeros(4,12);
    %
    % totalProductSales = productSales{1,1} + productSales{2,1} +...
    %     productSales{3,1} + productSales{4,1};
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %for each storage unit, plot amount wasted vs. months
    ORA_cap = zeros(1,49);
    POJ_cap = zeros(1,49);
    ROJ_cap = zeros(1,49);
    FCOJ_cap = zeros(1,49);
    weeksAdj = zeros(1,49);
    for i = 2:49
        weeksAdj(1,i) = i-1;
    end
    for i = 1:length(stor_open)
        ORA_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Inv(5,:); %1x49
        POJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Inv(9,:);
        ROJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Inv(13,:);
        FCOJ_rot = YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Inv(49,:);
        
        ORA_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ORA_Tossed_Out); %1x48
        POJ_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).POJ_Tossed_Out);
        ROJ_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).ROJ_Tossed_Out);
        FCOJ_cap(1,2:49) = sum(YearData.storage_res(char...
            (storageNamesInUse(stor_open(i)))).FCOJ_Tossed_Out);
        
        
        figure();
        plot(weeksAdj,ORA_rot,weeksAdj,ORA_cap,weeksAdj,ORA_rot+ORA_cap);
        title(strcat('ORA rotted and capacity tossed out for Storage Index ',...
            num2str(stor_open(i))));
        xlabel('Weeks');
        ylabel('ORA Amount');
        legend('Rotted', 'Capacity', 'Total Lost');
        
        % stor_open(i) is NOT the real name of the storage unit, just the index
        % that it's at in the possible storage units -- just a note
    end
    
    
else
    disp('Not a valid input!');
end


end

