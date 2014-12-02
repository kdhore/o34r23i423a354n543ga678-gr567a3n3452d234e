function [ demand ] = rojDemand(city, ROJ_price, region_ind, demand_city_ROJ)
    % Get demand for ROJ based on city and the price and region
    city_ind = getCityIndex(city);
    percent = demand_city_ROJ(city_ind);
    demand = percent*getDemand(3,region_ind,ROJ_price);
end