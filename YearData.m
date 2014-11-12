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
        % that year, and one for the results - probably just a shitton of
        % properties instead
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
       
        % Need to do the same for all the results matrices             
    end
    
    methods
        % Constructor where you update each of the properties 
        function yr = YearData(filename,OJ_object)
            if nargin > 0
                % Read in the processing plant decision table from the
                % excel file (say it's called data), then set
                % yr.proc_plant_dec = data
                yr.year = xlsread(filename,'basic_info','D5:F5');
                yr.proc_plant_dec = xlsread(filename,'facilities','C6:C15');
                yr.tank_car_dec = xlsread(filename,'facilities','C21:C30');
                yr.storage_dec = xlsread(filename,'facilities','C36:C106');
                yr.purchase_spotmkt_dec = xlsread(filename,'raw_materials','C6:N11');
                yr.quant_mult_dec = xlsread(filename,'raw_materials','C17:H22');
                yr.future_mark_dec_ORA = xlsread(filename,'raw_materials','N31:O35');
                yr.future_mark_dec_FCOJ = xlsread(filename,'raw_materials','N37:O41');
                yr.arr_future_dec_ORA = xlsread(filename,'raw_materials','C47:N47');
                yr.arr_future_dec_FCOJ = xlsread(filename,'raw_materials','C48:N48');

                num_procs = sum((OJ_object.proc_plant_cap ~= 0));
                num_stor = sum((OJ_object.storage_cap ~= 0));
                mat_offset = num_procs + num_stor - 1;
                col = char('C' + mat_offset);
                range = strcat('C6:',col,'11');
                yr.ship_grove_dec = xlsread(filename,'shipping_manufacturing',range);

                col_2 = char('C' + 2*num_procs -1);
                range = strcat('C19:',col_2,'19');
                raw_manufac = xlsread(filename,'shipping_manufacturing',range);
                reshape_manufac = reshape(raw_manufac,2,length(raw_manufac)/2);
                non_zero = find(OJ_object.proc_plant_cap);
                for i=1:num_procs 
                    plant = non_zero(i);
                    yr.manufac_proc_plant_dec(:,plant) = reshape_manufac(:,i);
                end

                range = strcat('B36:','N',num2str(26+num_stor+1));
                raw_recon = xlsread(filename,'shipping_manufacturing',range);
                non_zero2 = find(OJ_object.storage_cap);
                for i=1:num_stor
                    stor = non_zero2(i);
                    yr.reconst_storage_dec(stor,:) = raw_recon(i,:);
                end

                col = char('C' + 2*num_procs);
                range = strcat('C27:',col,num2str(34+num_stor));
                data = xlsread(filename,'shipping_manufacturing',range);
                for i=1:num_stor
                    stor = non_zero2(i);
                    yr.futures_ship_dec(stor) = data(i,1);
                end
                ship_break = struct('POJ', nan, 'FCOJ', nan);
                yr.ship_proc_plant_storage_dec = ship_break;
                for (i=1:71)
                    for(j =1:10)
                        yr.ship_proc_plant_storage_dec(i,j) = ship_break;
                    end
                end
                for (i=1:num_stor)
                    for(j=1:2:2*num_procs)
                        proc_plant = non_zero((j+1)/2);
                        stor_fac = non_zero2(i);
                        yr.ship_proc_plant_storage_dec(stor_fac, proc_plant).POJ = data(i, j+1);
                        yr.ship_proc_plant_storage_dec(stor_fac, proc_plant).FCOJ = data(i, j+2);
                          
                    end
                end

                yr.pricing_ORA_dec = xlsread(filename,'pricing','D6:O12');
                yr.pricing_POJ_dec = xlsread(filename,'pricing','D15:O21');
                yr.pricing_ROJ_dec = xlsread(filename,'pricing','D24:O30');
                yr.pricing_FCOJ_dec = xlsread(filename,'pricing','D33:O39');
            end
        end 
    end
    
end

