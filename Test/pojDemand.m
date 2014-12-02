function [ demand ] = pojDemand(city, POJ_price, region_ind, demand_city_POJ)
    % Get demand for ORA based on city and the price and region
    city_ind = getCityIndex(city);
    percent = demand_city_POJ(city_ind);
    demand = percent*getDemand(2,region_ind,POJ_price);
end