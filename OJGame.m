classdef OJGame 
    % This class holds all the information of the current state of our
    % orange juice game.
    %   The purpose of this class is to contain information about:
    %     Remaining inventory from previous year in
    %       1. Processing Plants helo
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
        ora_futures_current;
        ora_futures_current1;
        ora_futures_current2;
        ora_futures_current3;
        ora_futures_current4;
        fcoj_futures_current;
        fcoj_futures_current1;
        fcoj_futures_current2;
        fcoj_futures_current3;
        fcoj_futures_current4;
        
    end
    
    methods
        % Constructor to set all the values to the initial genesis run
        function oj = OJGame(filename)
            oj.year_start = xlsread(filename,'basic_info','D5:F5');
            [~,~, proc_plant] = xlsread(filename,'facilities','D6:D15');
            proc_plant = cell2mat(cellNaNReplace(proc_plant,0));
            for i = 1:10
                oj.proc_plant_cap(i) = proc_plant(i);
            end
            [~,~, tank_cars] = xlsread(filename,'facilities','D21:D30');
            tank_cars = cell2mat(cellNaNReplace(tank_cars,0));
            for i = 1:10
                oj.tank_cars_num(i) = tank_cars(i);
            end
            [~,~, storage_capacity] = xlsread(filename,'facilities','D36:D106');
            storage_capacity = cell2mat(cellNaNReplace(storage_capacity,0));
            for i = 1:71
                oj.storage_cap(i) = storage_capacity(i);
            end
            test_1 = struct('ORA', zeros(5,1));
            oj.proc_plant_inv = test_1;
            for (i=2:10)
                oj.proc_plant_inv(i) = test_1;
            end
            test = struct('ORA', nan, 'POJ', nan, 'FCOJ', nan, 'ROJ', nan);
            oj.storage_inv = test;
            for (i=2:71)
                oj.storage_inv(i) = test;
            end
            storage_open = find(storage_capacity);
            for i = 1:length(storage_open)
                index = storage_open(i);
                oj.storage_inv(index).ORA = zeros(5,1);
                oj.storage_inv(index).POJ = zeros(9,1);
                oj.storage_inv(index).FCOJ = zeros(13,1);
                oj.storage_inv(index).ROJ = zeros(49,1);
            end
            [~, ~, oj.ora_futures_current] = xlsread(filename,'raw_materials','D30:M30');
            oj.ora_futures_current = cell2mat(cellNaNReplace(oj.ora_futures_current,0));
            [~, ~, oj.ora_futures_current1] = xlsread(filename,'raw_materials','F31:M31');
            oj.ora_futures_current1 = cell2mat(cellNaNReplace(oj.ora_futures_current1,0));
            [~, ~, oj.ora_futures_current2] = xlsread(filename,'raw_materials','H32:M32');
            oj.ora_futures_current2 = cell2mat(cellNaNReplace(oj.ora_futures_current2,0));
            [~, ~, oj.ora_futures_current3] = xlsread(filename,'raw_materials','J33:M33');
            oj.ora_futures_current3 = cell2mat(cellNaNReplace(oj.ora_futures_current3,0));
            [~, ~, oj.ora_futures_current4] = xlsread(filename,'raw_materials','L34:M34');
            oj.ora_futures_current4= cell2mat(cellNaNReplace(oj.ora_futures_current4,0));
            
            [~, ~, oj.fcoj_futures_current] = xlsread(filename,'raw_materials','D36:M36');
            oj.fcoj_futures_current = cell2mat(cellNaNReplace(oj.fcoj_futures_current,0));
            [~, ~, oj.fcoj_futures_current1] = xlsread(filename,'raw_materials','F37:M37');
            oj.fcoj_futures_current1 = cell2mat(cellNaNReplace(oj.fcoj_futures_current1,0));
            [~, ~, oj.fcoj_futures_current2] = xlsread(filename,'raw_materials','H38:M38');
            oj.fcoj_futures_current2 = cell2mat(cellNaNReplace(oj.fcoj_futures_current2,0));
            [~, ~, oj.fcoj_futures_current3] = xlsread(filename,'raw_materials','J39:M39');
            oj.fcoj_futures_current3 = cell2mat(cellNaNReplace(oj.fcoj_futures_current3,0));
            [~, ~, oj.fcoj_futures_current4] = xlsread(filename,'raw_materials','L40:M40');
            oj.fcoj_futures_current4= cell2mat(cellNaNReplace(oj.fcoj_futures_current4,0));
          
            oj.futures_years = [oj.year_start; oj.year_start + 1; oj.year_start + 2; oj.year_start + 3; oj.year_start + 4];
            
        end
        
        % Function to update all the values of the properties. The input 
        % is an instance of the YearData class
        function obj = update(obj,YearData)
            obj.year_start = YearData.year + 1;
            plants_open = find(obj.proc_plant_cap);
            for (i=1:length(plants_open))
                plant_name = char(plantNamesInUse(plants_open(i)));
                inventory = YearData.proc_plant_res(plant_name).ORA_Inventory;
                obj.proc_plant_inv(plants_open(i)).ORA = inventory(1:5, 49);
            end
            stor_open = find(obj.storage_cap);
            for (i=1:length(stor_open))
                stor_name = char(storageNamesInUse(stor_open(i)));
                inventory_ora = YearData.storage_res(stor_name).ORA_Inv;
                obj.storage_inv(stor_open(i)).ORA = inventory_ora(1:5,49);
                inventory_poj = YearData.storage_res(stor_name).POJ_Inv;
                obj.storage_inv(stor_open(i)).POJ = inventory_poj(1:9,49);
                inventory_fcoj = YearData.storage_res(stor_name).FCOJ_Inv;
                obj.storage_inv(stor_open(i)).FCOJ = inventory_fcoj(1:49,49);
                inventory_roj = YearData.storage_res(stor_name).ROJ_Inv;
                obj.storage_inv(stor_open(i)).ROJ = inventory_roj(1:13,49);
            end
            obj.futures_years = obj.futures_years + 1;
            obj.ora_futures_current = YearData.future_mark_dec_ORA_current1;
            obj.ora_futures_current1 = YearData.future_mark_dec_ORA_current2;
            obj.ora_futures_current2 = YearData.future_mark_dec_ORA_current3;
            obj.ora_futures_current3 = YearData.future_mark_dec_ORA_current4;
            obj.ora_futures_current4 = YearData.future_mark_dec_ORA_current5;
            obj.fcoj_futures_current = YearData.future_mark_dec_FCOJ_current1;
            obj.fcoj_futures_current1 = YearData.future_mark_dec_FCOJ_current2;
            obj.fcoj_futures_current2 = YearData.future_mark_dec_FCOJ_current3;
            obj.fcoj_futures_current3 = YearData.future_mark_dec_FCOJ_current4;
            obj.fcoj_futures_current4 = YearData.future_mark_dec_FCOJ_current5;
            
            obj.proc_plant_cap = obj.proc_plant_cap + YearData.proc_plant_dec;
            obj.tank_cars_num = obj.tank_cars_num + YearData.tank_car_dec;
            obj.storage_cap = obj.storage_cap + YearData.storage_dec;
            
        end
        
    end
    
end

