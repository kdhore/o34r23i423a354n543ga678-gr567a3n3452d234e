classdef storageFacility2 < handle

	properties
		capacity = 0;
		inventory = cell(4,1);
		reconPercent = 0;
		reconC = 0;
		holdC = 0;
        proc_plant;
        cities;
        index;
        proc_num;
	end

	methods
		% constructor
		% inventory as a properly formatted cell array
		% ORA is 5x1
		% POJ is 9x1
		% ROJ is 13x1
		% FCOJ is 49x1
        % proc_plant comes from processing plant class - includes an array
        % of the amount of POJ and FCOJ from processing plants arriving to
        % storage facilities and how old these products are
        
        % Note: If this class should calculate transportation cost from
        % storage to demand, need the cities that this facility services
		function sf = storageFacility2(cap,inventory,rc,hc,rp,index,proc_num)
			sf.inventory = inventory;
			sf.capacity = cap;
			sf.reconC = rc;
			sf.holdC = hc;
			sf.reconPercent = rp;
            sf.index = index;
            sf.proc_num = proc_num;
		end

		function setReconPercent(sf, newPercent)
			sf.reconPercent = newPercent;
		end

		function setReconCost(sf, newReconC)
			sf.reconC = newReconC;
		end

		function setHoldC(sf,newHoldC)
			sf.holdC = newHoldC;
		end

		function addCapacity(sf, newCapacity)
			if (sf.capacity + newCapacity < 0)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'Capacity being sold is larger than available capacity';
				capException = MException(errID, msg);
				throw(capException);
			else	
				sf.capacity = sf.capacity + newCapacity;
			end
		end

		% matsIn as a properly formatted cell array
		% ORA is 5x1
		% POJ is 9x1
		% ROJ is 13x1
		% FCOJ is 49x1
		% simulating one week,
		% ship_out is the amount of each product at each age shipped out
		% sold is the total number of each product sold
		% toss out is everything thrown out due to capacity
		% rotten is everything that rotted
		% demand is how much demand is unfulled
        % sales is the total sales of each product from this storage unit
        % at time t
		% reconCost is cost spent reconstituting
		% holdCost is the cost of holding inventory
		function [ship_out, sold, toss_out, rotten, demand, reconCost, holdCost, revRecieved] = iterateWeek(sf, sum_shipped, futures_per_week_FCOJ,proc_plants, ORA_demand, POJ_demand, FCOJ_demand, ROJ_demand)
			% initialize return variables
			ship_out = cell(4,1);
			sold = zeros(4,1);
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

			avails = zeros(4,1);
            
			% age inventory 1 week
			for i=1:length(sf.inventory)
				m = length(sf.inventory{i});
				for j=m:-1:2
					sf.inventory{i}(j) = sf.inventory{i}(j-1);
				end
				sf.inventory{i}(1) = 0;
				rotten(i) = sf.inventory{i}(m);
            end
            
            % add any reconstituted OJ in last week to inventory (it's okay
            % that we have already aged the inventory one week - last
            % week's rotten inventory wouldn't have been reconstituted, but
            % means we include this week's rotten inventory in the total
            % FCOJ that can be reconstituted)
			FCOJRecon = sum(sf.inventory{4}(1:length(sf.inventory{4}))) * sf.reconPercent;
            sf.inventory{3}(1) = FCOJRecon;
			reconCost = FCOJRecon * sf.reconC;
			for i=2:length(sf.inventory{4})
				sf.inventory{4}(i) = sf.inventory{4}(i)*(1-sf.reconPercent);
            end   
            
			% add in new inventory
            for i = 1:sf.proc_num
                pp = proc_plants{i};
                newInv = pp.shippingSchedule{2};
                % update POJ inventories
                sf.inventory{2}(1) = sf.inventory{2}(1) + newInv{sf.index}.POJ_1week;
                sf.inventory{2}(2) = sf.inventory{2}(2) + newInv{sf.index}.POJ_2week;
                sf.inventory{2}(3) = sf.inventory{2}(3) + newInv{sf.index}.POJ_3week;
                sf.inventory{2}(4) = sf.inventory{2}(4) + newInv{sf.index}.POJ_4week;
                
                % update FCOJ inventories
                sf.inventory{4}(1) = sf.inventory{2}(1) + newInv{sf.index}.FCOJ_1week + ...
                    futures_per_week_FCOJ;
                sf.inventory{4}(2) = sf.inventory{2}(2) + newInv{sf.index}.FCOJ_2week;
                sf.inventory{4}(3) = sf.inventory{2}(3) + newInv{sf.index}.FCOJ_3week;
                sf.inventory{4}(4) = sf.inventory{2}(4) + newInv{sf.index}.FCOJ_4week;
            end
            
            % need to add these two variables to the decision class (easier there than
            % here)
			sf.inventory{1}(1) = sf.inventory{1}(1) + sum_shipped; 
            
			% get how much of each product is available
			for i=1:length(sf.inventory)
				l = length(sf.inventory{i});
				avails(i) = sum(sf.inventory{i}(1:l-1));
            end

			% get the number tossed out
			totalInv = sum(sf.inventory{1}) + sum(sf.inventory{2}) + sum(sf.inventory{3}) + sum(sf.inventory{4});
			overCap = totalInv - sf.capacity;
			i = 1;
			lo = length(sf.inventory{1});
			lp = length(sf.inventory{2});
			lr = length(sf.inventory{3});
			lf = length(sf.inventory{4});

			% for loop to go through products by weeks to expiry
			% various i levels are due to different number of weeks to rot
			% does exclude rotten stuff (why are we excluding this?
			% shouldnt rotten stuff be the first thing we get rid of? if it
			% is, just get rid of the minus ones.. michelle)
			while overCap > 0
				if (i < 5)
					avail = sf.inventory{1}(lo - i) + sf.inventory{2}(lp - i) + sf.inventory{3}(lr - i) + sf.inventory{4}(lf - i);
					if (avail <= overCap) 
						toss_out{1}(lo - i) = sf.inventory{1}(lo - i);
						toss_out{2}(lp - i) = sf.inventory{2}(lp - i);
						toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{1}(lo - i) = 0;
						sf.inventory{2}(lp - i) = 0;
						sf.inventory{3}(lr - i) = 0;
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						toss_out{1}(lo - i) = overCap*sf.inventory{1}(lo - i)/avail;
						toss_out{2}(lp - i) = overCap*sf.inventory{2}(lp - i)/avail;
						toss_out{3}(lr - i) = overCap*sf.inventory{3}(lr - i)/avail;
						toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						sf.inventory{1}(lo - i) = sf.inventory{1}(lo - i) - overCap*sf.inventory{1}(lo - i)/avail;
						sf.inventory{2}(lp - i) = sf.inventory{2}(lp - i) - overCap*sf.inventory{2}(lp - i)/avail;
						sf.inventory{3}(lr - i) = sf.inventory{3}(lr - i) - overCap*sf.inventory{3}(lr - i)/avail;
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				elseif (i < 9)
					avail = sf.inventory{2}(lp - i) + sf.inventory{3}(lr - i) + sf.inventory{4}(lf - i);
					if (avail <= overCap)
						toss_out{2}(lp - i) = sf.inventory{2}(lp - i);
						toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{2}(lp - i) = 0;
						sf.inventory{3}(lr - i) = 0;
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						toss_out{2}(lp - i) = overCap*sf.inventory{2}(lp - i)/avail;
						toss_out{3}(lr - i) = overCap*sf.inventory{3}(lr - i)/avail;
						toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						sf.inventory{2}(lp - i) = sf.inventory{2}(lp - i) - overCap*sf.inventory{2}(lp - i)/avail;
						sf.inventory{3}(lr - i) = sf.inventory{3}(lr - i) - overCap*sf.inventory{4}(lr - i)/avail;
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				elseif (i < 13)
					avail = sf.inventory{3}(lr - i) + sf.inventory{4}(lf - i);
					if (avail <= overCap)
						toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{3}(lr - i) = 0;
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						sf.inventory{3}(lr - i) = sf.inventory{3}(lr - i) - overCap*sf.inventory{3}(lr - i)/avail;
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap*sf.inventory{4}(lf - i)/avail;
						toss_out{3}(lr - i) = overCap*sf.inventory{3}(lr - i)/avail;
						toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				elseif (i < 49)
					avail = sf.inventory{4}(lf - i);
					if (avail <= overCap)
						toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap;
						toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				else
					a = 'debugging needed'
				end
				i = i + 1;
            end
            
            % ship out
            % remove demand from inventory
            % sales is the total demand for each product among all cities 
            % this storage unit services
            demand(1) = ORA_demand;
            demand(2) = POJ_demand;
            demand(3) = ROJ_demand;
            demand(4) = FCOJ_demand;
            for i=1:4
                j = length(sf.inventory{i})-1;
                while ((demand(i) > 0) && (sum(sf.inventory{i}(1:length(sf.inventory{i})-1))) > 0)
                    if (demand(i) > sf.inventory{i}(j))
                        ship_out{i}(j) = sf.inventory{i}(j);
                        demand(i) = demand(i) - sf.inventory{i}(j);
                        sf.inventory{i}(j) = 0;
                    else
                        ship_out{i}(j) = demand(i);
                        sf.inventory{i}(j) = sf.inventory{i}(j) - demand(i);
                        demand(i) = 0;
                    end
                    j = j-1;
                end
                sold(i) = sum(ship_out{i});
            end
            
            % get holding cost
			holdCost = (sum(avails) - sum(sold))*sf.holdC;
		end
	end
end