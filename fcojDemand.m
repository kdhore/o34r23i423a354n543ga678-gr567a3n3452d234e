function [ demand ] = fcojDemand(city, FCOJ_price, region_ind, demand_city_FCOJ)
    % Get demand for FCOJ based on city and the price and region
    city_ind = getCityIndex(city);
    percent = demand_city_FCOJ(city_ind);
    demand = percent*getDemand(4,region_ind,FCOJ_price);
end