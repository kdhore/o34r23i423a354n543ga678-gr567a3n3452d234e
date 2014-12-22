classdef Decisions
    % This is the decision class.  The input to this class is all the
    % YearData objects as well as the OJGame object.  It then sets the
    % properties values of this class to the decisions. This can obviously
    % call other functions or have other inputs from other functions as
    % we deem fit. It can also take as input any sort of metrics and such
    % that we have calculated from any other function or class.
    
    properties
        % The decisions
        year;
        proc_plant_dec;
        tank_car_dec;
        storage_dec;
        purchase_spotmkt_dec;
        quant_mult_dec;
        future_mark_dec_ORA;
        future_mark_dec_FCOJ;
        arr_future_dec_ORA;
        arr_future_dec_FCOJ;
        ship_grove_dec;
        manufac_proc_plant_dec = zeros(2,10);
        futures_ship_dec = zeros(71,1);
        ship_proc_plant_storage_dec = struct([]);
        reconst_storage_dec = zeros(71,12);
        pricing_ORA_dec;
        pricing_POJ_dec;
        pricing_FCOJ_dec;
        pricing_ROJ_dec;
        
    end
    
    methods
        % Constructor where you update each of the properties of the
        % decision in the Decision file inputted
        function decision = Decisions(filename,OJ_object,pricesORA,...
                pricesPOJ, pricesROJ, pricesFCOJ, YearDataRecord, filename2)

            % For now this needs to be MANUALLY updated
            % Load the year data objects
            
            plants_open = find(OJ_object.proc_plant_cap);
            stor_open = find(OJ_object.storage_cap);
                
            %prices inputted 7(regions) by 12(months)                              
            decision.pricing_ORA_dec = pricesORA;
            decision.pricing_FCOJ_dec = pricesFCOJ;
            decision.pricing_ROJ_dec = pricesROJ;
            decision.pricing_POJ_dec = pricesPOJ;


            storage2market = load('Distance Data/storage2market_dist.mat');
            s2m = genvarname('storage2market_dist');
            storage2market_dist = cell2mat(storage2market.(s2m));
            demand_city_ORA = load('Demand Data/demand_city_ORA.mat');
            dc_ora = genvarname('ORA_means_by_city');
            demand_city_ORA = demand_city_ORA.(dc_ora);
            demand_city_POJ = load('Demand Data/demand_city_POJ.mat');
            dc_poj = genvarname('POJ_means_by_city');
            demand_city_POJ = demand_city_POJ.(dc_poj);
            demand_city_ROJ = load('Demand Data/demand_city_ROJ.mat');
            dc_roj = genvarname('ROJ_means_by_city');
            demand_city_ROJ = demand_city_ROJ.(dc_roj);
            demand_city_FCOJ = load('Demand Data/demand_city_FCOJ.mat');
            dc_fcoj = genvarname('FCOJ_means_by_city');
            demand_city_FCOJ = demand_city_FCOJ.(dc_fcoj);

            ORA_demand = zeros(length(stor_open),12);
            POJ_demand = zeros(length(stor_open),12);
            FCOJ_demand = zeros(length(stor_open),12);
            ROJ_demand = zeros(length(stor_open),12);
            cities_match_storage = matchCitiestoStorage(stor_open, storage2market.(s2m));
            decisions = YearDataforDecisions('Decisions/oriangagrande2017_305m.xlsm', OJ_object);
            for i = 1:12
                for j = 1:length(stor_open)
                    indicies = strcmp(char(storageNamesInUse(stor_open(j))),cities_match_storage(:,2));
                    cities = cities_match_storage(indicies,:);
                    [ORA_demand(j,i), POJ_demand(j,i), FCOJ_demand(j,i), ROJ_demand(j,i), ~, ~] = drawDemand(decisions,cities,4*(i-1)+1, demand_city_ORA, demand_city_POJ, demand_city_ROJ, demand_city_FCOJ, pricesORA, pricesPOJ, pricesROJ, pricesFCOJ);
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Create raw_materials tab (multipliers and futures)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %  Set the multipliers equal to matrix
            %  where each row is grove location (FLA, CAL, TEX, ARZ,
            %  BRA, SPA respectively) and each column alternates
            %  between being the "multiplier value" and the "price"
            
            %(phil commentary 12/21) currently, policy reads as: 
            %each price boundary = mean grove price + param*std(price)
            %multipliers themselves are manually set.
            %This seems fine on surface -- a measure of how many standard
            %deviations from the historical mean we're willing to tolerate.
            %Stress-test above.
            
            %Consider (for multipliers) how much more the facilities can
            %take. We should never buy more than our facilities can have
            %even in a best-case scenario (e.g. if the price drops
            %super-low from a certain grove).
            
            decision.quant_mult_dec = zeros(6,6);
            mean_grove_prices = zeros(6,1);
            stdev_grove_prices = zeros(6,1);

            for j = 1:6
                for i = 1:length(YearDataRecord)
                    mean_grove_prices(j) = mean_grove_prices(j) + ...
                        mean(YearDataRecord(i).us_price_spot_res(j,:));
                    stdev_grove_prices(j) = stdev_grove_prices(j) + ...
                        var(YearDataRecord(i).us_price_spot_res(j,:));
                end
                mean_grove_prices(j) = mean_grove_prices(j)...
                    /length(YearDataRecord);
                stdev_grove_prices(j) = sqrt(stdev_grove_prices(j)...
                    /length(YearDataRecord));
            end

            % These are the parameters to determine the price
            % boundaries
            phi1 = -1;
            phi2 = 1;
            phi3 = 3;

            for i = 1:6
                decision.quant_mult_dec(i,2) = mean_grove_prices(i)+...
                    phi1*stdev_grove_prices(i);
                decision.quant_mult_dec(i,4) = mean_grove_prices(i)+...
                    phi2*stdev_grove_prices(i);
                decision.quant_mult_dec(i,6) = mean_grove_prices(i)+...
                    phi3*stdev_grove_prices(i);
            end

            % Set multipler values (for now manually set - could be tuned)
            for i = 1:6
                decision.quant_mult_dec(i,1) = 1.2;
                decision.quant_mult_dec(i,3) = 1;
                decision.quant_mult_dec(i,5) = 0.8;
            end

            %  Set the amount (in tons) of ORA futures to
            %  purchase in each year from the year after the current to
            %  5 years after the current
%                 theta1 = [0.90,0.85,0.81,0.78,0.76, 1.1];
            theta1 = 0.76;
            theta2 = 1;

            cumDemand = 0;
            for i = 1:7 %iterate over all regions
                averagePrice = mean(decision.pricing_ORA_dec(i,:));
                cumDemand = cumDemand + getDemand(1,i,averagePrice);
            end
            %cumDemand is the total demand for all regions for ORA over
            %months

            %Find number of futures until this year
            %Total Futures maturing in decision year + 1
            FuturesMaturing1 = 0;
            for i = 1:4
                FuturesMaturing1 = FuturesMaturing1 + ...
                    OJ_object.ora_futures_current1(1,2*i);
            end

            %Total Futures maturing in decision year + 2
            FuturesMaturing2 = 0;
            for i = 1:3
                FuturesMaturing2 = FuturesMaturing2 + ...
                    OJ_object.ora_futures_current2(1,2*i);
            end

            %Total Futures maturing in decision year + 3
            FuturesMaturing3 = 0;
            for i = 1:2
                FuturesMaturing3 = FuturesMaturing3 + ...
                    OJ_object.ora_futures_current3(1,2*i);
            end

            %Total Futures maturing in decision year + 4
            FuturesMaturing4 = 0;
            FuturesMaturing4 = FuturesMaturing4 + ...
                OJ_object.ora_futures_current4(1,2);

            % Current decision year is first chance to buy for year 5
            FuturesMaturing5 = 0;

            FuturesMaturing = [FuturesMaturing1, FuturesMaturing2,...
                FuturesMaturing3, FuturesMaturing4, FuturesMaturing5];


            [~, ~, decision.future_mark_dec_ORA] = xlsread(filename,'raw_materials','N31:O35');
            decision.future_mark_dec_ORA = cell2mat(cellNaNReplace(decision.future_mark_dec_ORA,0));

            for i = 1:5

                if decision.future_mark_dec_ORA(i,1) < theta2
                    decision.future_mark_dec_ORA(i,2) = max(theta1*(cumDemand - FuturesMaturing(1,i)),0);

                else
                    decision.future_mark_dec_ORA(i,2) = 0;

                end
            end


            %  Set the amount (in tons) of FCOJ futures to
            %  purchase in each year from the year after the current to
            %  5 years after the current

%                 theta3 = [1.05,1.00,0.96,0.93,0.91];
            theta3 = 18;
            theta4 = 1;

            cumDemandFCOJ = 0;
            for i = 1:7 %iterate over all regions
                averagePrice = mean(decision.pricing_FCOJ_dec(i,:));
                cumDemandFCOJ = cumDemandFCOJ + getDemand(4,i,averagePrice);
            end
            %cumDemand is the total demand for all regions for ORA over
            %months

            %Find number of futures until this year
            %Total Futures maturing in decision year + 1
            FCOJFuturesMaturing1 = 0;
            for i = 1:4
                FCOJFuturesMaturing1 = FCOJFuturesMaturing1 + ...
                    OJ_object.fcoj_futures_current1(1,2*i);
            end

            %Total Futures maturing in decision year + 2
            FCOJFuturesMaturing2 = 0;
            for i = 1:3
                FCOJFuturesMaturing2 = FCOJFuturesMaturing2 + ...
                    OJ_object.fcoj_futures_current2(1,2*i);
            end

            %Total Futures maturing in decision year + 3
            FCOJFuturesMaturing3 = 0;
            for i = 1:2
                FCOJFuturesMaturing3 = FCOJFuturesMaturing3 + ...
                    OJ_object.fcoj_futures_current3(1,2*i);
            end

            %Total Futures maturing in decision year + 4
            FCOJFuturesMaturing4 = 0;
            FCOJFuturesMaturing4 = FCOJFuturesMaturing4 + ...
                OJ_object.fcoj_futures_current4(1,2);

            % Current decision year is first chance to buy for year 5
            FCOJFuturesMaturing5 = 0;

            FCOJFuturesMaturing = [FCOJFuturesMaturing1, FCOJFuturesMaturing2,...
                FCOJFuturesMaturing3, FCOJFuturesMaturing4, FCOJFuturesMaturing5];


            [~, ~, decision.future_mark_dec_FCOJ] = xlsread(filename,'raw_materials','N37:O41');
            decision.future_mark_dec_FCOJ = cell2mat(cellNaNReplace(decision.future_mark_dec_FCOJ,0));

            for i = 1:5

                if decision.future_mark_dec_FCOJ(i,1) < theta4
                    decision.future_mark_dec_FCOJ(i,2) = theta3*max((cumDemandFCOJ - FCOJFuturesMaturing(1,i)),0);

                else
                    decision.future_mark_dec_FCOJ(i,2) = 0;

                end
            end


            % Set the percent of futures of ORA or FCOJ
            % to arrive in month Sep-Aug
            decision.arr_future_dec_ORA = zeros(1, 12);
            monthlyDemandORA = zeros(1,12);

            for i = 1:12
                monthlyDemandORA(1, i) = 4*sum(ORA_demand(:,i));
            end

            for i = 1:12
                decision.arr_future_dec_ORA(1, i) = 100*monthlyDemandORA(1, i)/...
                    sum(monthlyDemandORA(1, :));
            end

            decision.arr_future_dec_FCOJ = zeros(1, 12);
            monthlyDemandFCOJ = zeros(1,12);

            for i = 1:12
                monthlyDemandFCOJ(1, i) = 4*sum(FCOJ_demand(:,i));
            end

            for i = 1:12
                decision.arr_future_dec_FCOJ(1, i) = 100*monthlyDemandFCOJ(1, i)/...
                    sum(monthlyDemandFCOJ(1, :));
            end

            futuresmaturing = zeros(2,1);
            [~, ~, futuresmaturing_temp] = xlsread(filename,'raw_materials','P30');
            futuresmaturing(1) = cell2mat(cellNaNReplace(futuresmaturing_temp,0));
            [~, ~, futuresmaturing_temp] = xlsread(filename,'raw_materials','P36');
            futuresmaturing(2) = cell2mat(cellNaNReplace(futuresmaturing_temp,0));
            
            % Decide how many FCOJ futures to ship to each storage unit
            CumDemandoverStorageFCOJ = 0;

            for i = 1:length(stor_open)
                CumDemandoverStorageFCOJ = CumDemandoverStorageFCOJ + ...
                    sum(FCOJ_demand(i, :));
            end

            for j = 1:length(stor_open)
                decision.futures_ship_dec(stor_open(j),1)...
                    =100*sum(FCOJ_demand(j, :))/...
                    CumDemandoverStorageFCOJ;
            end
            
            futures_arr_ORA = futuresmaturing(1)*decision.arr_future_dec_ORA(1)/100/4;
            futures_arr_FCOJ = futuresmaturing(2)*decision.arr_future_dec_FCOJ(1)/100/4*decisions.futures_ship_dec(stor_open)/100;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Get shipping decisions (linear program)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            bytank = zeros(length(plants_open),length(stor_open));
            bycarrier = zeros(length(plants_open),length(stor_open));
            costbytank = zeros(length(plants_open),length(stor_open));
            costbycarrier = zeros(length(plants_open),length(stor_open));
            plant2storage_avgcost = zeros(length(plants_open),length(stor_open));
            for i = 1:length(plants_open)
                for j = 1:length(stor_open)
                    shtname = char(plantNamesInUse(plants_open(i)));
                    start = 36 + 11*(j-1);
                    [~, ~, bytank_temp] = xlsread(filename2,shtname,strcat('D',num2str(start),':AY',num2str(start+1)));
                    bytank_temp = cell2mat(cellNaNReplace(bytank_temp,0));
                    bytank(i,j) = sum(sum(bytank_temp));
                    start = 39 + 11*(j-1);
                    [~, ~, bycarrier_temp] = xlsread(filename2,shtname,strcat('D',num2str(start),':AY',num2str(start+1)));
                    bycarrier_temp = cell2mat(cellNaNReplace(bycarrier_temp,0));
                    bycarrier(i,j) = sum(sum(bycarrier_temp));
                    start = 42 + 11*(j-1);
                    [~, ~, costbytank_temp] = xlsread(filename2,shtname,strcat('AZ',num2str(start)));
                    costbytank(i,j) = cell2mat(cellNaNReplace(costbytank_temp,0));
                    start = 43 + 11*(j-1);
                    [~, ~, costbycarrier_temp] = xlsread(filename2,shtname,strcat('AZ',num2str(start)));
                    costbycarrier(i,j) = cell2mat(cellNaNReplace(costbycarrier_temp,0));
                    if (bytank(i,j) == 0)
                        unittankcost = 0;
                    else
                        unittankcost = costbytank(i,j)/bytank(i,j);
                    end
                    if (bycarrier(i,j) == 0)
                        unitcarriercost = 0;
                    else
                        unitcarriercost = costbycarrier(i,j)/bycarrier(i,j);
                    end
                    if (bytank(i,j) + bycarrier(i,j) == 0)
                        plant2storage_avgcost(i,j) = 0;
                    else
                        plant2storage_avgcost(i,j) = unittankcost*bytank(i,j)/(bytank(i,j)+bycarrier(i,j))...
                            + unitcarriercost*bycarrier(i,j)/(bytank(i,j)+bycarrier(i,j));
                    end
                end
            end
            %plant2storage_avgcost = [867.75	1517.1	466.7;
            %    877.3	92.83	2658.266855;
            %    866.047104	1693.640179	349.338538];

            [x, fval, purchase, percentpoj, percentroj, ship_from_grove, ship_from_plants] = linearProgram(OJ_object, plant2storage_avgcost, YearDataRecord, ORA_demand, POJ_demand, ROJ_demand, FCOJ_demand, futures_arr_ORA, futures_arr_FCOJ);

            decision.reconst_storage_dec = percentroj;
            decision.manufac_proc_plant_dec = percentpoj;
            decision.ship_grove_dec = ship_from_grove;
            decision.purchase_spotmkt_dec = purchase;

            % POJ and FCOJ to storage decisions
            ship_break = struct('POJ', nan, 'FCOJ', nan);
            decision.ship_proc_plant_storage_dec = ship_break;
            for i=1:71
                for j =1:10
                    decision.ship_proc_plant_storage_dec(i,j) = ship_break;
                end
            end
            
            for i = 1:length(stor_open)
                for j = 1:length(plants_open)
                    decision.ship_proc_plant_storage_dec(stor_open(i),plants_open(j)).FCOJ = ...
                        ship_from_plants(i,2*(j-1)+1);
                    decision.ship_proc_plant_storage_dec(stor_open(i),plants_open(j)).POJ = ...
                        ship_from_plants(i,2*(j-1)+2);
                    
                     if decision.ship_proc_plant_storage_dec(stor_open(i),...
                            plants_open(j)).POJ < 0.0000001
                        decision.ship_proc_plant_storage_dec(stor_open(i),...
                            plants_open(j)).POJ = 0;
                    end

                    if decision.ship_proc_plant_storage_dec(stor_open(i),...
                            plants_open(j)).FCOJ < 0.0000001
                        decision.ship_proc_plant_storage_dec(stor_open(i),...
                            plants_open(j)).FCOJ = 0;
                    end
                end
            end



            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Assigning decisions to the facilities tab
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % For processing plants, the decision is the capacity to
            % buy/sell in each plant: [P01;P02;...;P10]
            
            %(phil commentary 12/21) 
            %the below policies are too complicated. Should find optimal
            %facilities and stick with those for the most part, usually
            %only adjusting capacities. The only reason to change
            %facilities really is for price changes, but historically there
            %haven't been any insane trends from one place to another.
            %maybe do price tracking for the groves -- if over x (this can
            %be a parameter) number of years the prices for one grove are
            %statistically significantly lower than other groves' prices,
            %consider changing facilities to suit.
            
            
            
            %Add a certain processing plant if:
            %capacity sold + transportation savings > price of new
            %plant + price of upgrading capacity + cost of tossing out
            %current product

            %Add capacity if:
            %capacity add cost + transportation add cost < total
            %revenue gain + opp. cost of product tossed out
            %(include parameters to set for certain # of years)

            %Reduce capacity if:
            %excess capacity not being used, and there is no projected
            %increase in demand or delivery
            decision.proc_plant_dec = zeros(10,1);% enter matrix manually here

            %                 rho1 = 1.01; %parameter > 1 for buffer of processing plant
            %                 for i = 1:length(plants_open)
            %                     decision.proc_plant_dec(plants_open(i),1) = ...
            %                         rho1*mean(decision.demandProcPlantORA(i,:))/4 - ...
            %                         OJ_object.proc_plant_cap(plants_open(i),1);
            %                     %can be positive or negative number
            %                 end



            % For tank car, the decision is #. of tank cars to buy/sell
            % at each proc. plant: [P01;P02;...;P10]
            decision.tank_car_dec = zeros(10,1); % enter matrix manually here

            %                 rho2 = 0.5;
            %                 %number of tank cars as a percentage for transport between
            %                 %processing plant and storage unit is parameterized by
            %                 %rho2
            %                 rho3 = 0.75; %percentage of max to use
            %                 for i = 1:length(plants_open)
            %                     decision.tank_car_dec(plants_open(i),1) = ...
            %                         rho2*rho3*mean(decision.demandProcPlantORA(i,:))/4 - ...
            %                         OJ_object.tank_cars_num(plants_open(i),1);
            %                 end
            %


            % For storage, the decision is the capacity to buy/sell
            % capacity at each of the storage units
            decision.storage_dec = zeros(71,1);
            % Manually define the storage units in use to have some
            % capacity to buy/sell. For example, for index i:
            % yr.storage_dec(i) = capacity;
            %                 decision.storage_dec(4,1) = -31000;
            %                 decision.storage_dec(stor_open(3),1) = -20000;

            %Add a storage unit if:
            %capacity sold + transportation savings > price of new
            %plant + price of upgrading capacity + cost of tossing out
            %current product

            %For capacity, always want some buffer between the
            %projected demand and above because we don't want
            %additional (unforseen) factors to throw out a lot of our
            %product

            %                 rho4 = 1.01; %parameter > 1 for buffer space of storage unit
            %                 for i = 1:length(stor_open)
            %                     decision.storage_dec(stor_open(i),1) = ...
            %                         rho4*(mean(decision.demandStorageORA(i,:))/4 + ...
            %                         mean(decision.demandStoragePOJ(i,:))/4 + ...
            %                         mean(decision.demandStorageROJ(i,:))/4 + ...
            %                         mean(decision.demandStorageFCOJ(i,:))/4) - ...
            %                         OJ_object.storage_cap(stor_open(i),1);
            %                     %can be positive or negative number
            %                 end
            %

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Code to be written to write these updates decisions in %
            % to Excel decision file                                 %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        end
        
    end
end
