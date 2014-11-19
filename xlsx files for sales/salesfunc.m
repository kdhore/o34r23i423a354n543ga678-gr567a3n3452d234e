function [percentageMonths, percentageYears] = salesfunc(year, product)
%% Compute percentage for each city (monthly)
%1:14:NE. 5:21:MA. 32:43:SE. 44:65:MW. 66:81:DS. 82:89:NW. 90:100:SW
sheet1 = 'ORA';
sheet2 = 'POJ';
sheet3 = 'ROJ';
sheet4 = 'FCOJ';

range = 'D6:CU105'; %the range. Odd columns are sales (relevant)

file2004 = 'MomPop2004Results';
file2005 = 'MomPop2005Results';
file2006 = 'MomPop2006Results';
file2007 = 'MomPop2007Results';
file2008 = 'MomPop2008Results';
file2009 = 'MomPop2009Results';
file2010 = 'MomPop2010Results';
file2011 = 'MomPop2011Results';
file2012 = 'MomPop2012Results';
file2013 = 'MomPop2013Results';
file2014a = 'oriangagrande2014aResults';
file2014b = 'oriangagrande2014bResults';

%clean data so only the sales are in the arrays

if strcmp(year,'2004') == 1
    %2004 data
    data2004O = xlsread(file2004,sheet1,range);
    data2004P = xlsread(file2004,sheet2,range);
    data2004R = xlsread(file2004,sheet3,range);
    data2004F = xlsread(file2004,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2004O(:,i*2-1);
        temp2(:,i) = data2004P(:,i*2-1);
        temp3(:,i) = data2004R(:,i*2-1);
        temp4(:,i) = data2004F(:,i*2-1);
    end
elseif strcmp(year,'2005') == 1
    
    %2005 data
    data2005O = xlsread(file2005,sheet1,range);
    data2005P = xlsread(file2005,sheet2,range);
    data2005R = xlsread(file2005,sheet3,range);
    data2005F = xlsread(file2005,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2005O(:,i*2-1);
        temp2(:,i) = data2005P(:,i*2-1);
        temp3(:,i) = data2005R(:,i*2-1);
        temp4(:,i) = data2005F(:,i*2-1);
    end
    
elseif strcmp(year,'2006') == 1
    %2006 data
    data2006O = xlsread(file2006,sheet1,range);
    data2006P = xlsread(file2006,sheet2,range);
    data2006R = xlsread(file2006,sheet3,range);
    data2006F = xlsread(file2006,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2006O(:,i*2-1);
        temp2(:,i) = data2006P(:,i*2-1);
        temp3(:,i) = data2006R(:,i*2-1);
        temp4(:,i) = data2006F(:,i*2-1);
    end
    
elseif strcmp(year,'2007') == 1
    %2007 data
    data2007O = xlsread(file2007,sheet1,range);
    data2007P = xlsread(file2007,sheet2,range);
    data2007R = xlsread(file2007,sheet3,range);
    data2007F = xlsread(file2007,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2007O(:,i*2-1);
        temp2(:,i) = data2007P(:,i*2-1);
        temp3(:,i) = data2007R(:,i*2-1);
        temp4(:,i) = data2007F(:,i*2-1);
    end
    
elseif strcmp(year,'2008') == 1
    %2008 data
    data2008O = xlsread(file2008,sheet1,range);
    data2008P = xlsread(file2008,sheet2,range);
    data2008R = xlsread(file2008,sheet3,range);
    data2008F = xlsread(file2008,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2008O(:,i*2-1);
        temp2(:,i) = data2008P(:,i*2-1);
        temp3(:,i) = data2008R(:,i*2-1);
        temp4(:,i) = data2008F(:,i*2-1);
    end
    
elseif strcmp(year,'2009') == 1
    %2009 data
    data2009O = xlsread(file2009,sheet1,range);
    data2009P = xlsread(file2009,sheet2,range);
    data2009R = xlsread(file2009,sheet3,range);
    data2009F = xlsread(file2009,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2009O(:,i*2-1);
        temp2(:,i) = data2009P(:,i*2-1);
        temp3(:,i) = data2009R(:,i*2-1);
        temp4(:,i) = data2009F(:,i*2-1);
    end
    
elseif strcmp(year,'2010') == 1
    %2010 data
    data2010O = xlsread(file2010,sheet1,range);
    data2010P = xlsread(file2010,sheet2,range);
    data2010R = xlsread(file2010,sheet3,range);
    data2010F = xlsread(file2010,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2010O(:,i*2-1);
        temp2(:,i) = data2010P(:,i*2-1);
        temp3(:,i) = data2010R(:,i*2-1);
        temp4(:,i) = data2010F(:,i*2-1);
    end
    
elseif strcmp(year,'2011') == 1
    %2011 data
    data2011O = xlsread(file2011,sheet1,range);
    data2011P = xlsread(file2011,sheet2,range);
    data2011R = xlsread(file2011,sheet3,range);
    data2011F = xlsread(file2011,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2011O(:,i*2-1);
        temp2(:,i) = data2011P(:,i*2-1);
        temp3(:,i) = data2011R(:,i*2-1);
        temp4(:,i) = data2011F(:,i*2-1);
    end
    
elseif strcmp(year,'2012') == 1
    %2012 data
    data2012O = xlsread(file2012,sheet1,range);
    data2012P = xlsread(file2012,sheet2,range);
    data2012R = xlsread(file2012,sheet3,range);
    data2012F = xlsread(file2012,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2012O(:,i*2-1);
        temp2(:,i) = data2012P(:,i*2-1);
        temp3(:,i) = data2012R(:,i*2-1);
        temp4(:,i) = data2012F(:,i*2-1);
    end
    
elseif strcmp(year,'2013') == 1
    %2013 data
    data2013O = xlsread(file2013,sheet1,range);
    data2013P = xlsread(file2013,sheet2,range);
    data2013R = xlsread(file2013,sheet3,range);
    data2013F = xlsread(file2013,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2013O(:,i*2-1);
        temp2(:,i) = data2013P(:,i*2-1);
        temp3(:,i) = data2013R(:,i*2-1);
        temp4(:,i) = data2013F(:,i*2-1);
    end
    
elseif strcmp(year,'2014a') == 1
    %2014a data
    data2014aO = xlsread(file2014a,sheet1,range);
    data2014aP = xlsread(file2014a,sheet2,range);
    data2014aR = xlsread(file2014a,sheet3,range);
    data2014aF = xlsread(file2014a,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2014aO(:,i*2-1);
        temp2(:,i) = data2014aP(:,i*2-1);
        temp3(:,i) = data2014aR(:,i*2-1);
        temp4(:,i) = data2014aF(:,i*2-1);
    end
    
    
elseif strcmp(year,'2014b') == 1
    %2014b data
    data2014bO = xlsread(file2014b,sheet1,range);
    data2014bP = xlsread(file2014b,sheet2,range);
    data2014bR = xlsread(file2014b,sheet3,range);
    data2014bF = xlsread(file2014b,sheet4,range);
    temp1 = zeros(100,48);
    temp2 = zeros(100,48);
    temp3 = zeros(100,48);
    temp4 = zeros(100,48);
    for i = 1:48
        temp1(:,i) = data2014bO(:,i*2-1);
        temp2(:,i) = data2014bP(:,i*2-1);
        temp3(:,i) = data2014bR(:,i*2-1);
        temp4(:,i) = data2014bF(:,i*2-1);
    end
    
else
    display('Spell the year as a string, cmon');
end

Data = zeros(100,48);

if strcmp(product,'ORA') == 1
    Data = temp1;
elseif strcmp(product,'POJ') == 1
    Data = temp2;
elseif strcmp(product,'ROJ') == 1
    Data = temp3;
elseif strcmp(product,'FCOJ') == 1
    Data = temp4;
else 
    display('Spell the product name right, cmon');
end


%%


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





