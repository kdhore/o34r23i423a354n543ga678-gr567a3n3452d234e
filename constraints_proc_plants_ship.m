%constraints for the grove shipping ORA to proc plants and storages. Note
%that the constraints are <= plant requirements.
function [c, ceq] = constraints_proc_plants_ship(x, productDemand)

%x -- # procs x # storages
%productDemand  (1 x # storages)


%sum decisions across all procs; each col now corresponds to sending to a
%storage unit. 
%x is now 1 x # storages
x = sum(x,1); 


c = [-x(1,:)]; %constraint: all shipments >= 0
%constraint: product sent = product demanded
ceq = [productDemand(1,:) - x(1,:)];
end

