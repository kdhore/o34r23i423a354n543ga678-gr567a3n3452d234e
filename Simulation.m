function [ results ] = Simulation(OJgameobj, decisions)
%NOTE: WE ACTUALLY NEED TO DO THIS BY CITY, NOT BY REGION BECAUSE
% DIFFERENT STORAGES CAN SERVE TO DIFFERENT CITIES WITHIN THE SAME REGION

% Take inventory and other information from OJGameobj and initilize
% facilities

% Draw grove prices matrix, fx grove => US$ prices, and use actual 
% quantity purchased and the purchasing cost

% Iterate over each week and for each week do the following

    % Transporation costs of shipping for FCOJ futures to storage facilities (input the distance excel file)
    % Transportation costs of shipping for ORA and ORA futures to processing
    % plants and storage

    % Transporation costs of shipping from processing plants to storage
    % facilities

    % Processing plants costs of making FCOJ and POJ
    
    % Reconstitution of FCOJ and update storage plant inventory and cost of
    % that
    
    % Draw demand for that particular week for each region (based on the
    % inventory that's there in the storage facilities of each product)
    % (you also need to figure out which storage facilities are servicing
    % which regions)
    
    % Calculate transportation costs from storage to market for each
    % product (you need to figure out which storages are servicing which
    % areas)
    
    % Calculate sales of all the products for each region
    
    % store information somewhere
    
    % Manage the processing plants and storage plants inventory

end

