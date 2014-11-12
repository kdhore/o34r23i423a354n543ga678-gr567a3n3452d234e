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
    %       3. Tank Cars
    %     Futures: Keep track of which futures are arriving when
    
    properties
        % All these values are equal to the values before the 2004 run.
        % 2004 is the genesis year. The constructor simply updates them.
        
        % inventory in each of the processing plants
        proc_plant_inv = zeros(10,1);
        % inventory in each of the storage locations
        
        storage_inv = struct([]);    
        % capacity at each of the processing plants
        proc_plant_cap = zeros(10,1);
                
        % capacity at each of the storage locations
        storage_cap = zeros(71,1);
        
        % Number of tank cars? and Where they are?
        tank_cars_num = zeros(10,1);
        
        % Two arrays for future deliveries (one for ORA and one for FCOJ)
        %   - how much is arriving and when
           
    end
    
    methods
        % Constructor to set all the values to the initial 2004 genesis run
        function oj = OJGame()
            oj.proc_plant_cap(1) = 2043;
            oj.proc_plant_cap(5) = 2454;
            oj.proc_plant_cap(7) = 5273;
            oj.tank_cars_num(1) = 61; 
            oj.tank_cars_num(5) = 91;
            oj.tank_cars_num(7) = 155;
            oj.storage_cap(4) = 40000;
            oj.storage_cap(41) = 43000;
            test = struct('ORA', nan, 'POJ', nan, 'FCOJ', nan, 'ROJ', nan);
            oj.storage_inv = test;
            for (i=2:71)
                oj.storage_inv(i) = test;
            end
            oj.storage_inv(4).ORA = 0;
            oj.storage_inv(4).POJ = 0;
            oj.storage_inv(4).FCOJ = 0;
            oj.storage_inv(4).ROJ = 0;

            oj.storage_inv(41).ORA = 0;
            oj.storage_inv(41).POJ = 0;
            oj.storage_inv(41).FCOJ = 0;
            oj.storage_inv(41).ROJ = 0;
        end
        
        % Function to update all the values of the properties. The input 
        % is an instance of the YearData class
        function update(yeardataobj)
            
        end
        
    end
    
end

