classdef Decisions
    % This is the decision class.  The input to this class is all the
    % YearData objects as well as the OJGame object.  It then sets the
    % properties values of this class to the decisions. This can obviously
    % call other functions or have other inputs from other functions as
    % we deem fit. It can also take as input any sort of metrics and such
    % that we have calculated from any other function or class. karthik
    
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
        pricing_ORA_weekly_dec;
        pricing_POJ_dec;
        pricing_POJ_weekly_dec;
        pricing_FCOJ_dec;
        pricing_FCOJ_weekly_dec;
        pricing_ROJ_dec;
        pricing_ROJ_weekly_dec;
    end
    
    methods
        % Constructor where you update each of the properties of the
        % decision in the Decision file inputted
        function Decisions = Decision(filename,OJ_object)
            if nargin > 0
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in pricing tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Manually enter the market price for each product where
                % each row is a region (NE, MA, SE, MW, DS, NW, SW) and the
                % columns are months Sep-Aug
                Decisions.pricing_ORA_dec = zeros(7,12);
                Decisions.pricing_POJ_dec = zeros(7, 12);
                Decisions.pricing_ROJ_dec = zeros(7, 12);
                Decisions.pricing_FCOJ_dec = zeros(7, 12);
                
                % Set the prices of each product either manually or by
                % looping through the regions and the months
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Assigning decisions to the facilities tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % For processing plants, the decision is the capacity to
                % buy/sell in each plant: [P01;P02;P03;P04;P05;P06;P07]
                yr.proc_plant_dec = % enter matrix manually here
                
                % For tank car, the decision is #. of tank cars to buy/sell
                % at each proc. plant: [P01;P02;P03;P04;P05;P06;P07]
                yr.tank_car_dec = % enter matrix manually here
                
                % For storage, the decision is the capacity to buy/sell
                % capacity at each of the storage units
                Decisions.storage_dec = zeros(71,1);
                % Manually define the storage units in use to have some
                % capacity to buy/sell. For example, for index i:
                % yr.storage_dec(i) = capacity;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in shipping_manufacturing tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Manually set the percent of ORA to ship from groves to
                % either processing or storage plants. Each row is one of
                % the grove locations (FLA, CAL, TEX, ARZ,
                %  BRA, SPA) and the columns represent each processing plan
                %  and each storage unit that is currently open
                % Find the storage and processing plants currently open
                % from the OJ object.
                plants_open = find(OJ_object.proc_plant_cap);
                stor_open = find(OJ_object.storage_cap);
                Decisions.ship_grove_dec = zeros(6, length(plants_open) + length(stor_open));
                % Set these percentages manually %
                
                % Manually set the % of FCOJ to reconstitute to ROJ at each
                % storage unit each month where each row is an open storage
                % unit and each column is a month from Sep-Aug
                Decisions.reconst_storage_dec = zeros(length(stor_open), 12);
                % Set the percentages for each of these cells %
                
                % Manually enter the futures shipping to storage decisions
                Decisions.futures_ship_dec(% for each storage unit in stor_open) =
                % enter the percent to ship to each storage
                
                % Manually enter the shipping POJ and FCOJ to storage
                % decisions
                ship_break = struct('POJ', nan, 'FCOJ', nan);
                Decisions.ship_proc_plant_storage_dec = ship_break;
                for (i=1:71)
                    for(j =1:10)
                        Decisions.ship_proc_plant_storage_dec(i,j) = ship_break;
                    end
                end
                
                % For stor_fac = each storage unit in stor_open
                % For proc_plant = each processing plant in plants_open
                % yr.ship_proc_plant_storage_dec(% for each stor_fac,% for each proc_plant).POJ = % enter the percent to ship to each storage
                % yr.ship_proc_plant_storage_dec(% for each stor_fac,% for each proc_plant).FCOJ = % enter the percent to ship to each storage
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in raw_materials tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  Manually set the spot market prices equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column is a month of the
                %  year starting in September
                Decisions.purchase_spotmkt_dec = zeros(6,12);
                % assign the buying quantity (tons per week in a month)
                % either manually or by looping through locations/months
                
                Decisions.demandStorage = zeros(length(stor_open),1);
                for i = 1:length(stor_open)
                    
                
                
                
                %  Manually set the multipliers equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column alternates
                %  between being the "multiplier value" and the "price"
                Decisions.quant_mult_dec = zeros(6,6);
                
                % If i = geographic location
                % Set price values
                % yr.quant_mult_dec(i,2) = % price 1
                % yr.quant_mult_dec(i,4) = % price 2
                % yr.quant_mult_dec(i,6) = % price 3
                
                
                
                % Set multipler values
                % yr.quant_mult_dec(i,1) = % multipler if price < price 1
                % yr.quant_mult_dec(i,3) = % multipler if price 1 < price < price 2
                % yr.quant_mult_dec(i,5) = % multipler if price 2 < price < price 3
                % Repeat for all locations i = FLA, CAL, TEX, ARZ,
                %  BRA, SPA
                
                
                
                %  Set the amount (in tons) of ORA futures to
                %  purchase in each year from the year after the current to
                %  5 years after the current
                theta1 = 0;
                theta2 = 0;
                
                cumDemand = 0;
                for i = 1:7 %iterate over all regions
                    averagePrice = mean(Decisions.pricing_ORA_dec(i,:));
                    cumDemand = cumDemand + getDemand(1,i,averagePrice);
                end
                %cumDemand is the total demand for all regions for ORA over
                %months
                
                %Find number of futures until this year
                %Total Futures maturing in decision year + 1
                FuturesMaturing1 = 0;
                for i = 1:4
                    FuturesMaturing1 = FuturesMaturing1 + ...
                        ora_futures_current1(1,2*i);
                end
                
                 %Total Futures maturing in decision year + 2
                FuturesMaturing2 = 0;
                for i = 1:3
                    FuturesMaturing2 = FuturesMaturing2 + ...
                        ora_futures_current2(1,2*i);
                end
                
                %Total Futures maturing in decision year + 3
                FuturesMaturing3 = 0;
                for i = 1:2
                    FuturesMaturing3 = FuturesMaturing3 + ...
                        ora_futures_current3(1,2*i);
                end
                
                %Total Futures maturing in decision year + 4
                FuturesMaturing4 = 0;
                FuturesMaturing4 = FuturesMaturing4 + ...
                    ora_futures_current4(1,2);
                
                % Current decision year is first chance to buy for year 5
                FuturesMaturing5 = 0
               
                FuturesMaturing = [FuturesMaturing1, FuturesMaturing2,...
                    FuturesMaturing3, FuturesMaturing4, FuturesMaturing5];
                
            
                [~, ~, Decisions.future_mark_dec_ORA] = xlsread(filename,'raw_materials','N31:O35');
                Decisions.future_mark_dec_ORA = cell2mat(cellNaNReplace(Decisions.future_mark_dec_ORA,0));
               
                for i = 1:5
                    
                    if Decisions.future_mark_dec_ORA(i,1) < theta2
                    Decisions.future_mark_dec_ORA(i,2) = theta1*(cumDemand - FuturesMaturing(1,i));
                    
                    else 
                    Decisions.future_mark_dec_ORA(i,2) = 0;
                    
                    end
                end
        
              
                %  Set the amount (in tons) of FCOJ futures to
                %  purchase in each year from the year after the current to
                %  5 years after the current
                
                theta3 = 0;
                theta4 = 0;
                
                cumDemandFCOJ = 0;
                for i = 1:7 %iterate over all regions
                    averagePrice = mean(Decisions.pricing_FCOJ_dec(i,:));
                    cumDemandFCOJ = cumDemandFCOJ + getDemand(4,i,averagePrice);
                end
                %cumDemand is the total demand for all regions for ORA over
                %months
                
                %Find number of futures until this year
                %Total Futures maturing in decision year + 1
                FCOJFuturesMaturing1 = 0;
                for i = 1:4
                    FCOJFuturesMaturing1 = FCOJFuturesMaturing1 + ...
                    fcoj_futures_current1(1,2*i);
                end
                
                 %Total Futures maturing in decision year + 2
                FCOJFuturesMaturing2 = 0;
                for i = 1:3
                    FCOJFuturesMaturing2 = FCOJFuturesMaturing2 + ...
                    fcoj_futures_current2(1,2*i);
                end
                
                %Total Futures maturing in decision year + 3
                FCOJFuturesMaturing3 = 0;
                for i = 1:2
                    FCOJFuturesMaturing3 = FCOJFuturesMaturing3 + ...
                    fcoj_futures_current3(1,2*i);
                end
                
                %Total Futures maturing in decision year + 4
                FCOJFuturesMaturing4 = 0;
                FCOJFuturesMaturing4 = FCOJFuturesMaturing4 + ...
                    fcoj_futures_current4(1,2);
                
                % Current decision year is first chance to buy for year 5
                FCOJFuturesMaturing5 = 0
               
                FCOJFuturesMaturing = [FCOJFuturesMaturing1, FCOJFuturesMaturing2,...
                    FCOJFuturesMaturing3, FCOJFuturesMaturing4, FCOJFuturesMaturing5];
                
            
                [~, ~, Decisions.future_mark_dec_FCOJ] = xlsread(filename,'raw_materials','N37:O41');
                Decisions.future_mark_dec_FCOJ = cell2mat(cellNaNReplace(Decisions.future_mark_dec_FCOJ,0));
               
                for i = 1:5
                    
                    if Decisions.future_mark_dec_FCOJ(i,1) < theta4
                    Decisions.future_mark_dec_FCOJ(i,2) = theta3*(cumDemandFCOJ - FCOJFuturesMaturing(1,i));
                    
                    else 
                    Decisions.future_mark_dec_FCOJ(i,2) = 0;
                    
                    end
                end
        
                % Set the value of year you want to buy futures for
                
                % Manually set the percent of futures of ORA or FCOJ
                % to arrive in month Sep-Aug
                Decisions.arr_future_dec_ORA = zeros(1, 12);
                Decisions.arr_future_dec_FCOJ = zeros(1, 12);
                % Set each month you want delivery of futures to some
                % percent
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                

                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Code to be written to write these updates decisions in %
                % to Excel decision file                                 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            end
            
        end
        
    end
end
