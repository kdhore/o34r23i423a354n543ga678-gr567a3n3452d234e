function [ ORA_demand, POJ_demand, FCOJ_demand, ROJ_demand, transport_cost ] = drawDemand(cities)
    % Will return the demand for each city
    ORA_demand = 0;
    POJ_demand = 0;
    FCOJ_demand = 0;
    ROJ_demand = 0;
    for i = 1:numel(cities/3)
       ora = oraDemand(cities{i,1});
       poj = pojDemand(cities{i,1});
       fcoj = fcojDemand(cities{i,1});
       roj = rojDemand(cities{i,1});
       transport_cost = 1.2*cities{i,3}*(ora+poj+fcoj+roj);
       ORA_demand = ORA_demand + ora;
       POJ_demand = POJ_demand + poj;
       FCOJ_demand = FCOJ_demand + fcoj;
       ROJ_demand = ROJ_demand + roj;
    end
end