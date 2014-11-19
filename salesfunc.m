function [percentageMonths, percentageYears] = salesfunc(YearData, product)
%%read in information

if strcmp(product, 'ORA') == 1
    Data = YearData.sales_week_ORA_res;
elseif strcmp(product, 'POJ') == 1
    Data = YearData.sales_week_POJ_res;
elseif strcmp(product, 'ROJ') == 1
    Data = YearData.sales_week_ROJ_res;
elseif strcmp(product, 'FCOJ') == 1
    Data = YearData.sales_week_FCOJ_res;
else
    display('Enter the product name correctly.');
end

%%compute percentage for each month

percentageMonths = zeros(100, 12);
for x = 1:12 %for each month
    
    startIndex = x*4-3; %the column to start at in Data
    
    for cities = 1:100 %for each city
        
        sumMonthCity = Data(cities, startIndex) + Data(cities, startIndex+1)...
            + Data(cities, startIndex+2) + Data(cities, startIndex+3);
        %sumMonthCity is the sum across the month of the sales
        %easier would be:
        %sumMonthCity = sum(Data(cities,startIndex:startIndex+3));
        
        if 0 < cities && cities < 15 %NE
            total = sum(sum(Data(1:14,startIndex:startIndex+3)));
            
        elseif 14 < cities && cities < 32 %MA
            total = sum(sum(Data(15:31,startIndex:startIndex+3)));
            
        elseif 31 < cities && cities < 42 %SE
            total = sum(sum(Data(32:43,startIndex:startIndex+3)));
            
        elseif 43 < cities && cities < 66 %MW
            total = sum(sum(Data(44:65,startIndex:startIndex+3)));
            
        elseif 65 < cities && cities < 82 %DS
            total = sum(sum(Data(66:81,startIndex:startIndex+3)));
            
        elseif 81 < cities && cities < 90 %NW
            total = sum(sum(Data(82:89,startIndex:startIndex+3)));
            
        elseif 89 < cities && cities < 101 %SW
            total = sum(sum(Data(90:100,startIndex:startIndex+3)));
            
        end
        percentageMonths(cities,x) = sumMonthCity/total;
    end
end


%%
percentageYears = zeros(100,1);
for cities = 1:100 %for each city
    
    y = Data(cities,1:48);
    sumYearCity = sum(y);
    %sumYearCity is the sum across the year of the sales for the city
    
    if 0 < cities && cities < 15 %NE
        total = sum(sum(Data(1:14,1:48)));
        
    elseif 14 < cities && cities < 32 %MA
        total = sum(sum(Data(15:31,1:48)));
        
    elseif 31 < cities && cities < 42 %SE
        total = sum(sum(Data(32:43,1:48)));
        
    elseif 43 < cities && cities < 66 %MW
        total = sum(sum(Data(44:65,1:48)));
        
    elseif 65 < cities && cities < 82 %DS
        total = sum(sum(Data(66:81,1:48)));
        
    elseif 81 < cities && cities < 90 %NW
        total = sum(sum(Data(82:89,1:48)));
        
    elseif 89 < cities && cities < 101 %SW
        total = sum(sum(Data(90:100,1:48)));
        
    end
    percentageYears(cities,1) = sumYearCity/total;
end

end





