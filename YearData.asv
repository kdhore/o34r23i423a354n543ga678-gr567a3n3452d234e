classdef YearData
    % This class represents the decisions and results of a given year
    %   You can instantiate a new Year object by passing in the results
    %   spreadsheet of that year. This class organizes all the information
    %   from the spreadsheet into matrices. You can access the matrices
    %   by simply accessing the properties of the object (object.property)
    
    properties
        % These are the properties/matrices of each year. Most likely 
        % can represented by a struct or just a bunch of matrices. We
        % should have two separate structs, one for the decisions of 
        % that year, and one for the results
        proc_plant_dec;
        tank_car_dec;
        storage_dec;
        purchase_spotmkt_dec;
        quant_mult_dec;
        future_mark_dec;
        arr_future_dec;
        ship_grove_dec;
        manuface_proc_plant_dec;
        ship_proc_plant_storage_dec;
        reconst_storage_dec;
        pricing_ORA_dec;
        pricing_POJ_dec;
        pricing_FCOJ_dec;
        pricing_ROJ_dec;
        decisions = struct('Processing Plant Decisions', proc_plant_dec,...
                           'Tank Car Decisions', tank_car_dec)
       
        % Need to do the same for all the results matrices             
    end
    
    methods
        % Constructor where you update each of the properties 
        function yr = YearData(filename)
            if nargin > 0
                % Read in the processing plant decision table from the
                % excel file (say it's called data), then set
                % yr.proc_plant_dec = data
            end
        end 
    end
    
end

