%This is the objective function for grove shipping to both processing
%plants and storages (ORA only).

function [f] = grove_ship_network(x, mean_grove_prices,Dist_Total)

%grove prices 6x1
%Dist_Total 6 x (# procs + # storages)
%x -- 6 x (# procs + # storages)

xtemp = zeros(size(Dist_Total));
for i = 1:6
    xtemp(i,:) = mean_grove_prices(i,:);
end
%xtemp now same dimensions as x, and thus can multiply x

f = xtemp.*x.*Dist_Total;
%objective function is the product of prices by each of the decisions (aka
%the amount to allocate to each place) times the distance of each
%respective place

end

