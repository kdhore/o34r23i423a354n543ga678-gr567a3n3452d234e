function [demand] = getDemand(product_index,region_index,price)
    load('ORA_fits.mat');
    load('POJ_fits.mat');
    load('ROJ_fits.mat');
    load('FCOJ_fits.mat');
    if (product_index == 1)
        coeff_matrix = ORA_fits(region_index,:);
    elseif (product_index == 2)
        coeff_matrix = POJ_fits(region_index,:);
    elseif (product_index == 3)
        coeff_matrix = ROJ_fits(region_index,:);
    elseif (product_index == 4)
        coeff_matrix = FCOJ_fits(region_index,:);
    else
        display('gave wrong product index');
    end
    demand = coeff_matrix.*[1;price;price.^2];
end