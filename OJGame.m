classdef OJGame 
    % This class holds all the information of the current state of our
    % orange juice game.
    %   The purpose of this class is to contain information about:
    %     Remaining inventory from previous year in
    %       1. Processing Plants
    %       2. Storage 
    %     Which facilities are active
    %       1. Processing Plants
    %       2. Storage 
    %       3. Tank Cars - how do these work?
    %     Futures: Keep track of which futures are arriving when
    %     Also need to standardize abbreviations
    
    properties
        % All these values are equal to the values before the 2004 run.
        % 2004 is the genesis year. The constructor simply updates them.
        year_start;
        % inventory in each of the processing plants
        proc_plant_inv = struct([]);
        % inventory in each of the storage locations
        
        storage_inv = struct([]);    
        % capacity at each of the processing plants
        proc_plant_cap = zeros(10,1);
                
        % capacity at each of the storage locations
        storage_cap = zeros(71,1);
        
        % Number of tank cars? and Where they are?
        tank_cars_num = zeros(10,1);
        
        % Two arrays for future deliveries (one for ORA and one for FCOJ)
        %   - how much is arriving in the next four years
        futures_years;
        ora_futures;
        fcoj_futures;
        
    end
    
    methods
        % Constructor to set all the values to the initial 2004 genesis run
        function oj = OJGame()
            oj.year_start = 2004;
            oj.proc_plant_cap(1) = 2043;
            oj.proc_plant_cap(5) = 2454;
            oj.proc_plant_cap(7) = 5273;
            oj.tank_cars_num(1) = 61; 
            oj.tank_cars_num(5) = 91;
            oj.tank_cars_num(7) = 155;
            oj.storage_cap(4) = 40000;
            oj.storage_cap(41) = 43000;
            test_1 = struct('ORA', nan);
            oj.proc_plant_inv = test_1;
            for (i=2:10)
                oj.proc_plant_inv(i) = test_1;
            end
            test = struct('ORA', nan, 'POJ', nan, 'FCOJ', nan, 'ROJ', nan);
            oj.storage_inv = test;
            for (i=2:71)
                oj.storage_inv(i) = test;
            end
            oj.storage_inv(4).ORA = zeros(4,1);
            oj.storage_inv(4).POJ = zeros(8,1);
            oj.storage_inv(4).FCOJ = zeros(12,1);
            oj.storage_inv(4).ROJ = zeros(48,1);

            oj.storage_inv(4).ORA = zeros(4,1);
            oj.storage_inv(4).POJ = zeros(8,1);
            oj.storage_inv(4).FCOJ = zeros(12,1);
            oj.storage_inv(4).ROJ = zeros(48,1);
            
            oj.ora_futures = [200000; 200000; 0; 0; 0];
            oj.fcoj_futures = [0; 500000; 0; 0; 0];
            oj.futures_years = [2004; 2005; 2006; 2007; 2008];
            
        end
        
        % Function to update all the values of the properties. The input 
        % is an instance of the YearData class
        function obj = update(obj,YearData)
            obj.year_start = YearData.year + 1;
            plants_open = find(obj.proc_plant_cap);
            for (i=1:length(plants_open))
                plant_name = char(plantNamesInUse(plants_open(i)));
                inventory = YearData.proc_plant_res(plant_name).ORA_Inventory;
                obj.proc_plant_inv(plants_open(i)).ORA = inventory(1:4, 49);
            end
            stor_open = find(obj.storage_cap);
            for (i=1:length(stor_open))
                stor_name = char(storageNamesInUse(stor_open(i)));
                inventory_ora = YearData.storage_res(stor_name).ORA_Inv;
                obj.storage_inv(stor_open(i)).ORA = inventory_ora(1:4,49);
                inventory_poj = YearData.storage_res(stor_name).POJ_Inv;
                obj.storage_inv(stor_open(i)).POJ = inventory_poj(1:8,49);
                inventory_fcoj = YearData.storage_res(stor_name).FCOJ_Inv;
                obj.storage_inv(stor_open(i)).FCOJ = inventory_fcoj(1:48,49);
                inventory_roj = YearData.storage_res(stor_name).ROJ_Inv;
                obj.storage_inv(stor_open(i)).ROJ = inventory_roj(1:12,49);
            end
            obj.futures_years = obj.futures_years + 1;
            obj.ora_futures(1:4) = obj.ora_futures(2:5);
            obj.fcoj_futures(1:4) = obj.fcoj_futures(2:5);
            obj.ora_futures(5) = 0; obj.fcoj_futures(5) = 0;
            obj.ora_futures = obj.ora_futures + YearData.future_mark_dec_ORA(:,2);
            obj.fcoj_futures = obj.fcoj_futures + YearData.future_mark_dec_FCOJ(:,2);
            obj.proc_plant_cap = obj.proc_plant_cap + YearData.proc_plant_dec;
            obj.tank_cars_num = obj.tank_cars_num + YearData.tank_car_dec;
            obj.storage_cap = obj.storage_cap + YearData.storage_dec;
            
        end
        
    end
    
end

