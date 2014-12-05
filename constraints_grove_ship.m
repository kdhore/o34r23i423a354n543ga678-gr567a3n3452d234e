%constraints for the grove shipping ORA to proc plants and storages.
function [c, ceq] = constraints_grove_ship(x, totalORAdemand, storCapacities)

%x -- 6 x (# storages)
%totalORAdemand  sized 1 x (#stor)


%sum decisions across all groves; each col now corresponds to sending to a
%particular storage unit. 
%x is now 1 x (# storages)
x = sum(x,1); 


c = [-x(1,:); totalORAdemand(1,:) - x(1,:); x(1,:) - storCapacities(1,:)]; % <= 0 
%constraint: all x >= 0
%constraint: ORA sent >= ORA demanded. 
%constraint: ORA sent <= capacity of the storage unit
ceq = [];
end

