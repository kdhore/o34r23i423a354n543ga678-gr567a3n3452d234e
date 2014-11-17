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
        function filename = Decision(filename,OJ_object)
            if nargin > 0
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
                yr.storage_dec = zeros(71,1);
                % Manually define the storage units in use to have some 
                % capacity to buy/sell. For example, for index i:
                % yr.storage_dec(i) = capacity;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in raw_materials tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  Manually set the spot market prices equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column is a month of the
                %  year starting in September
                yr.purchase_spotmkt_dec = zeros(6,12);
                % assign the buying quantity (tons per week in a month)
                % either manually or by looping through locations/months
                
                %  Manually set the multipliers equal to matrix
                %  where each row is grove location (FLA, CAL, TEX, ARZ,
                %  BRA, SPA respectively) and each column alternates 
                %  between being the "multiplier value" and the "price"
                yr.quant_mult_dec = zeros(6,6);
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
                
                %  Manually set the amount (in tons) of ORA futures to 
                %  purchase in each year from the year after the current to 
                %  5 years after the current
                yr.future_mark_dec_ORA =  zeros(5,1);
                % Set the value of year you want to buy futures for
                
                %  Manually set the amount (in tons) of FCOJ futures to 
                %  purchase in each year from the year after the current to 
                %  5 years after the current
                yr.future_mark_dec_FCOJ = zeros(5,1);
                % Set the value of year you want to buy futures for

                % Manually set the percent of futures of ORA or FCOJ 
                % to arrive in month Sep-Aug
                yr.arr_future_dec_ORA = zeros(1, 12);
                yr.arr_future_dec_FCOJ = zeros(1, 12);
                % Set each month you want delivery of futures to some
                % percent
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
                yr.ship_grove_dec = zeros(6, length(plants_open) + length(stor_open)); 
                % Set these percentages manually %

                % Manually set the % of FCOJ to reconstitute to ROJ at each
                % storage unit each month where each row is an open storage
                % unit and each column is a month from Sep-Aug
                yr.reconst_storage_dec = zeros(stor_open, 12);
                % Set the percentages for each of these cells %
            
                % Manually enter the futures shipping to storage decisions 
                yr.futures_ship_dec(% for each storage unit in stor_open) = 
                % enter the percent to ship to each storage
                
                % Manually enter the shipping POJ and FCOJ to storage
                % decisions
                ship_break = struct('POJ', nan, 'FCOJ', nan);
                yr.ship_proc_plant_storage_dec = ship_break;
                for (i=1:71)
                    for(j =1:10)
                        yr.ship_proc_plant_storage_dec(i,j) = ship_break;
                    end
                end
                
                % For stor_fac = each storage unit in stor_open
                % For proc_plant = each processing plant in plants_open
                % yr.ship_proc_plant_storage_dec(% for each stor_fac,% for each proc_plant).POJ = % enter the percent to ship to each storage
                % yr.ship_proc_plant_storage_dec(% for each stor_fac,% for each proc_plant).FCOJ = % enter the percent to ship to each storage
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in pricing tab
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Manually enter the market price for each product where
                % each row is a region (NE, MA, SE, MW, DS, NW, SW) and the
                % columns are months Sep-Aug
                yr.pricing_ORA_dec = zeros(7,12);
                yr.pricing_POJ_dec = zeros(7, 12);
                yr.pricing_ROJ_dec = zeros(7, 12);
                yr.pricing_FCOJ_dec = zeros(7, 12);
                
                % Set the prices of each product either manually or by
                % looping through the regions and the months
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Code to be written to write these updates decisions in %
                % to Excel decision file                                 %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
    end
    
end

