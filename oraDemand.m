function [ demand ] = oraDemand(city, ORA_price, region_ind)
    % Get demand for ORA based on city and the price and region
    city_ind = getCityIndex(city);
    percent = demand_city_ORA(city_ind);
    demand = percent*getDemand('ORA',region_ind,ORA_price);
end

