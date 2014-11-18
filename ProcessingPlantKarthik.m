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
		% other properties tbd
		% upper bound on capacity?
		% tankers?
	end
    
    methods
        function pp = processingPlant(index, capacity, percentPOJ, breakdown, ora, pojC, fcojC, tankers, tankerCost, stor_num)
            schedule = struct('POJ_1Week', nan, 'POJ_2Week', nan, 'POJ_3Week', nan, 'POJ_4Week', nan, ...
                              'FCOJ_1Week', nan, 'FCOJ_2Week', nan,'FCOJ_3Week', nan, 'FCOJ_4Week', nan,...
                              'Tankers', nan, 'Carriers', nan);
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
        function [ship_out, toss_out, rotten, pojC, fcojC, tankersHoldC] = iterateWeek(pp,sum_shipped, decisions, breakdown, storage_open)
           
            ship_out = cell(4,1);
			toss_out = cell(4,1);
			rotten = zeros(4,1);

			toss_out{1} = zeros(4,1);
			toss_out{2} = zeros(8,1);
			toss_out{3} = zeros(12,1);
			toss_out{4} = zeros(48,1);

			ship_out{1} = zeros(4,1);
			ship_out{2} = zeros(8,1);
			ship_out{3} = zeros(12,1);
			ship_out{4} = zeros(48,1);
            
			% adding newly recieved products to inventory
            if breakdown == 1
                 % aging inventory
                for i=5:-1:2
                    pp.ora(i) = pp.ora(i-1);
                end
                pp.ora(1) = sum_shipped;
                rotten = pp.ora(5);
                throwaway = max(sum(pp.ora(1:4))-pp.capacity,0);
                over = throwaway;
			% tossing out anything over capacity in order of first to rot
                i = 4;
                while over > 0
                    if pp.ora(i) > over
                        pp.ora(i) = pp.ora(i) - over;
                        over = 0;
                    else
                        over = over - pp.ora(i);
                        pp.ora(i) = 0;
                    end
                    i = i - 1;
                end
                % Update number of available tankers
                cameHome = pp.shippingSchedule{1};
                for i = 1:pp.stor_num
                    pp.tankersAvailable = pp.tankersAvailable + cameHome{i}.Tankers;
                end
                % update the shipping schedule
                for i = 1:1:5
                    pp.shippingSchedule{i} = pp.shippingSchedule{i + 1};
                end
                
            % If it isn't broken down...
            else
                % Update number of available tankers
                cameHome = pp.shippingSchedule{1};
                for i = 1:pp.stor_num    
                    pp.tankersAvailable = pp.tankersAvailable + cameHome{i}.Tankers;
                end
                % update the shipping schedule
                for i = 1:1:5
                    pp.shippingSchedule{i} = pp.shippingSchedule{i + 1};
                end
                poj = pp.percentPOJ*sum(pp.ora(1:4))/100.0;
                poj
				fcoj = pp.percentFCOJ*sum(pp.ora(1:4))/100.0;
				pp.ora = zeros(5,1);
                if (poj+fcoj) <= pp.tankersAvailable*30
                    oneWeek = pp.shippingSchedule{3};            
                    for j = 1:num_stor
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, pp.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, pp.index).FCOJ;
                        oneWeek{j}.POJ_1Week = stor_percentPOJ*0.01*poj;
                        oneWeek{j}.FCOJ_1Week = stor_percentFCOJ*0.01*fcoj;
                        oneWeek{j}.Tankers = ceil((stor_percentPOJ*0.01*poj + stor_percentFCOJ*0.01*fcoj)/30);
                        pp.tankersAvailable = pp.tankersAvailable - oneWeek{j}.Tankers;
                    end 
                else
                    overflow = poj+fcoj - pp.tankersAvailable*30;
                    sent = 0; j = 1;
                    % Allocate as much as possible to tankers
                    oneWeek = pp.shippingSchedule{3};
                    while pp.tankersAvailable > 0       
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, pp.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, pp.index).FCOJ;
                        if (stor_percentPOJ*0.01*poj + stor_percentFCOJ*0.01*fcoj) < pp.tankersAvailable*30
                            oneWeek{j}.POJ_1Week = stor_percentPOJ*0.01*poj;
                            oneWeek{j}.FCOJ_1Week = stor_percentFCOJ*0.01*fcoj;
                            oneWeek{j}.Tankers = ceil((stor_percentPOJ*0.01*poj + stor_percentFCOJ*0.01*fcoj)/30);
                            pp.tankersAvailable = pp.tankersAvailable - oneWeek{j}.Tankers;
                            sent = sent + stor_percentPOJ*0.01*poj + stor_percentFCOJ*0.01*fcoj;
                            j = j + 1;
                        else
                            tankerAmount = pp.tankersAvailable*30;
                            POJsentviaTanker = (stor_percentPOJ*0.01*poj)/((stor_percentPOJ*0.01*poj) + (stor_percentFCOJ*0.01*fcoj))*tankerAmount;
                            FCOJsentviaTanker = (stor_percentFCOJ*0.01*fcoj)/((stor_percentPOJ*0.01*poj) + (stor_percentFCOJ*0.01*fcoj))*tankerAmount;
                            oneWeek{j}.POJ_1Week = POJsentviaTanker;
                            oneWeek{j}.FCOJ_1Week = FCOJsentviaTanker;
                            oneWeek{j}.Tankers = ceil((POJsentviaTanker + FCOJsentviaTanker)/30);
                            pp.tankersAvailable = pp.tankersAvailable - oneWeek{j}.Tankers;
                            POJlefttobeSent = stor_percentPOJ*0.01*poj - POJsentviaTanker;
                            FCOJlefttobeSent = stor_percentFCOJ*0.01*fcoj - POJsentviaTanker;
                            distance = findPlant2StorageDist(char(plantNamesInUse(pp.index)),char(storageNamesInUse(storage_open(j))));
                            if distance < 2000
                                delay = rand;
                                if (delay < 0.09)
                                    threeWeek = pp.shippingSchedule{5};
                                    threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJlefttobeSent;
                                    threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJlefttobeSent;
                                elseif (delay < 0.3)
                                    twoWeek = pp.shippingSchedule{4};
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
                                    fourWeek = pp.shippingSchedule{6};
                                    fourWeek{j}.POJ_4Week = POJlefttobeSent;
                                    fourWeek{j}.FCOJ_4Week = FCOJlefttobeSent;
                                elseif (delay < 0.3)
                                    threeWeek = pp.shippingSchedule{5};
                                    threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJlefttobeSent;
                                    threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJlefttobeSent;
                                else
                                    twoWeek = pp.shippingSchedule{4};
                                    twoWeek{j}.POJ_2Week = twoWeek{j}.POJ_2Week + POJlefttobeSent;
                                    twoWeek{j}.FCOJ_2Week = twoWeek{j}.FCOJ_2Week + FCOJlefttobeSent;
                                end
                                j = j + 1;
                            end
                          
                        end
                    end
                    % Allocate the remaining flow to independent carriers
                    while j <= num_stor
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, pp.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, pp.index).FCOJ;
                        POJtobeSent = stor_percentPOJ*0.01*poj;
                        FCOJtobeSent = stor_percentFCOJ*0.01*fcoj;
                        distance = findPlant2StorageDist(char(plantNamesInUse(pp.index)),char(storageNamesInUse(storage_open(j))));
                        if distance < 2000
                           delay = rand;
                           if (delay < 0.09)
                               threeWeek = pp.shippingSchedule{5};
                               threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJtobeSent;
                               threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJtobeSent;
                           elseif (delay < 0.3)
                               twoWeek = pp.shippingSchedule{4};
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
                               fourWeek = pp.shippingSchedule{6};
                               fourWeek{j}.POJ_4Week = POJtobeSent;
                               fourWeek{j}.FCOJ_4Week = FCOJtobeSent;
                            elseif (delay < 0.3)
                               threeWeek = pp.shippingSchedule{5};
                               threeWeek{j}.POJ_3Week = threeWeek{j}.POJ_3Week + POJtobeSent;
                               threeWeek{j}.FCOJ_3Week = threeWeek{j}.FCOJ_3Week + FCOJtobeSent;
                            else
                               twoWeek = pp.shippingSchedule{4};
                               twoWeek{j}.POJ_2Week = twoWeek{j}.POJ_2Week + POJtobeSent;
                               twoWeek{j}.FCOJ_2Week = twoWeek{j}.FCOJ_2Week + FCOJtobeSent;
                            end
                            j = j + 1;
                         end
                    end
                end
                % aging inventory
                for i=5:-1:2
                    pp.ora(i) = pp.ora(i-1);
                end
                % adding newly recieved products to inventory
                if breakdown == 1
                    pp.ora(1) = sum_shipped;
                    rotten = pp.ora(5);
                    throwaway = max(sum(pp.ora(1:4))-pp.capacity,0);
                    over = throwaway;
                % tossing out anything over capacity in order of first to rot
                    i = 4;
                    while over > 0
                        if pp.ora(i) > over
                            pp.ora(i) = pp.ora(i) - over;
                            over = 0;
                        else
                            over = over - pp.ora(i);
                            pp.ora(i) = 0;
                        end
                        i = i - 1;
                    end
                end
            end
        end
    end   
end

