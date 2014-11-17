% find which storage units to use to meet demand
filename = 'Transportation.xlsx';

%sheetGPS = 'GroProcStor'; %oranges
sheetGPSC = 'GroProcStorChoice';

%sheetPS = 'ProcStor'; %POJ and FCOJ
sheetPSC = 'ProcStorChoice';

%sheetSM = 'StorMarket';
sheetSMC = 'StorMarketChoice'; %ORA, POJ, FCOJ, ROJ

%sheetDD = 'DummyDemand';
%rangeDD = 'D2:D101';

%rangeGPS = 'N2:Q82';
rangeGPC = 'N2:Q11';

rangeGSC = 'N13:Q33';

%rangePS = 'Z2:AI72';
rangePSC = 'B2:K22';

%rangeSM = 'EW2:HO101';
rangeSMC = 'C2:W101';

%GroProcStor = xlsread(filename, sheetGPS, rangeGPS); %81x4 (Proc/Stor x Groves)
GroProcChoice = xlsread(filename, sheetGPSC, rangeGPC); %10x4 (Proc x Groves)
GroStorChoice = xlsread(filename, sheetGPSC, rangeGSC); %21x4 (Stor x Groves)

%ProcStor = xlsread(filename, sheetPS, rangePS); %71x10 (Storage x Procs)
ProcStorChoice = xlsread(filename, sheetPSC, rangePSC); 
%21x10 (Storage x Procs)[choice]

%StorMarket = xlsread(filename, sheetSM, rangeSM); %100x71 (Markets x Storage)
StorMarketChoice = xlsread(filename, sheetSMC, rangeSMC); 
%100x21 (markets x storage [choice])
%rows: NE: 1-14. MA:15-31. SE:32-43. MW:44-65. DS:66-81. NW:82-89. SW:90-100.

%in miles (converted)
%DummyDemand = xlsread(filename, sheetDD, rangeDD);

grovesUsed = zeros(1,4);
procsUsed = zeros(1,10);
%storagesUsed = zeros(1,71);

demands = [400, 1000, 1000, 600; 250, 450, 500, 400; ...
    600, 1000, 2000, 600; 800, 1000, 1600, 1000;...
    1000, 900, 1200, 600; 600, 2000, 3000, 1100;...
    700, 1500, 1100, 700];
demands = rot90(demands,2);
%7x4. rows: NE, MA, SE, MW, DS, NW, SW
%in StorMarketChoice: NE: 1-14. MA:15-31. SE:32-43. MW:44-65. DS:66-81. NW:82-89. SW:90-100.
%cols: ORA, POJ, ROJ, FCOJ
%total of sum(sum(demands)) = 27600

ORADemandCities = zeros(100,1); %to line up with iteration below
POJDemandCities = zeros(100,1);
ROJDemandCities = zeros(100,1);
FCOJDemandCities = zeros(100,1);
for i = 1:14 %NE
    ORADemandCities(i,1) = demands(1,1)/14;
    POJDemandCities(i,1) = demands(1,2)/14;
    ROJDemandCities(i,1) = demands(1,3)/14;
    FCOJDemandCities(i,1) = demands(1,4)/14;
end
for i = 15:31 %MA
    ORADemandCities(i,1) = demands(1,1)/17;
    POJDemandCities(i,1) = demands(1,2)/17;
    ROJDemandCities(i,1) = demands(1,3)/17;
    FCOJDemandCities(i,1) = demands(1,4)/17;
end
for i = 32:43 %SE
    ORADemandCities(i,1) = demands(1,1)/12;
    POJDemandCities(i,1) = demands(1,2)/12;
    ROJDemandCities(i,1) = demands(1,3)/12;
    FCOJDemandCities(i,1) = demands(1,4)/12;
end
for i = 44:65 %MW
    ORADemandCities(i,1) = demands(1,1)/22;
    POJDemandCities(i,1) = demands(1,2)/22;
    ROJDemandCities(i,1) = demands(1,3)/22;
    FCOJDemandCities(i,1) = demands(1,4)/22;
end
for i = 66:81 %DS
    ORADemandCities(i,1) = demands(1,1)/16;
    POJDemandCities(i,1) = demands(1,2)/16;
    ROJDemandCities(i,1) = demands(1,3)/16;
    FCOJDemandCities(i,1) = demands(1,4)/16;
end
for i = 82:89 %NW
    ORADemandCities(i,1) = demands(1,1)/8;
    POJDemandCities(i,1) = demands(1,2)/8;
    ROJDemandCities(i,1) = demands(1,3)/8;
    FCOJDemandCities(i,1) = demands(1,4)/8;
end
for i = 90:100 %SW
    ORADemandCities(i,1) = demands(1,1)/11;
    POJDemandCities(i,1) = demands(1,2)/11;
    ROJDemandCities(i,1) = demands(1,3)/11;
    FCOJDemandCities(i,1) = demands(1,4)/11;
end
%demands for each city set by proportion of overall demand


%% 

%grovesNum = 4;

storageUnitNum = 5; %number of storage units to use -- can be adjusted <= 21


%aggregateDemand = sum(sum(demands)); %can be adjusted with price forecasts


%calculate all possible combinations of storageUnitNum / 21 sectors in
%binary

numStorageUnitsUsed = [1048576,1572864,1835008,1966080,2031616];
StorageCombos = zeros(nchoosek(21,storageUnitNum),21); %permutations by 21
j = 1;
for i = 1:numStorageUnitsUsed(1,storageUnitNum) 
    %choice of 21 storage units; the i loop is until the base 10
    %representation of the max number. Here, it's 1 + 20 0's (e.g. if it
    %was a choice of 2 storage units, it would be 2 1's + 19 0's)
    %1 storage unit: 1048576 = bin2dec('100000000000000000000')
    %2 storage units: 1572864
    %3 storage units: 1835008
    %4 storage units: 1966080
    %5 storage units: 2031616
    
    x = num2str(dec2bin(i))-'0'; %converted to binary in number representation
    if sum(x) == storageUnitNum %if the storageUnitNum is being used
        n = size(x,2); %number of total elements
        for k = 1:n
            StorageCombos(j,21-k+1) = x(1,n-k+1);
        end
        j = j+1;
    end
end


%%
procsNum = 2; % <=10
%number of processing plants to be used -- can be adjusted

%calculate all possible combinations of procsNum / 10 sectors in
%binary

numProcsUsed = [512,768,896,960,992,1008,1016,1020,1022,1023];
ProcsCombos = zeros(nchoosek(10,procsNum), 10); %permutations of 10 digits
j = 1;
for i = 1:numProcsUsed(1,procsNum) 
    %choice of 10 processing plants; the i loop is until the base 10
    %representation of the max number. Here, it's 1 + 9 0's (e.g. if it
    %was a choice of 2 processing plants, it would be 2 1's + 8 0's)
    %1 storage unit: 512 = bin2dec('1000000000')
    %2 storage units: 768; etc.
    
    x = num2str(dec2bin(i))-'0'; %converted to binary in number representation
    if sum(x) == procsNum %if the procsNum is being used
        n = size(x,2); %number of total elements
        for k = 1:n
            ProcsCombos(j,10-k+1) = x(1,n-k+1);
        end
        j = j+1;
    end
end



%%

% totalCost = 0;
% %total storage unit cost after 2 years. use sample of $2.50 priced -> 27600
% %demand
% totalStorageCost = storageUnitNum*9000000 + 6000*aggregateDemand + ...
%     storageUnitNum*(7500000 + 650*aggregateDemand/storageUnitNum);
% %creation, capacity upgrade, maintenence
% %average storage unit capacity per number


 a = [15,22,23,34,45,56,67,49,94,74,63,52,61,51,41,43,32,1,21,50,40];
 a = sort(a);
 %storage units being considered

%%

%rows: NE: 1-14. MA:15-31. SE:32-43. MW:44-65. DS:66-81. NW:82-89. SW:90-100.

minStorMarketDist = Inf;
bestStorageChoice = zeros(1,21);
StoragesServingCities = zeros(100,1); %the storage units that serve those cities
procsUsed = zeros(1,procsNum);
storagesUsed = zeros(1,storageUnitNum);

%iterate through all possible networks with this number of
%storage locations and markets
for i = 1:nchoosek(21,storageUnitNum) %for each of the iterations
    transpoCost = 0;
    temp2 = zeros(100,1);
    for k = 1:100 %for each city
        %temp = zeros(1, storageUnitNum); %store each distance to city for the 1's
        %ifUsed = 1;
        minDist = Inf;
        costContribution = 0;
        index = 1;
        %demand = 0;
        for j = 1:21 %through each binary element
            if StorageCombos(i,j) == 1 %if the unit is being used in that permutation
                if StorMarketChoice(k,j) < minDist %only one unit can serve each city
                    minDist = StorMarketChoice(k,j);
                    %costContribution = minDist * 1.2 * demand((*SUFu))
                    index = j; %the storage unit index
                end
                %temp(1,ifUsed) = StorMarketChoice(k,j);
                %ifUsed = ifUsed + 1; %store all the values in row. ifUsed <= storageUnitNum
            end
        end
        transpoCost = transpoCost + minDist*(ORADemandCities(k,1)+...
            POJDemandCities(k,1) + ROJDemandCities(k,1) + ...
            FCOJDemandCities(k,1))*1.2; 
        %market served by closest unit, and the contribution to the
        %transportation cost is the total demand fulfilled for each city
        
        temp2(k,1) = a(1,index); %the storage unit serving that city
    end
    
    %here we have candidate StorageCombos(i,:), with the distance of
    %transpoCost and StoragesServingCities of temp2
    
    tempBestStorageChoice = StorageCombos(i,:);
    tempStoragesServingCities = temp2;
    tempStoragesUsed = zeros(1,storageUnitNum);
    index = 1;
    for x = 1:21
        if (tempBestStorageChoice(1,x) == 1)
            tempStoragesUsed(1,index) = a(1,x);
            index = index+1;
        end
    end
    
    
    %the storage is not necessarily served by the closest processing plant,
    %but rather by the processing plant that minimizes total distance
    %traveled to the end market destination. Procs can serve multiple
    %storage units. This is for the storage unit(s) at iteration 'i'.
    
    %use bestStorageChoice = [0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0,0]; 
    %aka storage units 34, 51, 67 to debug
    
    %use StoragesServingCities for the 100x1 array of which cities are
    %served by which storage units. Proc --> storage is every product
    %except oranges

    
    demandProds = zeros(1,21);
    demandORA = zeros(1,21);
    for o = 1:21
        if tempBestStorageChoice(1,o) == 1 %if that storage unit is being used
            for k = 1:100 
                %look up which cities are being served by storage unit
                if tempStoragesServingCities(k,1) == a(1,o) 
                    
                    demandProds(1,o) = demandProds(1,o) +...
                        POJDemandCities(k,1) +...
                        ROJDemandCities(k,1) + FCOJDemandCities(k,1);
                    demandORA(1,o) = demandORA(1,o) + ORADemandCities(k,1);
                    %the demand for things that each storage unit is
                    %sending to
                end
            end
        end
    end
    
    %ProcStorChoice = xlsread(filename, sheetPSC, rangePSC); 
    %21x10 (Storage x Procs)[choice]
    %GroProcChoice = xlsread(filename, sheetGPSC, rangeGPC); %10x4 (Proc x Groves)
    %GroStorChoice = xlsread(filename, sheetGPSC, rangeGSC); %21x4 (Stor x Groves)
    procTranspo = 0;
    grovTranspo = 0;
    totalTranspo = Inf;
    procsUsed1 = zeros(1,procsNum);
    %grovsUsed1 = zeros(1,4);
    %grovsUsed = zeros(1,4);
    
    
    for p = 1:nchoosek(10,procsNum) %for each combo of processing plants
        procTranspo = 0;
        grovTranspo = 0;
        
        temp = 1;
        
        minProc = 1;
        
        %temp1 = 1;
        minGrovDist = Inf;
        %minGrov = 1;
        
        for q = 1:21
            if tempBestStorageChoice(1,q) == 1 %if storage unit being used
                minStorDist = Inf;
                for r = 1:10
                    if ProcsCombos(p,r) == 1 %if processing plant being used
                        if ProcStorChoice(q,r) < minStorDist
                            minProc = r;
                            minStorDist = ProcStorChoice(q,r);
                        end
                    end
                end
                %closest processing plant found to storage unit
                procTranspo = procTranspo + 1.2*minStorDist...
                    *demandProds(1,q);
                
%                 truth = 0;
%                 for h = 1:size(procsUsed1)
%                     if procsUsed1(1,h) == minProc
%                         truth = 1; %if the minProc is already in the array
%                     end
%                 end
%                 if truth == 0
%                     procsUsed1(1,temp) = minProc;
%                     temp = temp+1;
%                 end
                procsUsed1(1,temp) = minProc;
                temp = temp+1;
                
                
                
                 for s = 1:4
                     if GroStorChoice(q,s) < minGrovDist %from grove to storage
                         %minGrov = s;
                         minStorDist = GroStorChoice(q,s);
                     end
                 end
                 %closest grove to storage unit found
                 grovTranspo = grovTranspo + 0.22*minStorDist...
                     *demandORA(1,q);
%                 grovsUsed1(1,temp1) = minGrov;
%                 temp1 = temp1+1;
                
            end

        end
        
        
        if transpoCost + grovTranspo + procTranspo < minStorMarketDist
            bestStorageChoice = tempBestStorageChoice;
            storagesUsed = tempStoragesUsed;
            minStorMarketDist = transpoCost + procTranspo + grovTranspo;
            StoragesServingCities = tempStoragesServingCities;
            procsUsed = procsUsed1;
            bestProcChoice = ProcsCombos(p,:);
        end
        %if procTranspo + grovTranspo < totalTranspo
%         if procTranspo < totalTranspo
%             totalTranspo = procTranspo;
%             procsUsed = procsUsed1;
%             %grovsUsed = grovsUsed1;
%         end
    end
    
    
    
    
    
end
    

    
    
    
    
    
%%

% %%
% 
% totalCost = totalStorageCost + minStorMarketDist*1.2*aggregateDemand;
% 
% 
% 
%  b = zeros(1,storageUnitNum); 
%  index = 1;
%  for i = 1:21
%      if bestStorageChoice(1,i) == 1
%          b(1,index) = a(1,i);
%          index = index + 1;
%      end
%  end
%  %b has which storage unit(s) to use



 
             %ship the total demand to each storage unit from the closest
            %processing plant(s). Compare distance from processing plants
            %to the storage units, and have the closest one shipping the
            %product to the storage units. Thus each processing can ship to
            %multiple plants, but the storages in this simulation do not
            %receive from multiple processing plants. This works because
            %the storage units by definition are closest to the market.
            
            %calculate that transportation cost using tankers
            %(ignoring sunk costs of how many tanker cars to buy and
            %holding costs for now)
            
            %Then add in cost of going from groves to storage (orange
            %demand) and cost of going from groves to plants (tonnage of
            %total product sent out by that processing plant)
            
            
            
%             temp = zeros(1, procsNum);
%             ifUsed = 1;
%             for r = 1:10 %through each binary element
%                 if ProcsCombos(p,r) == 1 %The active plants.
%                     %Each plant can serve multiple storage units
%                     temp(1, ifUsed) = ProcStorChoice(q,r);
%                     ifUsed = ifUsed + 1;
%                 end
%             end
%             procTranspo = procTranspo + min(temp);
 