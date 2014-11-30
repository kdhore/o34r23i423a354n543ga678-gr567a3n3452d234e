%constraints for the grove shipping ORA to proc plants and storages. Note
%that the constraints are <= plant requirements.
function [c, ceq] = constraints_grove_ship(x, totalORAdemand)

%Dist_Total 6 x (# procs + # storages)
%x -- 6 x (# procs + # storages)
%totalORAdemand  (1 x  (# procs + # storages)


%sum decisions across all groves; each col corresponds to sending to a
%particular processing plant or storage unit. 
%x is now 1 x (# procs + # storages)
x = sum(x,1); 


c = []; 
%Can you subtract elements in arrays for constraints?
ceq = [x(1,:) - totalORAdemand(1,:)];
end

