classdef storageFacility2v2 < handle

	properties
		capacity;
		inventory = cell(4,1);
		reconPercent;
		reconC;
		holdC;
        proc_plant;
        roj_temp;
        %cities;
        index;
        proc_num;
        rp;
        ship_out;
        sold;
        toss_out;
        cum_toss_out;
        rotten;
        excessDemand; 
        ROJman; 
        holdCost; 
        revReceived; 
        transCost;
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
		function sf = storageFacility2v2(cap,inventory,rc,hc,rp,index,proc_num)
			sf.inventory{1} = [inventory.ORA];
            sf.inventory{2} = [inventory.POJ];
            sf.inventory{3} = [inventory.ROJ];
            sf.inventory{4} = [inventory.FCOJ];
			sf.capacity = cap;
			sf.reconC = rc;
			sf.holdC = hc;
			sf.reconPercent = rp;
            sf.index = index;
            sf.proc_num = proc_num;
            sf.ship_out = cell(4,1);
            sf.sold = zeros(4,1);
            sf.toss_out = cell(4,1);
            sf.cum_toss_out = zeros(4,1);
            sf.rotten = zeros(4,1);
            sf.excessDemand = 0; 
            sf.ROJman = 0; 
            sf.holdCost = 0; 
            sf.revReceived = zeros(4,1); 
            sf.transCost = 0;
            sf.roj_temp = zeros(48,1);
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
		% reconCost is cost spent reconstituting
		% holdCost is the cost of holding inventory
		function sf = iterateWeek(sf, sum_shipped, futures_per_week_FCOJ,proc_plants, big_D, big_P, time, ORA_demand, POJ_demand, FCOJ_demand, ROJ_demand, cities, sim_index)
			% initialize return variables
			sf.sold = zeros(4,1);
			sf.rotten = zeros(4,1);

			sf.toss_out{1} = zeros(4,1);
			sf.toss_out{2} = zeros(8,1);
			sf.toss_out{3} = zeros(12,1);
			sf.toss_out{4} = zeros(48,1);

			sf.ship_out{1} = zeros(4,1);
			sf.ship_out{2} = zeros(8,1);
			sf.ship_out{3} = zeros(12,1);
			sf.ship_out{4} = zeros(48,1);

			avails = zeros(4,1);
            sf.revReceived = zeros(4,1);
            
            % get how much is rotten this week
            for i=1:length(sf.inventory)
                sf.rotten(i) = sf.inventory{i}(length(sf.inventory{i}));
            end
            
			% add in new inventory
            for i = 1:sf.proc_num
                pp = proc_plants{i};
                newInv = pp.shippingSchedule{2};
                % update POJ inventories
                sf.inventory{2}(1) = sf.inventory{2}(1) + newInv{sim_index}.POJ_1Week;
                sf.inventory{2}(2) = sf.inventory{2}(2) + newInv{sim_index}.POJ_2Week;
                sf.inventory{2}(3) = sf.inventory{2}(3) + newInv{sim_index}.POJ_3Week;
                sf.inventory{2}(4) = sf.inventory{2}(4) + newInv{sim_index}.POJ_4Week;
                
                % update FCOJ inventories
                sf.inventory{4}(1) = sf.inventory{4}(1) + newInv{sim_index}.FCOJ_1Week + ...
                    futures_per_week_FCOJ;
                sf.inventory{4}(2) = sf.inventory{4}(2) + newInv{sim_index}.FCOJ_2Week;
                sf.inventory{4}(3) = sf.inventory{4}(3) + newInv{sim_index}.FCOJ_3Week;
                sf.inventory{4}(4) = sf.inventory{4}(4) + newInv{sim_index}.FCOJ_4Week;
            end
            
            for i = 2:length(sf.inventory{4})
                sf.inventory{4}(i) = sf.inventory{4}(i) - sf.roj_temp(i-1);
            end
            
			sf.inventory{1}(1) = sf.inventory{1}(1) + sum_shipped;
            sf.inventory{3}(1) = sf.inventory{3}(1) + sum(sf.roj_temp);
            
			% get how much of each product is available
			for i=1:length(sf.inventory)
				l = length(sf.inventory{i});
				avails(i) = sum(sf.inventory{i}(1:l-1));
            end

			% get the number tossed out
			totalInv = sum(sf.inventory{1}) + sum(sf.inventory{2}) + sum(sf.inventory{3}) + sum(sf.inventory{4});
			overCap = totalInv - sf.capacity;
			i = 1;
			lo = length(sf.inventory{1})+1;
			lp = length(sf.inventory{2})+1;
			lr = length(sf.inventory{3})+1;
			lf = length(sf.inventory{4})+1;

			% for loop to go through products by weeks to expiry
			% various i levels are due to different number of weeks to rot
			% does exclude rotten stuff (why are we excluding this?
			% shouldnt rotten stuff be the first thing we get rid of? if it
			% is, just get rid of the minus ones.. michelle)
			while overCap > 0
				if (i <= 5)
					avail = sf.inventory{1}(lo - i) + sf.inventory{2}(lp - i) + sf.inventory{3}(lr - i) + sf.inventory{4}(lf - i);
					if (avail <= overCap) 
						sf.toss_out{1}(lo - i) = sf.inventory{1}(lo - i);
						sf.toss_out{2}(lp - i) = sf.inventory{2}(lp - i);
						sf.toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						sf.toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{1}(lo - i) = 0;
						sf.inventory{2}(lp - i) = 0;
						sf.inventory{3}(lr - i) = 0;
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						sf.toss_out{1}(lo - i) = overCap*sf.inventory{1}(lo - i)/avail;
						sf.toss_out{2}(lp - i) = overCap*sf.inventory{2}(lp - i)/avail;
						sf.toss_out{3}(lr - i) = overCap*sf.inventory{3}(lr - i)/avail;
						sf.toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						sf.inventory{1}(lo - i) = sf.inventory{1}(lo - i) - overCap*sf.inventory{1}(lo - i)/avail;
						sf.inventory{2}(lp - i) = sf.inventory{2}(lp - i) - overCap*sf.inventory{2}(lp - i)/avail;
						sf.inventory{3}(lr - i) = sf.inventory{3}(lr - i) - overCap*sf.inventory{3}(lr - i)/avail;
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				elseif (i <= 9)
					avail = sf.inventory{2}(lp - i) + sf.inventory{3}(lr - i) + sf.inventory{4}(lf - i);
					if (avail <= overCap)
						sf.toss_out{2}(lp - i) = sf.inventory{2}(lp - i);
						sf.toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						sf.toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{2}(lp - i) = 0;
						sf.inventory{3}(lr - i) = 0;
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						sf.toss_out{2}(lp - i) = overCap*sf.inventory{2}(lp - i)/avail;
						sf.toss_out{3}(lr - i) = overCap*sf.inventory{3}(lr - i)/avail;
						sf.toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						sf.inventory{2}(lp - i) = sf.inventory{2}(lp - i) - overCap*sf.inventory{2}(lp - i)/avail;
						sf.inventory{3}(lr - i) = sf.inventory{3}(lr - i) - overCap*sf.inventory{4}(lr - i)/avail;
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				elseif (i <= 13)
					avail = sf.inventory{3}(lr - i) + sf.inventory{4}(lf - i);
					if (avail <= overCap)
						sf.toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						sf.toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{3}(lr - i) = 0;
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						sf.inventory{3}(lr - i) = sf.inventory{3}(lr - i) - overCap*sf.inventory{3}(lr - i)/avail;
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap*sf.inventory{4}(lf - i)/avail;
						sf.toss_out{3}(lr - i) = overCap*sf.inventory{3}(lr - i)/avail;
						sf.toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				elseif (i <= 49)
					avail = sf.inventory{4}(lf - i);
					if (avail <= overCap)
						sf.toss_out{4}(lf - i) = sf.inventory{4}(lf - i);
						sf.inventory{4}(lf - i) = 0;
						overCap = overCap - avail;
					else
						sf.inventory{4}(lf - i) = sf.inventory{4}(lf - i) - overCap;
						sf.toss_out{4}(lf - i) = overCap*sf.inventory{4}(lf - i)/avail;
						overCap = 0;
					end

				else
					a = 'debugging needed'
				end
				i = i + 1;
            end
            for i = 1:4
                 sf.cum_toss_out(i) = sum(sf.toss_out{i});
            end
             
            sf.ROJman = sum(sf.roj_temp);
             % store in temp variable what we make from this week FCOJ
             for i = 1:length(sf.roj_temp)
                 sf.roj_temp(i) = sf.inventory{4}(i)* sf.reconPercent(ceil(time/4))/100;
             end
            
            % satisfy demand from FCOJ - ROJ
            demand = big_D;
            sf.transCost = 0;
            for i=1:3
                for k=1:length(cities)
                    j = length(sf.inventory{i})-1;
                    while ((demand(k,i) > 0) && (sum(sf.inventory{i}(1:j))) > 0)
                        if (demand(k,i) > sf.inventory{i}(j))
                            sf.ship_out{i}(j) = sf.ship_out{i}(j) + sf.inventory{i}(j);
                            demand(k,i) = demand(k,i) - sf.inventory{i}(j);
                            sf.transCost = sf.transCost + sf.inventory{i}(j)*cities{k,3}*0.22;
                            sf.revReceived(i) = sf.revReceived(i) + sf.inventory{i}(j)*big_P(k,i)*2000;
                            sf.inventory{i}(j) = 0;
                        else
                            sf.ship_out{i}(j) = sf.ship_out{i}(j) + demand(k,i);
                            sf.transCost = sf.transCost + demand(k,i)*cities{k,3}*1.2;
                            sf.revReceived(i) = sf.revReceived(i) + demand(k,i)*big_P(k,i)*2000;
                            sf.inventory{i}(j) = sf.inventory{i}(j) - demand(k,i);
                            demand(k,i) = 0;
                        end
                        j = j-1;
                    end
                end
                sf.sold(i) = sum(sf.ship_out{i});
            end
            
            i = 4;
            for k=1:length(cities)
                j = length(sf.inventory{i})-1;
                    while ((demand(k,i) > 0) && (sum((sf.inventory{i}(1:j)))-sum(sf.roj_temp)) > 0)
                        if (demand(k,i) > sf.inventory{i}(j)-sf.roj_temp(j))
                            sf.ship_out{i}(j) = sf.ship_out{i}(j) + sf.inventory{i}(j)-sf.roj_temp(j);
                            demand(k,i) = demand(k,i) - (sf.inventory{i}(j)-sf.roj_temp(j));
                            sf.transCost = sf.transCost + (sf.inventory{i}(j)-sf.roj_temp(j))*cities{k,3}*0.22;
                            sf.revReceived(i) = sf.revReceived(i) + (sf.inventory{i}(j)-sf.roj_temp(j))*big_P(k,i)*2000;
                            sf.inventory{i}(j) = sf.roj_temp(j);
                        else
                            sf.ship_out{i}(j) = sf.ship_out{i}(j) + demand(k,i);
                            sf.transCost = sf.transCost + demand(k,i)*cities{k,3}*1.2;
                            sf.revReceived(i) = sf.revReceived(i) + demand(k,i)*big_P(k,i)*2000;
                            sf.inventory{i}(j) = sf.inventory{i}(j) - demand(k,i);
                            demand(k,i) = 0;
                        end
                        j = j-1;
                    end
                end
            sf.sold(4) = sum(sf.ship_out{4});
                
            sf.excessDemand = demand;
            % get holding cost
			sf.holdCost = (sum(avails) - sum(sf.sold))*sf.holdC;
            
            % age inventory 1 week
			for i=1:length(sf.inventory)
				m = length(sf.inventory{i});
				for j=m:-1:2
					sf.inventory{i}(j) = sf.inventory{i}(j-1);
				end
				sf.inventory{i}(1) = 0;	
                %sf.rotten(i) = sf.inventory{i}(length(sf.inventory{i}));
            end

		end
	end
end