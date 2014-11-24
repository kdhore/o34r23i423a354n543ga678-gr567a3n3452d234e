function [demand] = getDemand(product_index,region_index,price)
    ORA_unCfits = load('ORA_fits.mat');
    ora_fit = genvarname('ORA_fits');
    ORA_unCfits = ORA_unCfits.(ora_fit);
    POJ_unCfits = load('POJ_fits.mat');
    poj_fit = genvarname('POJ_fits');
    POJ_unCfits = POJ_unCfits.(poj_fit);
    ROJ_unCfits = load('ROJ_fits.mat');
    roj_fit = genvarname('ROJ_fits');
    ROJ_unCfits = ROJ_unCfits.(roj_fit);
    FCOJ_unCfits = load('FCOJ_fits.mat');
    fcoj_fit = genvarname('FCOJ_fits');
    FCOJ_unCfits = FCOJ_unCfits.(fcoj_fit);
    if (product_index == 1)
        coeff_matrix = ORA_unCfits(region_index,:);
    elseif (product_index == 2)
        coeff_matrix = POJ_unCfits(region_index,:);
    elseif (product_index == 3)
        coeff_matrix = ROJ_unCfits(region_index,:);
    elseif (product_index == 4)
        coeff_matrix = FCOJ_unCfits(region_index,:);
    else
        display('gave wrong product index');
    end
    demand = (sum(coeff_matrix.*[price.^2,price,1]))/4;
end