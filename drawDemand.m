function [ ORA_demand, POJ_demand, FCOJ_demand, ROJ_demand, transport_cost, big_D, big_P ] = drawDemand(decisions,cities,week,demand_city_ORA, demand_city_POJ, demand_city_ROJ, demand_city_FCOJ, temp )
    % Will return the demand for each city
    ORA_demand = 0;
    POJ_demand = 0;
    FCOJ_demand = 0;
    ROJ_demand = 0;
    transport_cost = 0;
    big_D = zeros(7, 4);
    ORA_price = decisions.pricing_ORA_weekly_dec(:,week);
    POJ_price = decisions.pricing_POJ_weekly_dec(:,week);
    FCOJ_price = decisions.pricing_FCOJ_weekly_dec(:,week);
    ROJ_price = decisions.pricing_ROJ_weekly_dec(:,week);
    big_P = [ORA_price, POJ_price, FCOJ_price, ROJ_price];
    for i = 1:numel(cities)/3
       [region, region_ind] = matchCitytoRegion(cities{i,1});
       ora = oraDemand(cities{i,1}, ORA_price(region_ind), region_ind, demand_city_ORA);
       big_D(region_ind, 1) = big_D(region_ind, 1) + ora; 
       
       poj = pojDemand(cities{i,1}, POJ_price(region_ind), region_ind,  demand_city_POJ);
       big_D(region_ind, 2) = big_D(region_ind, 2) + poj;
       
       fcoj = fcojDemand(cities{i,1}, FCOJ_price(region_ind), region_ind, demand_city_FCOJ);
       big_D(region_ind, 4) = big_D(region_ind, 3) + fcoj;
       
       roj = rojDemand(cities{i,1}, ROJ_price(region_ind), region_ind, demand_city_ROJ);
       big_D(region_ind, 3) = big_D(region_ind, 4) + roj;
       
       transport_cost = transport_cost + 1.2*cities{i,3}*(ora+poj+fcoj+roj);
       ORA_demand = ORA_demand + ora;
       POJ_demand = POJ_demand + poj;
       FCOJ_demand = FCOJ_demand + fcoj;
       ROJ_demand = ROJ_demand + roj;
    end
    ORA_demand = temp.ORA_Sales(2,week);
    POJ_demand = temp.POJ_Sales(2,week);
    FCOJ_demand = temp.FCOJ_Sales(2,week);
    ROJ_demand = temp.ROJ_Sales(2,week);
end