%constraints for the grove shipping ORA to proc plants and storages. Note
%that the constraints are <= plant requirements.
function [c, ceq] = constraints_grove_ship(x, totalORAdemand)

%x -- 6 x (# procs + # storages)
%totalORAdemand  (1 x  (# procs + # storages)


%sum decisions across all groves; each col now corresponds to sending to a
%particular processing plant or storage unit. 
%x is now 1 x (# procs + # storages)
x1 = sum(x,1); 


c = [-x1(1,:)]; 
%constraint: ORA sent = ORA demanded. all x >= 0
ceq = [totalORAdemand(1,:) - x1(1,:)];
end

