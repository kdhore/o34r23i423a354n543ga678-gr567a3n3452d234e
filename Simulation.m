function [ results ] = Simulation(OJgameobj, decisions)
%NOTE: WE ACTUALLY NEED TO DO THIS BY CITY, NOT BY REGION BECAUSE
% DIFFERENT STORAGES CAN SERVE TO DIFFERENT CITIES WITHIN THE SAME REGION

% Take inventory and other information from OJGameobj and initilize
% facilities

%Processing plants
plants_open = find(OJgameobj.proc_plant_cap);
proc_plants = cell(length(plants_open),1);
for i = 1:length(plants_open)
    inventory = [OJgameobj.proc_plant_inv(plants_open(i)).ORA; 0];
    proc_plants(i) = processingPlant(plants_open(i),OJgameobj.proc_plant_cap(i),...
                                     decisions.manufac_proc_plant_dec(1,plants_open(i)), ...
                                     0, inventory, 2000, 1000, oj.tank_cars_num(plants_open(i)),...
                                     10);
end

% Storage facilities
storage_open = find(OJgameobj.storage_cap);
storage = cell(length(storage_open),1);
for i = 1:length(storage_open)
    storage_ORA = [OJgameobj.storage_inv(storage_open(i)).ORA; 0];
    storage_POJ = [OJgameobj.storage_inv(storage_open(i)).POJ; 0];
    storage_FCOJ = [OJgameobj.storage_inv(storage_open(i)).FCOJ; 0];
    storage_ROJ = [OJgameobj.storage_inv(storage_open(i)).ROJ; 0];
    storage(i) = storageFacility(OJgameobj.storage_cap(i),... %Need to figure out how this works
                                     need to initialize storage_facility);
end

% Draw grove prices matrix, fx grove => US$ prices, and use actual 
% quantity purchased and the purchasing cost
    grove_spot = grovePrices(); %Need to write function
    fx = foreignEx(); % Need to write function
    adj_BRASPA_USPrice = grove_spot(5:6,:).*fx;
    adj_USP = [grove_spot(1:4,:); adj_BRASPA_USPrice];
    act_quant_mult = zeros(6,12);
    for h = 1:6
        mult_1 = decisions.quant_mult_dec(h,1);
        price_1 = decisions.quant_mult_dec(h,2);
        mult_2 = decisions.quant_mult_dec(h,3);
        price_2 = decisions.quant_mult_dec(h,4);
        mult_3 = decisions.quant_mult_dec(h,5);
        price_3 = decisions.quant_mult_dec(h,6);
        for j = 1:12
            if adj_USP(h,j) <= price_1
                act_quant_mult(h,j) = mult_1;
            end
            if adj_USP(h,j) <= price_2;
                act_quant_mult(h,j) = mult_2;
            end
            if adj_USP(h,j) <= price_3;
                act_quant_mult(h,j) = mult_3;
            end
        end
    end
 quant_purch = decisions.purchase_spotmkt_dec.*act_quant_mult;
 spot_ora_weekly = zeros(6, 48);
 for i = 1:12
     spot_ora_weekly(:,1) = [];
     spot_ora_weekly = [spot_ora_weekly repmat(quant_purch(:,i),1,4)];
 end
 price_weekly = zeros(6,48);
 for i = 1:12
     price_weekly(1:4,1) = [];
     price_weekly = [price_weekly repmat(adj_USP(:,i),1,4)];
 end
     
 purch_cost_weekly = ora_weekly.*price_weekly;
 
 % Calculate the futures cost
 futures_cost_ORA = decisons.future_mark_dec_ORA(:,1).*decisons.future_mark_dec_ORA(:,2);
 futures_cost_FCOJ = decisons.future_mark_dec_FCOJ(:,1).*decisons.future_mark_dec_FCOJ(:,2);
 
 % When are futures arriving
 futures_arr_ORA = repmat(OJgameobj.ora_futures(1).*(decisions.arr_future_dec_ORA*0.01) , 1, 12);
 futures_arr_FCOJ = repmat(OJgameobj.fcoj_futures(1).*(decisions.arr_future_dec_FCOJ*0.01) , 1, 12);
 % Cost of shipping FCOJ futures
 cost_shipping_FCOJ_futures = zeros(length(storage),1);
 for i = 1:length(storage)
    fraction_shipped = decisions.futures_ship_dec(storage_open(i));
    monthly_amt_shipped = futures_arr_FCOJ*fraction_shipped;
    cost_per_ton = findGrove2PlantOrStorageDist('FLA', char(storageNamesInUse(storage_open(i))))*0.22; % I hope this function has been called correctly (MICHELLE)
    cost_shipping_FCOJ_futures(i) = monthly_amt_shipped*cost_per_ton; 
 end
 
 % Transporation of oranges shipped from groves weekly
 futures_per_week_ORA = zeros(1,48);
 for (i = 1:12)
         futures_per_week_ORA(1:4) = [];
         futures_per_week_ORA = [futures_per_week_ORA repmat(futures_arr_ORA(i)/4,1,4)];
 end
 total_ora_shipped = spot_ora_weekly + horzcat(futures_per_week_ORA, zeros(5,48));
 

 % Iterate over all the months
 for i = 1:48
     for j = 1:length(proc_plants)
         shipped_ORA_FLA = decisions.ship_grove_dec(1,j)*0.01*total_ora_shipped(1,i);
         shipped_ORA_CAL = decisions.ship_grove_dec(2,j)*0.01*total_ora_shipped(2,i);
         shipped_ORA_TEX = decisions.ship_grove_dec(3,j)*0.01*total_ora_shipped(3,i);
         shipped_ORA_ARZ = decisions.ship_grove_dec(4,j)*0.01*total_ora_shipped(4,i);
         shipped_ORA_BRA = decisions.ship_grove_dec(5,j)*0.01*total_ora_shipped(5,i);
         shipped_ORA_SPA = decisions.ship_grove_dec(6,j)*0.01*total_ora_shipped(6,i);
         sum_shipped = shipped_ORA_FLA + shipped_ORA_CAL + shipped_ORA_TEX + shipped_ORA_ARZ + ...
                       shipped_ORA_BRA + shipped_ORA_SPA;
         breakdown = rand;
         if (breakdown < .05)
             breakdown = 1;
         else
             breakdown = 0;
         end
         proc_plants{j}.iterateWeek(sum_shipped, decisions, breakdown, storage_open);
     end
     for j = 1:length(storage)
         shipped_ORA_FLA = decisions.ship_grove_dec(1+length(proc_plants),j)*0.01*total_ora_shipped(1,i);
         shipped_ORA_CAL = decisions.ship_grove_dec(2+length(proc_plants),j)*0.01*total_ora_shipped(2,i);
         shipped_ORA_TEX = decisions.ship_grove_dec(3+length(proc_plants),j)*0.01*total_ora_shipped(3,i);
         shipped_ORA_ARZ = decisions.ship_grove_dec(4+length(proc_plants),j)*0.01*total_ora_shipped(4,i);
         shipped_ORA_BRA = decisions.ship_grove_dec(5+length(proc_plants),j)*0.01*total_ora_shipped(5,i);
         shipped_ORA_SPA = decisions.ship_grove_dec(6+length(proc_plants),j)*0.01*total_ora_shipped(6,i);
         sum_shipped = shipped_ORA_FLA + shipped_ORA_CAL + shipped_ORA_TEX + shipped_ORA_ARZ + ...
                       shipped_ORA_BRA + shipped_ORA_SPA;
         fraction_shipped_futures = decisions.futures_ship_dec(storage_open(j));
         monthly_amt_shipped = futures_arr_FCOJ*fraction_shipped_futures;
         futures_per_week_FCOJ = zeros(1,48);
         for (i = 1:12)
             futures_per_week_FCOJ(1:4) = [];
             futures_per_week_FCOJ = [futures_per_week_FCOJ repmat(monthly_amt_shipped(i)/4,1,4)];
         end
         demand = getDemand(storage{j});
         storage{j}.iterateWeek(sum_shipped, futures_per_week_FCOJ(i),decisions, proc_plants, demand);
     end
 end

             
     
         
        
    % Transporation costs of shipping for FCOJ futures to storage facilities (input the distance excel file)
    % Transportation costs of shipping for ORA and ORA futures to processing
    % plants and storage

    % Transporation costs of shipping from processing plants to storage
    % facilities

    % Processing plants costs of making FCOJ and POJ
    
    % Reconstitution of FCOJ and update storage plant inventory and cost of
    % that
    
    % Draw demand for that particular week for each region (based on the
    % inventory that's there in the storage facilities of each product)
    % (you also need to figure out which storage facilities are servicing
    % which regions)
    
    % Calculate transportation costs from storage to market for each
    % product (you need to figure out which storages are servicing which
    % areas)
    
    % Calculate sales of all the products for each region
    
    % store information somewhere
    
    % Manage the processing plants and storage plants inventory

end

