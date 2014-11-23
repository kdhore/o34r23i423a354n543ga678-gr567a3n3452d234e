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

        % that year, and one for the results - probably just a shitton of
        % properties instead

        year;
        proc_plant_dec;
        tank_car_dec;
        %tank_status;
        storage_dec;
        purchase_spotmkt_dec;
        quant_mult_dec;
        future_mark_dec_ORA;
        future_mark_dec_FCOJ;
        future_mark_dec_ORA_current;
        future_mark_dec_ORA_current1;
        future_mark_dec_ORA_current2;
        future_mark_dec_ORA_current3;
        future_mark_dec_ORA_current4;
        future_mark_dec_ORA_current5;
        future_mark_dec_FCOJ_current;
        future_mark_dec_FCOJ_current1;
        future_mark_dec_FCOJ_current2;
        future_mark_dec_FCOJ_current3;
        future_mark_dec_FCOJ_current4;
        future_mark_dec_FCOJ_current5;
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
       
        % Result matrices
        price_orange_spot_res;
        fx_exch_res;
        us_price_spot_res;
        quant_mult_res;
        amt_ora_harv_res;
        amt_ora_purch_res;
        purch_cost_ora_res;
        amt_mature_future_ORA_res;
        amt_mature_future_FCOJ_res;
        transp_cost_ship_future_FCOJ_res = zeros(12,71);
        amt_ORA_shipped_grove_res;
        transp_cost_grove_proc_FLA_res = zeros(10,48);
        transp_cost_grove_stor_FLA_res = zeros(71,48);
        transp_cost_grove_proc_CAL_res = zeros(10,48);
        transp_cost_grove_stor_CAL_res = zeros(71,48);
        transp_cost_grove_proc_TEX_res = zeros(10,48);
        transp_cost_grove_stor_TEX_res = zeros(71,48);
        transp_cost_grove_proc_ARZ_res = zeros(10,48);
        transp_cost_grove_stor_ARZ_res = zeros(71,48);
        transp_cost_grove_proc_BRA_res = zeros(10,48);
        transp_cost_grove_stor_BRA_res = zeros(71,48);
        transp_cost_grove_proc_SPA_res = zeros(10,48);
        transp_cost_grove_stor_SPA_res = zeros(71,48);
        proc_plant_res = containers.Map;
        storage_res = containers.Map;
        sales_week_ORA_res;
        transp_cost_ORA_res;
        sales_tons_month_ORA_res;
        sales_rev_month_ORA_res;
        transp_cost_month_ORA_res;
        sales_week_POJ_res;
        transp_cost_POJ_res;
        sales_tons_month_POJ_res;
        sales_rev_month_POJ_res;
        transp_cost_month_POJ_res;
        sales_week_FCOJ_res;
        transp_cost_FCOJ_res;
        sales_tons_month_FCOJ_res;
        sales_rev_month_FCOJ_res;
        transp_cost_month_FCOJ_res;
        sales_week_ROJ_res;
        transp_cost_ROJ_res;
        sales_tons_month_ROJ_res;
        sales_rev_month_ROJ_res;
        transp_cost_month_ROJ_res;
        market_res_stats;
        market_res_names;
        
    end
    
    methods
        % Constructor where you update each of the properties 
        function yr = YearData(filename,OJ_object)
            if nargin > 0
                % Read in the processing plant decision table from the
                % excel file (say it's called data), then set
                % yr.proc_plant_dec = data
                yr.year = xlsread(filename,'basic_info','D5:F5');

                
                % Reading in facilities tab
                [~,~, yr.proc_plant_dec] = xlsread(filename,'facilities','C6:C15');
                yr.proc_plant_dec = cell2mat(cellNaNReplace(yr.proc_plant_dec,0));                
                [~,~, yr.tank_car_dec] = xlsread(filename,'facilities','C21:C30');
                yr.tank_car_dec = cell2mat(cellNaNReplace(yr.tank_car_dec,0));                
                [~,~, yr.storage_dec] = xlsread(filename,'facilities','C36:C106');
                yr.storage_dec = cell2mat(cellNaNReplace(yr.storage_dec,0));
                
                %plants_open = find(OJ_object.proc_plant_cap);
                %yr.tank_status = zeros(3,length(plants_open));
                %for i = 1:length(plants_open)
                %    if (i == 10)
                %        [~,~,yr.tank_status(:,i)] = xlsread(filename,strcat('P',num2string(i)),'AY27:AY29');
                %    else  
                %        [~,~,yr.tank_status(:,i)] = xlsread(filename,strcat('P0',num2string(i)),'AY27:AY29');  
                %    end
                %end
                % Reading in raw_materials tab
                [~, ~, yr.purchase_spotmkt_dec] = xlsread(filename,'raw_materials','C6:N11');
                yr.purchase_spotmkt_dec = cell2mat(cellNaNReplace(yr.purchase_spotmkt_dec,0));  
                yr.quant_mult_dec = xlsread(filename,'raw_materials','C17:H22');
                
                [~, ~, yr.future_mark_dec_ORA] = xlsread(filename,'raw_materials','N31:O35');
                yr.future_mark_dec_ORA = cell2mat(cellNaNReplace(yr.future_mark_dec_ORA,0));
                [~, ~, yr.future_mark_dec_FCOJ] = xlsread(filename,'raw_materials','N37:O41');
                yr.future_mark_dec_FCOJ = cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ,0));
                [~, ~, yr.future_mark_dec_ORA_current] = xlsread(filename,'raw_materials','D30:M30');
                yr.future_mark_dec_ORA_current = cell2mat(cellNaNReplace(yr.future_mark_dec_ORA_current,0));
                [~, ~, yr.future_mark_dec_ORA_current1] = xlsread(filename,'raw_materials','F31:O31');
                yr.future_mark_dec_ORA_current1 = cell2mat(cellNaNReplace(yr.future_mark_dec_ORA_current1,0));
                [~, ~, yr.future_mark_dec_ORA_current2] = xlsread(filename,'raw_materials','H32:O32');
                yr.future_mark_dec_ORA_current2 = cell2mat(cellNaNReplace(yr.future_mark_dec_ORA_current2,0));
                [~, ~, yr.future_mark_dec_ORA_current3] = xlsread(filename,'raw_materials','J33:O33');
                yr.future_mark_dec_ORA_current3 = cell2mat(cellNaNReplace(yr.future_mark_dec_ORA_current3,0));
                [~, ~, yr.future_mark_dec_ORA_current4] = xlsread(filename,'raw_materials','L34:O34');
                yr.future_mark_dec_ORA_current4= cell2mat(cellNaNReplace(yr.future_mark_dec_ORA_current4,0));
                [~, ~, yr.future_mark_dec_ORA_current5] = xlsread(filename,'raw_materials','N35:O35');
                yr.future_mark_dec_ORA_current5= cell2mat(cellNaNReplace(yr.future_mark_dec_ORA_current5,0));
                
                [~, ~, yr.future_mark_dec_FCOJ_current] = xlsread(filename,'raw_materials','D36:M36');
                yr.future_mark_dec_FCOJ_current = cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ_current,0));
                [~, ~, yr.future_mark_dec_FCOJ_current1] = xlsread(filename,'raw_materials','F37:O37');
                yr.future_mark_dec_FCOJ_current1 = cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ_current1,0));
                [~, ~, yr.future_mark_dec_FCOJ_current2] = xlsread(filename,'raw_materials','H38:O38');
                yr.future_mark_dec_FCOJ_current2 = cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ_current2,0));
                [~, ~, yr.future_mark_dec_FCOJ_current3] = xlsread(filename,'raw_materials','J39:O39');
                yr.future_mark_dec_FCOJ_current3 = cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ_current3,0));
                [~, ~, yr.future_mark_dec_FCOJ_current4] = xlsread(filename,'raw_materials','L40:O40');
                yr.future_mark_dec_FCOJ_current4= cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ_current4,0));
                [~, ~, yr.future_mark_dec_FCOJ_current5] = xlsread(filename,'raw_materials','N41:O41');
                yr.future_mark_dec_FCOJ_current5= cell2mat(cellNaNReplace(yr.future_mark_dec_FCOJ_current5,0));

                yr.arr_future_dec_ORA = xlsread(filename,'raw_materials','C47:N47');
                yr.arr_future_dec_FCOJ = xlsread(filename,'raw_materials','C48:N48');

                num_proc = sum((OJ_object.proc_plant_cap ~= 0));
                num_stor = sum((OJ_object.storage_cap ~= 0));
                mat_offset = num_proc + num_stor - 1;
                col = char('C' + mat_offset);
                range = strcat('C6:',col,'11');

                [~, ~, yr.ship_grove_dec] = xlsread(filename,'shipping_manufacturing',range);
                yr.ship_grove_dec = cell2mat(cellNaNReplace(yr.ship_grove_dec,0));
                


                col_2 = char('C' + 2*num_proc -1);
                range = strcat('C19:',col_2,'19');
                raw_manufac = xlsread(filename,'shipping_manufacturing',range);
                reshape_manufac = reshape(raw_manufac,2,length(raw_manufac)/2);
                non_zero = find(OJ_object.proc_plant_cap);
                for i=1:num_proc 
                    plant = non_zero(i);
                    yr.manufac_proc_plant_dec(:,plant) = reshape_manufac(:,i);
                end


                range = strcat('C36:','N',num2str(26+num_stor+9));
                [~, ~, raw_recon] = xlsread(filename,'shipping_manufacturing',range);
                raw_recon = cell2mat(cellNaNReplace(raw_recon,0));

                non_zero2 = find(OJ_object.storage_cap);
                for i=1:num_stor
                    stor = non_zero2(i);
                    yr.reconst_storage_dec(stor,:) = raw_recon(i,:);
                end

                col = char('C' + 2*num_proc);

                range = strcat('C27:',col,num2str(26+num_stor));
                [~, ~, data] = xlsread(filename,'shipping_manufacturing',range);
                data = cell2mat(cellNaNReplace(data,0));

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
                    for(j=1:2:2*num_proc)
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
                for i = 1:12
                    j = 4*(i-1)+1;
                    yr.pricing_ORA_weekly_dec(:,j:j+3) = repmat(yr.pricing_ORA_dec(:,i),1,4);
                    yr.pricing_POJ_weekly_dec(:,j:j+3) = repmat(yr.pricing_POJ_dec(:,i),1,4);
                    yr.pricing_ROJ_weekly_dec(:,j:j+3) = repmat(yr.pricing_ROJ_dec(:,i),1,4);
                    yr.pricing_FCOJ_weekly_dec(:,j:j+3) = repmat(yr.pricing_FCOJ_dec(:,i),1,4);
                end

                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Reading in the results
                [~,~, yr.price_orange_spot_res] = xlsread(filename,'grove','C5:N10');
                yr.price_orange_spot_res = cell2mat(cellNaNReplace(yr.price_orange_spot_res,0));

                [~,~, yr.fx_exch_res] = xlsread(filename,'grove','C14:N15');
                yr.fx_exch_res = cell2mat(cellNaNReplace(yr.fx_exch_res,0));

                [~,~, yr.us_price_spot_res] = xlsread(filename,'grove','C19:N24');
                yr.us_price_spot_res = cell2mat(cellNaNReplace(yr.us_price_spot_res,0));

                [~,~, yr.quant_mult_res] = xlsread(filename,'grove','C28:N33');
                yr.quant_mult_res = cell2mat(cellNaNReplace(yr.quant_mult_res,0));

                [~,~, yr.amt_ora_harv_res] = xlsread(filename,'grove','C38:AX43');
                yr.amt_ora_harv_res = cell2mat(cellNaNReplace(yr.amt_ora_harv_res,0));

                [~,~, yr.amt_ora_purch_res] = xlsread(filename,'grove','C48:AX53');
                yr.amt_ora_purch_res = cell2mat(cellNaNReplace(yr.amt_ora_purch_res,0));

                [~,~, yr.purch_cost_ora_res] = xlsread(filename,'grove','C58:AX63');
                yr.purch_cost_ora_res = cell2mat(cellNaNReplace(yr.purch_cost_ora_res,0));

                [~,~, yr.amt_mature_future_ORA_res] = xlsread(filename,'grove','C67:N67');
                yr.amt_mature_future_ORA_res = cell2mat(cellNaNReplace(yr.amt_mature_future_ORA_res,0));

                [~,~, yr.amt_mature_future_FCOJ_res] = xlsread(filename,'grove','C68:N68');
                yr.amt_mature_future_FCOJ_res = cell2mat(cellNaNReplace(yr.amt_mature_future_FCOJ_res,0));
                
                [~,~, yr.amt_ORA_shipped_grove_res] = xlsread(filename,'grove','C88:AX93');
                yr.amt_ORA_shipped_grove_res = cell2mat(cellNaNReplace(yr.amt_ORA_shipped_grove_res,0));

                col = char('C' + num_stor - 1);
                range = strcat('C72:',col,'83');
                [~, ~, raw_data] = xlsread(filename,'grove',range);
                raw_data = cell2mat(cellNaNReplace(raw_data,0));
                for (i=1:num_stor)
                    yr.transp_cost_ship_future_FCOJ_res(:,non_zero2(i)) = raw_data(:,i);
                end
                fla_range_proc = strcat('C98:AX',num2str(98+num_proc - 1));
                [~, ~, data] = xlsread(filename, 'grove', fla_range_proc);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_proc)
                    yr.transp_cost_grove_proc_FLA_res(non_zero(i),:) = data(i,:);
                end
                fla_range_stor = strcat('C', num2str(98+num_proc),':AX',num2str(98+num_proc +num_stor - 1));
                [~, ~, data] = xlsread(filename, 'grove', fla_range_stor);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_stor)
                    yr.transp_cost_grove_stor_FLA_res(non_zero2(i),:) = data(i,:);
                end
                
                cal_range_proc = strcat('C',num2str(98+num_proc+num_stor+1),':AX',num2str(98+2*num_proc+num_stor+1 - 1));
                [~, ~, data] = xlsread(filename, 'grove', cal_range_proc);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_proc)
                    yr.transp_cost_grove_proc_CAL_res(non_zero(i),:) = data(i,:);
                end
                cal_range_stor = strcat('C', num2str(98+2*num_proc+num_stor+1 - 1+1),':AX',num2str(98+2*num_proc+2*num_stor+1 - 1+1-1));
                [~, ~, data] = xlsread(filename, 'grove', cal_range_stor);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_stor)
                    yr.transp_cost_grove_stor_CAL_res(non_zero2(i),:) = data(i,:);
                end
                
                tex_range_proc = strcat('C',num2str(98+2*num_proc+2*num_stor+2),':AX',num2str(98+3*num_proc+2*num_stor+2 - 1));
                [~, ~, data] = xlsread(filename, 'grove', tex_range_proc);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_proc)
                    yr.transp_cost_grove_proc_TEX_res(non_zero(i),:) = data(i,:);
                end
                tex_range_stor = strcat('C', num2str(98+3*num_proc+2*num_stor+2 - 1 +1),':AX',num2str(98+3*num_proc+3*num_stor+2 - 1 +1 - 1));
                [~, ~, data] = xlsread(filename, 'grove', tex_range_stor);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_stor)
                    yr.transp_cost_grove_stor_TEX_res(non_zero2(i),:) = data(i,:);
                end
                arz_range_proc = strcat('C',num2str(98+3*num_proc + 3*num_stor + 3),':AX',num2str(98+4*num_proc + 3*num_stor + 3 - 1));
                [~, ~, data] = xlsread(filename, 'grove', arz_range_proc);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_proc)
                    yr.transp_cost_grove_proc_ARZ_res(non_zero(i),:) = data(i,:);
                end
                arz_range_stor = strcat('C', num2str(98+4*num_proc + 3*num_stor + 3 - 1+1),':AX',num2str(98+4*num_proc + 4*num_stor + 3 - 1+1-1));
                [~, ~, data] = xlsread(filename, 'grove', arz_range_stor);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_stor)
                    yr.transp_cost_grove_stor_ARZ_res(non_zero2(i),:) = data(i,:);
                end
                bra_range_proc = strcat('C',num2str(98+4*num_proc+4*num_stor+4),':AX',num2str(98+5*num_proc+4*num_stor+4 -1));
                [~, ~, data] = xlsread(filename, 'grove', bra_range_proc);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_proc)
                    yr.transp_cost_grove_proc_BRA_res(non_zero(i),:) = data(i,:);
                end
                bra_range_stor = strcat('C', num2str(98+5*num_proc+4*num_stor+4 -1+1),':AX',num2str(98+5*num_proc+5*num_stor+4 -1+1-1));
                [~, ~, data] = xlsread(filename, 'grove', bra_range_stor);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_stor)
                    yr.transp_cost_grove_stor_BRA_res(non_zero2(i),:) = data(i,:);
                end
                spa_range_proc = strcat('C',num2str(98+ 5*num_proc + 5*num_stor + 5),':AX',num2str(98+ 6*num_proc + 5*num_stor + 5 -1));
                [~, ~, data] = xlsread(filename, 'grove', spa_range_proc);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_proc)
                    yr.transp_cost_grove_proc_SPA_res(non_zero(i),:) = data(i,:);
                end
                bra_range_stor = strcat('C', num2str(98+ 6*num_proc + 5*num_stor + 5 -1+1),':AX',num2str(98+ 6*num_proc + 6*num_stor + 5 -1+1-1));
                [~, ~, data] = xlsread(filename, 'grove', bra_range_stor);
                data = cell2mat(cellNaNReplace(data,0));
                for (i=1:num_stor)
                    yr.transp_cost_grove_stor_SPA_res(non_zero2(i),:) = data(i,:);
                end
                
                %%%%% Read each of the processing plant tabs
                for (i=1:num_proc)
                    shtname = char(plantNamesInUse(non_zero(i)));
                    [~, ~, ora_ship_in] = xlsread(filename,shtname,'D7:AY7');
                    ora_ship_in = cell2mat(cellNaNReplace(ora_ship_in,0));
                    [~, ~, ora_toss_out] = xlsread(filename,shtname,'D10:AY10');
                    ora_toss_out = cell2mat(cellNaNReplace(ora_toss_out,0));
                    [~, ~, ora_inven] = xlsread(filename, shtname, 'C13:AY17');
                    ora_inven = cell2mat(cellNaNReplace(ora_inven,0));
                    [~, ~, manufac_POJ] =  xlsread(filename, shtname, 'D21:AY21');
                    manufac_POJ = cell2mat(cellNaNReplace(manufac_POJ,0));
                    [~, ~, manufac_FCOJ] =  xlsread(filename, shtname, 'D22:AY22');
                    manufac_FCOJ = cell2mat(cellNaNReplace(manufac_FCOJ,0));
                    [~, ~, manufac_cost_POJ] =  xlsread(filename, shtname, 'D23:AY23');
                    manufac_cost_POJ = cell2mat(cellNaNReplace(manufac_cost_POJ,0));
                    [~, ~, manufac_cost_FCOJ] =  xlsread(filename, shtname, 'D24:AY24');
                    manufac_cost_FCOJ = cell2mat(cellNaNReplace(manufac_cost_FCOJ,0));
                    [~, ~, tank_car_status] = xlsread(filename,shtname,'C27:AY29');
                    tank_car_status = cell2mat(cellNaNReplace(tank_car_status,0));
                    [~, ~, holding_cost] = xlsread(filename,shtname,'D30:AY30');
                    holding_cost = cell2mat(cellNaNReplace(holding_cost,0));
                    storage_info = containers.Map;
                    for (j=1:num_stor)
                        stor_name = char(storageNamesInUse(non_zero2(j)));
                        range = strcat('C',num2str(32+(j-1)*11+1),':AY',num2str(32+ j*11));
                        [~, ~, data] = xlsread(filename,shtname, range);
                        data = cell2mat(cellNaNReplace(data,0));
                        storage_info(stor_name) = data;
                    end
                    together = struct('ORA_Shipped_In', ora_ship_in, 'ORA_Tossed_Out', ora_toss_out,...
                                      'ORA_Inventory', ora_inven, 'POJ_Manufactured', manufac_POJ,...
                                      'FCOJ_Manufactured', manufac_FCOJ, 'Cost_POJ_Manufactured',manufac_cost_POJ,...
                                      'Cost_FCOJ_Manufactured',manufac_cost_FCOJ, 'Tank_Car_Status', tank_car_status,...
                                      'Holding_Cost', holding_cost,'Storage_Info', storage_info);
                    yr.proc_plant_res(shtname) = together;              
                end
                for (i=1:num_stor)
                    shtname = char(storageNamesInUse(non_zero2(i)));
                   
                    [~, ~, ora_ship_in] = xlsread(filename,shtname,'D9:AY9');
                    ora_ship_in = cell2mat(cellNaNReplace(ora_ship_in,0));
                    [~, ~, poj_ship_in] = xlsread(filename,shtname,'D10:AY13');
                    poj_ship_in = cell2mat(cellNaNReplace(poj_ship_in,0));
                    [~, ~, roj_ship_in] = xlsread(filename,shtname,'D14:AY14');
                    roj_ship_in = cell2mat(cellNaNReplace(roj_ship_in,0));
                    [~, ~, fcoj_ship_in] = xlsread(filename,shtname,'D15:AY18');
                    fcoj_ship_in = cell2mat(cellNaNReplace(fcoj_ship_in,0));
                    [~, ~, ora_toss_out] = xlsread(filename,shtname,'D21:AY24');
                    ora_toss_out = cell2mat(cellNaNReplace(ora_toss_out,0));
                    [~, ~, poj_toss_out] = xlsread(filename,shtname,'D25:AY32');
                    poj_toss_out = cell2mat(cellNaNReplace(poj_toss_out,0));
                    [~, ~, roj_toss_out] = xlsread(filename,shtname,'D33:AY44');
                    roj_toss_out = cell2mat(cellNaNReplace(roj_toss_out,0));
                    [~, ~, fcoj_toss_out] = xlsread(filename,shtname,'D45:AY92');
                    fcoj_toss_out = cell2mat(cellNaNReplace(fcoj_toss_out,0));
                    [~, ~, ora_inven] = xlsread(filename,shtname,'C95:AY99');
                    ora_inven = cell2mat(cellNaNReplace(ora_inven,0));
                    [~, ~, poj_inven] = xlsread(filename,shtname,'C100:AY108');
                    poj_inven = cell2mat(cellNaNReplace(poj_inven,0));
                    [~, ~, roj_inven] = xlsread(filename,shtname,'C109:AY121');
                    roj_inven = cell2mat(cellNaNReplace(roj_inven,0));
                    [~, ~, fcoj_inven] = xlsread(filename,shtname,'C122:AY170');
                    fcoj_inven = cell2mat(cellNaNReplace(fcoj_inven,0));
                    [~, ~, reconst_fcoj] = xlsread(filename,shtname,'C172:AY172');
                    reconst_fcoj = cell2mat(cellNaNReplace(reconst_fcoj,0));
                    [~, ~, ora_sales] = xlsread(filename,shtname,'D175:AY176');
                    ora_sales = cell2mat(cellNaNReplace(ora_sales,0));
                    [~, ~, poj_sales] = xlsread(filename,shtname,'D177:AY178');
                    poj_sales = cell2mat(cellNaNReplace(poj_sales,0));
                    [~, ~, roj_sales] = xlsread(filename,shtname,'D179:AY180');
                    roj_sales = cell2mat(cellNaNReplace(roj_sales,0));
                    [~, ~, fcoj_sales] = xlsread(filename,shtname,'D181:AY182');
                    fcoj_sales = cell2mat(cellNaNReplace(fcoj_sales,0));
                    [~, ~, ora_ship_out] = xlsread(filename,shtname,'C185:AY188');
                    ora_ship_out = cell2mat(cellNaNReplace(ora_ship_out,0));
                    [~, ~, poj_ship_out] = xlsread(filename,shtname,'C189:AY196');
                    poj_ship_out = cell2mat(cellNaNReplace(poj_ship_out,0));
                    [~, ~, roj_ship_out] = xlsread(filename,shtname,'C197:AY208');
                    roj_ship_out = cell2mat(cellNaNReplace(roj_ship_out,0));
                    [~, ~, fcoj_ship_out] = xlsread(filename,shtname,'C209:AY256');
                    fcoj_ship_out = cell2mat(cellNaNReplace(fcoj_ship_out,0));
                    [~, ~, reconst_cost_stor] = xlsread(filename,shtname,'D259:AY259');
                    reconst_cost_stor = cell2mat(cellNaNReplace(reconst_cost_stor,0));
                    [~, ~, hold_cost_stor] = xlsread(filename,shtname,'D260:AY260');
                    hold_cost_stor = cell2mat(cellNaNReplace(hold_cost_stor,0));
                    together = struct('ORA_Shipped_In', ora_ship_in, 'POJ_Shipped_In', poj_ship_in,...
                                      'ROJ_Shipped_In', roj_ship_in, 'FCOJ_Shipped_In', fcoj_ship_in,...
                                      'ORA_Tossed_Out', ora_toss_out, 'POJ_Tossed_Out', poj_toss_out,...
                                      'ROJ_Tossed_Out', roj_toss_out, 'FCOJ_Tossed_Out', fcoj_toss_out,...
                                      'ORA_Inv',ora_inven, 'POJ_Inv',poj_inven,'ROJ_Inv',roj_inven, ...
                                      'FCOJ_Inv',fcoj_inven, 'Reconstitute_from_FCOJ', reconst_fcoj,...
                                      'ORA_Sales', ora_sales,'POJ_Sales', poj_sales,'ROJ_Sales', roj_sales, ...
                                      'FCOJ_Sales', fcoj_sales, 'ORA_Shipped_Out', ora_ship_out,...
                                      'POJ_Shipped_Out', poj_ship_out, 'ROJ_Shipped_Out', roj_ship_out,...
                                      'FCOJ_Shipped_Out', fcoj_ship_out, 'Reconstitution_Cost', reconst_cost_stor,...
                                      'Holding_Cost', hold_cost_stor);
                    yr.storage_res(shtname) = together;                                  
                end
                [~,~, sales_and_transp_cost_weekly_ORA_res] = xlsread(filename,'ORA','D6:CU105');
                sales_and_transp_cost_weekly_ORA_res = cell2mat(cellNaNReplace(sales_and_transp_cost_weekly_ORA_res,0));
                
                for i=1:2:(size(sales_and_transp_cost_weekly_ORA_res,2)-1)
                    yr.sales_week_ORA_res = [yr.sales_week_ORA_res sales_and_transp_cost_weekly_ORA_res(:,i)];
                    yr.transp_cost_ORA_res = [yr.transp_cost_ORA_res sales_and_transp_cost_weekly_ORA_res(:,i+1)];
                end
                [~,~, yr.sales_tons_month_ORA_res] = xlsread(filename,'ORA','D109:O115');
                yr.sales_tons_month_ORA_res = cell2mat(cellNaNReplace(yr.sales_tons_month_ORA_res,0));
                [~,~, yr.sales_rev_month_ORA_res] = xlsread(filename,'ORA','D120:O126');
                yr.sales_rev_month_ORA_res = cell2mat(cellNaNReplace(yr.sales_rev_month_ORA_res,0));
                [~,~, yr.transp_cost_month_ORA_res] = xlsread(filename,'ORA','D131:O137');
                yr.transp_cost_month_ORA_res = cell2mat(cellNaNReplace(yr.transp_cost_month_ORA_res,0));
                
                [~,~, sales_and_transp_cost_weekly_POJ_res] = xlsread(filename,'POJ','D6:CU105');
                sales_and_transp_cost_weekly_POJ_res = cell2mat(cellNaNReplace(sales_and_transp_cost_weekly_POJ_res,0));
                
                for i=1:2:(size(sales_and_transp_cost_weekly_POJ_res,2)-1)
                    yr.sales_week_POJ_res = [yr.sales_week_POJ_res sales_and_transp_cost_weekly_POJ_res(:,i)];
                    yr.transp_cost_POJ_res = [yr.transp_cost_POJ_res sales_and_transp_cost_weekly_POJ_res(:,i+1)];
                end
                [~,~,yr.sales_tons_month_POJ_res] = xlsread(filename,'POJ','D109:O115');
                yr.sales_tons_month_POJ_res = cell2mat(cellNaNReplace(yr.sales_tons_month_POJ_res,0));
                [~,~,yr.sales_rev_month_POJ_res] = xlsread(filename,'POJ','D120:O126');
                yr.sales_rev_month_POJ_res = cell2mat(cellNaNReplace(yr.sales_rev_month_POJ_res,0));
                [~,~,yr.transp_cost_month_POJ_res] = xlsread(filename,'POJ','D131:O137');
                yr.transp_cost_month_POJ_res = cell2mat(cellNaNReplace(yr.transp_cost_month_POJ_res,0));               
                
                [~,~, sales_and_transp_cost_weekly_FCOJ_res] = xlsread(filename,'FCOJ','D6:CU105');
                sales_and_transp_cost_weekly_FCOJ_res = cell2mat(cellNaNReplace(sales_and_transp_cost_weekly_FCOJ_res,0));
                
                for i=1:2:(size(sales_and_transp_cost_weekly_FCOJ_res,2)-1)
                    yr.sales_week_FCOJ_res = [yr.sales_week_FCOJ_res sales_and_transp_cost_weekly_FCOJ_res(:,i)];
                    yr.transp_cost_FCOJ_res = [yr.transp_cost_FCOJ_res sales_and_transp_cost_weekly_FCOJ_res(:,i+1)];
                end
                [~,~,yr.sales_tons_month_FCOJ_res] = xlsread(filename,'FCOJ','D109:O115');
                yr.sales_tons_month_FCOJ_res = cell2mat(cellNaNReplace(yr.sales_tons_month_FCOJ_res,0));
                [~,~,yr.sales_rev_month_FCOJ_res] = xlsread(filename,'FCOJ','D120:O126');
                yr.sales_rev_month_FCOJ_res = cell2mat(cellNaNReplace(yr.sales_rev_month_FCOJ_res,0));
                [~,~,yr.transp_cost_month_FCOJ_res] = xlsread(filename,'FCOJ','D131:O137');
                yr.transp_cost_month_FCOJ_res = cell2mat(cellNaNReplace(yr.transp_cost_month_FCOJ_res,0)); 
                
                [~,~, sales_and_transp_cost_weekly_ROJ_res] = xlsread(filename,'ROJ','D6:CU105');
                sales_and_transp_cost_weekly_ROJ_res = cell2mat(cellNaNReplace(sales_and_transp_cost_weekly_ROJ_res,0));
                
                for i=1:2:(size(sales_and_transp_cost_weekly_ROJ_res,2)-1)
                    yr.sales_week_ROJ_res = [yr.sales_week_ROJ_res sales_and_transp_cost_weekly_ROJ_res(:,i)];
                    yr.transp_cost_ROJ_res = [yr.transp_cost_ROJ_res sales_and_transp_cost_weekly_ROJ_res(:,i+1)];
                end
                [~,~,yr.sales_tons_month_ROJ_res] = xlsread(filename,'ROJ','D109:O115');
                yr.sales_tons_month_ROJ_res = cell2mat(cellNaNReplace(yr.sales_tons_month_ROJ_res,0));
                [~,~,yr.sales_rev_month_ROJ_res] = xlsread(filename,'ROJ','D120:O126');
                yr.sales_rev_month_ROJ_res = cell2mat(cellNaNReplace(yr.sales_rev_month_ROJ_res,0));
                [~,~,yr.transp_cost_month_ROJ_res] = xlsread(filename,'ROJ','D131:O137');
                yr.transp_cost_month_ROJ_res = cell2mat(cellNaNReplace(yr.transp_cost_month_ROJ_res,0)); 
                [~,~,yr.market_res_names] = xlsread(filename,'market','C2:C101');
                yr.market_res_names = cell2mat(cellNaNReplace(yr.market_res_names,0));
                [~,~,yr.market_res_stats] = xlsread(filename,'market','D2:E101');
                yr.market_res_stats = cell2mat(cellNaNReplace(yr.market_res_stats,0)); 
            
        end 
    end
    end 
end

