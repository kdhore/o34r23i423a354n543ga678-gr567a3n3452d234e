classdef ProcessingPlantKarthik
    %Processing Plant class
    
    properties
        index = 0;
		capacity = 0;
		percentPOJ = 0;
		percentFCOJ = 0;
		% 1-4 are that number of weeks in the plant, 5 is rotten
		ora = zeros(5,1); % had to hardcode, working on modularizing
		breakdown = 0;
		fcojCost = 0;
		pojCost = 0;
		tankersAvailable = 0;
		tankerCost = 0;
        shippingSchedule = cell(1,6);
        stor_num;
        poj = 0;
        fcoj = 0;
        tankersHoldC = 0;
        shipped_out_cost_tank = 0;
        shipped_out_cost_carrier = 0;
        rotten = 0;
        throwaway = 0;
		% other properties tbd
		% upper bound on capacity?
		% tankers?
	end
    
    methods
        function pp = ProcessingPlantKarthik(index, capacity, percentPOJ, breakdown, ora, pojC, fcojC, tankers, tankerCost, stor_num)
            schedule = struct('POJ_1Week', 0, 'POJ_2Week', 0, 'POJ_3Week', 0, 'POJ_4Week', 0, ...
                              'FCOJ_1Week', 0, 'FCOJ_2Week', 0,'FCOJ_3Week', 0, 'FCOJ_4Week', 0,...
                              'Tankers', 0, 'Carriers', 0);
            pp.index = index;
            pp.capacity = capacity;
			pp.percentPOJ = percentPOJ;
			pp.percentFCOJ = 100 - percentPOJ;
			pp.ora = ora;
			pp.breakdown = breakdown;
			pp.tankersAvailable = tankers;
			pp.tankerCost = tankerCost;
			pp.pojCost = pojC;
			pp.fcojCost = fcojC;
            storage_schedule = cell(1, stor_num);
            pp.stor_num = stor_num;
            pp.poj = 0;
            pp.fcoj = 0;
            pp.tankersHoldC = 0;
            pp.shipped_out_cost_tank = 0;
            pp.shipped_out_cost_carrier = 0;
            pp.rotten = 0;
            pp.throwaway = 0;
            for i = 1:stor_num
                storage_schedule{i} = schedule;
            end
            for i = 1:6
                pp.shippingSchedule{i} = storage_schedule;
            end
        end
        
        % the breakdown parameter refers to whether it was broken down in
        % the previous week, so it did not produce any POJ or FCOJ for this
        % week
        function obj = iterateWeek(obj,sum_shipped, decisions, breakdown, storage_open)
            obj.poj = 0;
            obj.fcoj = 0;
            obj.tankersHoldC = 0;
            obj.shipped_out_cost_tank = 0;
            obj.shipped_out_cost_carrier = 0;
            obj.rotten = 0;
            obj.throwaway = 0;
            %pojC = 0;
            %fcojC = 0;
			% adding newly recieved products to inventory
            if breakdown == 1
                 % aging inventory
                for i=5:-1:2
                    obj.ora(i) = obj.ora(i-1);
                end
                obj.ora(1) = sum_shipped;
                obj.rotten = obj.ora(5);
                obj.throwaway = max(sum(obj.ora(1:4))-obj.capacity,0);
                over = obj.throwaway;
			% tossing out anything over capacity in order of first to rot
                i = 4;
                while over > 0
                    if obj.ora(i) > over
                        obj.ora(i) = obj.ora(i) - over;
                        over = 0;
                    else
                        over = over - obj.ora(i);
                        obj.ora(i) = 0;
                    end
                    i = i - 1;
                end
                % Update number of available tankers
                cameHome = obj.shippingSchedule{1};
                for i = 1:obj.stor_num
                    obj.tankersAvailable = obj.tankersAvailable + cameHome{i}.Tankers;
                end
                % update the shipping schedule
                for i = 1:1:5
                    obj.shippingSchedule{i} = obj.shippingSchedule{i + 1};
                end
                
            % If it isn't broken down...
            else
                % Update number of available tankers
                cameHome = obj.shippingSchedule{1};
                for i = 1:obj.stor_num    
                    obj.tankersAvailable = obj.tankersAvailable + cameHome{i}.Tankers;
                end
                % update the shipping schedule
                for i = 1:1:5
                    obj.shippingSchedule{i} = obj.shippingSchedule{i + 1};
                end
                obj.poj = obj.percentPOJ*sum(obj.ora(1:4))/100.0;
                %pojC = poj*pp.pojCost;
				obj.fcoj = obj.percentFCOJ*sum(obj.ora(1:4))/100.0;
                %fcojC = fcoj*pp.fcojCost;
				obj.ora = zeros(5,1);
                if (obj.poj+obj.fcoj) <= obj.tankersAvailable*30
                    oneWeek = obj.shippingSchedule{3};            
                    for j = 1:obj.stor_num
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).FCOJ;
                        oneWeek{j}.POJ_1Week = stor_percentPOJ*0.01*obj.poj;
                        oneWeek{j}.FCOJ_1Week = stor_percentFCOJ*0.01*obj.fcoj;
                        oneWeek{j}.Tankers = ceil((stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj)/30);
                        obj.shipped_out_cost_tank = obj.shipped_out_cost_tank + 36*oneWeek{j}.Tankers*findPlant2StorageDist(char(plantNamesInUse(obj.index)),char(storageNamesInUse(storage_open(j))));
                        obj.tankersAvailable = obj.tankersAvailable - oneWeek{j}.Tankers;
                        obj.tankersHoldC = obj.tankersAvailable*obj.tankerCost;
                    end 
                else
                    obj.overflow = obj.poj+obj.fcoj - obj.tankersAvailable*30;
                    sent = 0; j = 1;
                    % Allocate as much as possible to tankers
                    oneWeek = obj.shippingSchedule{3};
                    while obj.tankersAvailable > 0       
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).FCOJ;
                        if (stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj) < obj.tankersAvailable*30
                            oneWeek{j}.POJ_1Week = stor_percentPOJ*0.01*obj.poj;
                            oneWeek{j}.FCOJ_1Week = stor_percentFCOJ*0.01*obj.fcoj;
                            oneWeek{j}.Tankers = ceil((stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj)/30);
                            obj.shipped_out_cost_tank = obj.shipped_out_cost_tank + 36*oneWeek{j}.Tankers*findPlant2StorageDist(char(plantNamesInUse(obj.index)),char(storageNamesInUse(storage_open(j))));
                            obj.tankersAvailable = obj.tankersAvailable - oneWeek{j}.Tankers;
                            sent = sent + stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj;
                            j = j + 1;
                        else
                            tankerAmount = obj.tankersAvailable*30;
                            shipped_out_cost_tanker = shipped_out_cost_tanker + 36*obj.tankersAvailable*findPlant2StorageDist(char(plantNamesInUse(obj.index)),char(storageNamesInUse(storage_open(j))));
                            POJsentviaTanker = (stor_percentPOJ*0.01*obj.poj)/((stor_percentPOJ*0.01*obj.poj) + (stor_percentFCOJ*0.01*obj.fcoj))*tankerAmount;
                            FCOJsentviaTanker = (stor_percentFCOJ*0.01*obj.fcoj)/((stor_percentPOJ*0.01*obj.poj) + (stor_percentFCOJ*0.01*obj.fcoj))*tankerAmount;
                            oneWeek{j}.POJ_1Week = POJsentviaTanker;
                            oneWeek{j}.FCOJ_1Week = FCOJsentviaTanker;
                            oneWeek{j}.Tankers = ceil((POJsentviaTanker + FCOJsentviaTanker)/30);
                            obj.tankersAvailable = obj.tankersAvailable - oneWeek{j}.Tankers;
                            POJlefttobeSent = stor_percentPOJ*0.01*obj.poj - POJsentviaTanker;
                            FCOJlefttobeSent = stor_percentFCOJ*0.01*obj.fcoj - POJsentviaTanker;
                            distance = findPlant2StorageDist(char(plantNamesInUse(obj.index)),char(storageNamesInUse(storage_open(j))));
                            shipped_out_cost_carriers = shipped_out_cost_carriers + 0.65*(FCOJlefttobeSent+POJlefttobeSent)*distance;
                            if distance < 2000
                                delay = rand;
                                if (delay < 0.09)
                                    threeWeek = obj.shippingSchedule{5};
                                    threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJlefttobeSent;
                                    threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJlefttobeSent;
                                elseif (delay < 0.3)
                                    twoWeek = obj.shippingSchedule{4};
                                    twoWeek{j}.POJ_2Week = twoWeek{j}.POJ_2Week + POJlefttobeSent;
                                    twoWeek{j}.FCOJ_2Week = twoWeek{j}.FCOJ_2Week + FCOJlefttobeSent;
                                else 
                                    oneWeek{j}.POJ_1Week = oneWeek{j}.POJ_1Week + POJlefttobeSent;
                                    oneWeek{j}.FCOJ_1Week = oneWeek{j}.FCOJ_1Week + FCOJlefttobeSent;
                                end
                                j = j + 1;
                            else
                                delay = rand;
                                if (delay < 0.09)
                                    fourWeek = obj.shippingSchedule{6};
                                    fourWeek{j}.POJ_4Week = POJlefttobeSent;
                                    fourWeek{j}.FCOJ_4Week = FCOJlefttobeSent;
                                elseif (delay < 0.3)
                                    threeWeek = obj.shippingSchedule{5};
                                    threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJlefttobeSent;
                                    threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJlefttobeSent;
                                else
                                    twoWeek = obj.shippingSchedule{4};
                                    twoWeek{j}.POJ_2Week = twoWeek{j}.POJ_2Week + POJlefttobeSent;
                                    twoWeek{j}.FCOJ_2Week = twoWeek{j}.FCOJ_2Week + FCOJlefttobeSent;
                                end
                                j = j + 1;
                            end
                          
                        end
                    end
                    % Allocate the remaining flow to independent carriers
                    while j <= obj.stor_num
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).FCOJ;
                        POJtobeSent = stor_percentPOJ*0.01*obj.poj;
                        FCOJtobeSent = stor_percentFCOJ*0.01*obj.fcoj;
                        distance = findPlant2StorageDist(char(plantNamesInUse(obj.index)),char(storageNamesInUse(storage_open(j))));
                        obj.shipped_out_cost_carrier = obj.shipped_out_cost_carrier + 0.65*distance*(FCOJtobeSent+POJtobeSent);
                        if distance < 2000
                           delay = rand;
                           if (delay < 0.09)
                               threeWeek = obj.shippingSchedule{5};
                               threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJtobeSent;
                               threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJtobeSent;
                           elseif (delay < 0.3)
                               twoWeek = obj.shippingSchedule{4};
                               twoWeek{j}.POJ_2Week = twoWeek{j}.POJ_2Week + POJtobeSent;
                               twoWeek{j}.FCOJ_2Week = twoWeek{j}.FCOJ_2Week + FCOJtobeSent;
                            else 
                               oneWeek{j}.POJ_1Week = oneWeek{j}.POJ_1Week + POJtobeSent;
                               oneWeek{j}.FCOJ_1Week = oneWeek{j}.FCOJ_1Week + FCOJtobeSent;
                            end
                            j = j + 1;
                         else
                            delay = rand;
                            if (delay < 0.09)
                               fourWeek = obj.shippingSchedule{6};
                               fourWeek{j}.POJ_4Week = POJtobeSent;
                               fourWeek{j}.FCOJ_4Week = FCOJtobeSent;
                            elseif (delay < 0.3)
                               threeWeek = obj.shippingSchedule{5};
                               threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJtobeSent;
                               threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJtobeSent;
                            else
                               twoWeek = obj.shippingSchedule{4};
                               twoWeek{j}.POJ_2Week = twoWeek{j}.POJ_2Week + POJtobeSent;
                               twoWeek{j}.FCOJ_2Week = twoWeek{j}.FCOJ_2Week + FCOJtobeSent;
                            end
                            j = j + 1;
                         end
                    end
                end
                % aging inventory
                for i=5:-1:2
                    obj.ora(i) = obj.ora(i-1);
                end
                % adding newly recieved products to inventory
                obj.ora(1) = sum_shipped;
                obj.rotten = obj.ora(5);
                obj.throwaway = max(sum(obj.ora(1:4))-obj.capacity,0);
                over = obj.throwaway;
                % tossing out anything over capacity in order of first to rot
                i = 4;
                while over > 0
                     if obj.ora(i) > over
                         obj.ora(i) = obj.ora(i) - over;
                         over = 0;
                     else
                         over = over - obj.ora(i);
                         obj.ora(i) = 0;
                     end
                     i = i - 1;
                end
            end
        end
    end   
end

