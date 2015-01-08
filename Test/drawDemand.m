function [ ORA_demand, POJ_demand, FCOJ_demand, ROJ_demand, big_D, big_P ] = drawDemand(decisions,cities,week,demand_city_ORA, demand_city_POJ, demand_city_ROJ, demand_city_FCOJ, pricesORA, pricesPOJ, pricesROJ, pricesFCOJ)
   %,temp,indicies
% Will return the demand for each city
    ORA_demand = 0;
    POJ_demand = 0;
    FCOJ_demand = 0;
    ROJ_demand = 0;

	  ORA_params = load('Demand Fits/ORA_fits_log.mat');
    POJ_params = load('Demand Fits/POJ_fits_log.mat');
    ROJ_params = load('Demand Fits/ROJ_fits_log.mat');
    FCOJ_params = load('Demand Fits/FCOJ_fits_log.mat');

    ORA_params = ORA_params.ORA_fits;
    POJ_params = POJ_params.POJ_fits;
    ROJ_params = ROJ_params.ROJ_fits;
    FCOJ_params = FCOJ_params.FCOJ_fits;

    %transport_cost = 0;
    big_D = zeros(numel(cities)/3, 4);
    if nargin > 7
        ORA_price = pricesORA(:, ceil(week/4));
        POJ_price = pricesPOJ(:, ceil(week/4));
        FCOJ_price = pricesFCOJ(:, ceil(week/4));
        ROJ_price = pricesROJ(:, ceil(week/4));
    else
        ORA_price = decisions.pricing_ORA_weekly_dec(:,week);
        POJ_price = decisions.pricing_POJ_weekly_dec(:,week);
        FCOJ_price = decisions.pricing_FCOJ_weekly_dec(:,week);
        ROJ_price = decisions.pricing_ROJ_weekly_dec(:,week);
    end
    %big_P = [ORA_price, POJ_price, FCOJ_price, ROJ_price];
    big_P = zeros(numel(cities)/3,4);
    for i = 1:numel(cities)/3
       [region, region_ind] = matchCitytoRegion(cities{i,1});
       ora = oraDemand(cities{i,1}, ORA_price(region_ind), region_ind, demand_city_ORA);
       oraParams = ORA_params{region_ind};
       ora = ora + normrnd(oraParams(1),oraParams(2));
       big_D(i, 1) = big_D(i, 1) + ora; 
       big_P(i,1) = ORA_price(region_ind); 
       
       poj = pojDemand(cities{i,1}, POJ_price(region_ind), region_ind,  demand_city_POJ);
       pojParams = POJ_params{region_ind};
       poj = poj + normrnd(pojParams(1),pojParams(2));
       big_D(i, 2) = big_D(i, 2) + poj;
       big_P(i,2) = POJ_price(region_ind);
       
       fcoj = fcojDemand(cities{i,1}, FCOJ_price(region_ind), region_ind, demand_city_FCOJ);
       fcojParams = FCOJ_params{region_ind};
       fcoj = poj + normrnd(fcojParams(1),fcojParams(2));
       big_D(i, 4) = big_D(i, 3) + fcoj;
       big_P(i,4) = FCOJ_price(region_ind);
       
       roj = rojDemand(cities{i,1}, ROJ_price(region_ind), region_ind, demand_city_ROJ);
       rojParams = ROJ_params{region_ind};
       roj = roj + normrnd(rojParams(1),rojParams(2));
       big_D(i, 3) = big_D(i, 4) + roj;
       big_P(i,3) = ROJ_price(region_ind);
       
       %transport_cost = transport_cost + 1.2*cities{i,3}*(ora+poj+fcoj+roj);
       ORA_demand = ORA_demand + ora;
       POJ_demand = POJ_demand + poj;
       FCOJ_demand = FCOJ_demand + fcoj;
       ROJ_demand = ROJ_demand + roj;
    end
%     ORA_demand = temp.ORA_Sales(2,week);
%     POJ_demand = temp.POJ_Sales(2,week);
%     FCOJ_demand = temp.FCOJ_Sales(2,week);
%     ROJ_demand = temp.ROJ_Sales(2,week);
%     big_D(:,1) = decisions.sales_week_ORA_res(indicies,week);
%     big_D(:,2) = decisions.sales_week_POJ_res(indicies,week);
%     big_D(:,3) = decisions.sales_week_ROJ_res(indicies,week);
%     big_D(:,4) = decisions.sales_week_FCOJ_res(indicies,week);
end