classdef ProcessingPlant
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
        shipped_out_cost_tank;
        shipped_out_cost_carrier;
        rotten = 0;
        throwaway = 0;
		% other properties tbd
		% upper bound on capacity?
		% tankers?
	end
    
    methods
        function pp = ProcessingPlant(index, capacity, percentPOJ, breakdown, ora, pojC, fcojC, tanker_num, tankerCost, stor_num, shippingSchedule)
            pp.index = index;
            pp.capacity = capacity;
			pp.percentPOJ = percentPOJ;
			pp.percentFCOJ = 100 - percentPOJ;
			pp.ora = ora;
			pp.breakdown = breakdown;
			pp.tankersAvailable = tanker_num; % was just tanker_num before. now inputting tanker status with available, going out, and coming home
			pp.tankerCost = tankerCost;
			pp.pojCost = pojC;
			pp.fcojCost = fcojC;
            pp.stor_num = stor_num;
            pp.poj = 0;
            pp.fcoj = 0;
            pp.tankersHoldC = 0;
            pp.shipped_out_cost_tank = zeros(stor_num,1);
            pp.shipped_out_cost_carrier = zeros(stor_num,1);
            pp.rotten = 0;
            pp.throwaway = 0;
            pp.shippingSchedule = shippingSchedule;          
        end
        
        % the breakdown parameter refers to whether it was broken down in
        % the previous week, so it did not produce any POJ or FCOJ for this
        % week
        function obj = iterateWeek(obj,sum_shipped, decisions, breakdown, storage_open, processing2storage_dist)
      
            obj.poj = 0;
            obj.fcoj = 0;
            obj.tankersHoldC = 0;
            obj.shipped_out_cost_tank = zeros(length(storage_open),1);
            obj.shipped_out_cost_carrier = zeros(length(storage_open),1);
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
                % update the shipping schedule
                for i = 1:1:5
                    obj.shippingSchedule{i} = obj.shippingSchedule{i + 1};
                end
                % Update number of available tankers
                cameHome = obj.shippingSchedule{1};
                for i = 1:obj.stor_num
                    stor_ind = storage_open(i);
                    obj.tankersAvailable = obj.tankersAvailable + cameHome{stor_ind}.Tankers - obj.shippingSchedule{2}{stor_ind}.Tankers;
                end
                obj.tankersHoldC = obj.tankersAvailable*obj.tankerCost;
            % If it isn't broken down...
            else
                % update the shipping schedule
                for i = 1:1:5
                    obj.shippingSchedule{i} = obj.shippingSchedule{i + 1};
                end
                % Update number of available tankers
                cameHome = obj.shippingSchedule{1};
                for i = 1:obj.stor_num
                    stor_ind = storage_open(i);
                    obj.tankersAvailable = obj.tankersAvailable + cameHome{stor_ind}.Tankers - obj.shippingSchedule{2}{stor_ind}.Tankers;
                end
                obj.tankersHoldC = obj.tankersAvailable*obj.tankerCost;
                obj.poj = obj.percentPOJ*sum(obj.ora(1:4))/100.0;
                %pojC = poj*pp.pojCost;
				obj.fcoj = obj.percentFCOJ*sum(obj.ora(1:4))/100.0;
                %fcojC = fcoj*pp.fcojCost;
				obj.ora = zeros(5,1);
                if (obj.poj+obj.fcoj) <= obj.tankersAvailable*30
                    %oneWeek = obj.shippingSchedule{3}{j};            
                    for j = 1:obj.stor_num
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).FCOJ;
                        obj.shippingSchedule{3}{stor}.POJ_1Week = stor_percentPOJ*0.01*obj.poj;
                        obj.shippingSchedule{3}{stor}.FCOJ_1Week = stor_percentFCOJ*0.01*obj.fcoj;
                        obj.shippingSchedule{3}{stor}.Tankers = ceil((stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj)/30);
                        obj.shipped_out_cost_tank(j) = obj.shipped_out_cost_tank(j) + 36*obj.shippingSchedule{3}{stor}.Tankers*processing2storage_dist(storage_open(j),obj.index);
                        
                    end 
                else
                    sent = 0; j = 1;
                    % Allocate as much as possible to tankers
                    %oneWeek = obj.shippingSchedule{3};
                    temp_tankers = obj.tankersAvailable;
                    while temp_tankers > 0
                        stor = storage_open(j);
                        stor_percentPOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).POJ;
                        stor_percentFCOJ = decisions.ship_proc_plant_storage_dec(stor, obj.index).FCOJ;
                        if (stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj) < temp_tankers*30
                           obj.shippingSchedule{3}{stor}.POJ_1Week = stor_percentPOJ*0.01*obj.poj;
                            obj.shippingSchedule{3}{stor}.FCOJ_1Week = stor_percentFCOJ*0.01*obj.fcoj;
                            obj.shippingSchedule{3}{stor}.Tankers = ceil((stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj)/30);
                            obj.shipped_out_cost_tank(j) = obj.shipped_out_cost_tank(j) + 36*obj.shippingSchedule{3}{stor}.Tankers*processing2storage_dist(storage_open(j),obj.index);
                            temp_tankers = temp_tankers - obj.shippingSchedule{3}{stor}.Tankers;
                            sent = sent + stor_percentPOJ*0.01*obj.poj + stor_percentFCOJ*0.01*obj.fcoj;
                            j = j + 1;
                        else
                            tankerAmount = temp_tankers*30;
                            obj.shipped_out_cost_tank(j) = obj.shipped_out_cost_tank(j) + 36*temp_tankers*processing2storage_dist(storage_open(j),obj.index);
                            POJsentviaTanker = (stor_percentPOJ*0.01*obj.poj)/((stor_percentPOJ*0.01*obj.poj) + (stor_percentFCOJ*0.01*obj.fcoj))*tankerAmount;
                            FCOJsentviaTanker = (stor_percentFCOJ*0.01*obj.fcoj)/((stor_percentPOJ*0.01*obj.poj) + (stor_percentFCOJ*0.01*obj.fcoj))*tankerAmount;
                            obj.shippingSchedule{3}{stor}.POJ_1Week = POJsentviaTanker;
                            obj.shippingSchedule{3}{stor}.FCOJ_1Week = FCOJsentviaTanker;
                            obj.shippingSchedule{3}{stor}.Tankers = ceil((POJsentviaTanker + FCOJsentviaTanker)/30);
                            temp_tankers = temp_tankers - obj.shippingSchedule{3}{stor}.Tankers;
                            POJlefttobeSent = stor_percentPOJ*0.01*obj.poj - POJsentviaTanker;
                            FCOJlefttobeSent = stor_percentFCOJ*0.01*obj.fcoj - FCOJsentviaTanker;
                            distance = processing2storage_dist(storage_open(j),obj.index);
                            obj.shipped_out_cost_carrier(j) = obj.shipped_out_cost_carrier(j) + 0.65*(FCOJlefttobeSent+POJlefttobeSent)*distance;
                            if distance < 2000
                                delay = rand;
                                if (delay < 0.09)
                                    %threeWeek = obj.shippingSchedule{5};
                                    obj.shippingSchedule{5}{stor}.POJ_3Week = obj.shippingSchedule{5}{stor}.POJ_3Week + POJlefttobeSent;
                                    obj.shippingSchedule{5}{stor}.FCOJ_3Week = obj.shippingSchedule{5}{stor}.FCOJ_3Week + FCOJlefttobeSent;
                                elseif (delay < 0.3)
                                    %twoWeek = obj.shippingSchedule{4};
                                    obj.shippingSchedule{4}{stor}.POJ_2Week = obj.shippingSchedule{4}{stor}.POJ_2Week + POJlefttobeSent;
                                    obj.shippingSchedule{4}{stor}.FCOJ_2Week = obj.shippingSchedule{4}{stor}.FCOJ_2Week + FCOJlefttobeSent;
                                else 
                                     obj.shippingSchedule{3}{stor}.POJ_1Week =  obj.shippingSchedule{3}{stor}.POJ_1Week + POJlefttobeSent;
                                     obj.shippingSchedule{3}{stor}.FCOJ_1Week =  obj.shippingSchedule{3}{stor}.FCOJ_1Week + FCOJlefttobeSent;
                                end
                                j = j + 1;
                            else
                                delay = rand;
                                if (delay < 0.09)
                                    %fourWeek = obj.shippingSchedule{6};
                                    obj.shippingSchedule{6}{stor}.POJ_4Week = POJlefttobeSent;
                                    obj.shippingSchedule{6}{stor}.FCOJ_4Week = FCOJlefttobeSent;
                                elseif (delay < 0.3)
                                    %threeWeek = obj.shippingSchedule{5};
                                    obj.shippingSchedule{5}{stor}.POJ_3Week = obj.shippingSchedule{5}{stor}.POJ_3Week + POJlefttobeSent;
                                    obj.shippingSchedule{5}{stor}.FCOJ_3Week = obj.shippingSchedule{5}{stor}.FCOJ_3Week + FCOJlefttobeSent;
                                else
                                    %twoWeek = obj.shippingSchedule{4};
                                    obj.shippingSchedule{4}{stor}.POJ_2Week = obj.shippingSchedule{4}{stor}.POJ_2Week + POJlefttobeSent;
                                    obj.shippingSchedule{4}{stor}.FCOJ_2Week = obj.shippingSchedule{4}{stor}.FCOJ_2Week + FCOJlefttobeSent;
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
                        distance = processing2storage_dist(storage_open(j),obj.index);
                        obj.shipped_out_cost_carrier(j) = obj.shipped_out_cost_carrier(j) + 0.65*distance*(FCOJtobeSent+POJtobeSent);
                        if distance < 2000
                           delay = rand;
                           if (delay < 0.09)
                               %threeWeek = obj.shippingSchedule{5};
                               obj.shippingSchedule{5}{stor}.POJ_3Week = obj.shippingSchedule{5}{stor}.POJ_3Week + POJtobeSent;
                               obj.shippingSchedule{5}{stor}.FCOJ_3Week = obj.shippingSchedule{5}{stor}.FCOJ_3Week + FCOJtobeSent;
                           elseif (delay < 0.3)
                               %twoWeek = obj.shippingSchedule{4};
                               obj.shippingSchedule{4}{stor}.POJ_2Week = obj.shippingSchedule{4}{stor}.POJ_2Week + POJtobeSent;
                               obj.shippingSchedule{4}{stor}.FCOJ_2Week = obj.shippingSchedule{4}{stor}.FCOJ_2Week + FCOJtobeSent;
                            else 
                               obj.shippingSchedule{3}{stor}.POJ_1Week = obj.shippingSchedule{3}{stor}.POJ_1Week + POJtobeSent;
                               obj.shippingSchedule{3}{stor}.FCOJ_1Week = obj.shippingSchedule{3}{stor}.FCOJ_1Week + FCOJtobeSent;
                            end
                            j = j + 1;
                         else
                            delay = rand;
                            if (delay < 0.09)
                               %fourWeek = obj.shippingSchedule{6};
                               obj.shippingSchedule{6}{stor}.POJ_4Week = POJtobeSent;
                               obj.shippingSchedule{6}{stor}.FCOJ_4Week = FCOJtobeSent;
                            elseif (delay < 0.3)
                               %threeWeek = obj.shippingSchedule{5};
                               obj.shippingSchedule{5}{stor}.POJ_3Week = obj.shippingSchedule{5}{stor}.POJ_3Week + POJtobeSent;
                               obj.shippingSchedule{5}{stor}.FCOJ_3Week = obj.shippingSchedule{5}{stor}.FCOJ_3Week + FCOJtobeSent;
                            else
                               %twoWeek = obj.shippingSchedule{4};
                               obj.shippingSchedule{4}{stor}.POJ_2Week = obj.shippingSchedule{4}{stor}.POJ_2Week + POJtobeSent;
                               obj.shippingSchedule{4}{stor}.FCOJ_2Week = obj.shippingSchedule{4}{stor}.FCOJ_2Week + FCOJtobeSent;
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

