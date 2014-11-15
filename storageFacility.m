classdef storageFacility < handle

	properties(SetAccess = private)
		capacity = 0;
		inventory = cell(4,1);
		reconPercent = 0;
		reconC = 0;
		holdC = 0;
	end

	methods
		% constructor
		% still need inventory
		% inventory as a properly formatted cell array
		% ORA is 5x1
		% POJ is 9x1
		% ROJ is 13x1
		% FCOJ is 49x1
		function sf = storageFacility(cap,inventory,rc,hc,rp)
			sf.inventory = inventory;
			sf.capacity = cap;
			sf.reconC = rc;
			sf.holdC = hc;
			sf.reconPercent = rp;
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
			if (pp.capacity + addedCapacity < 0)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'Capacity being sold is larger than available capacity';
				capException = MException(errID, msg);
				throw(capException);
			else	
				pp.capacity = pp.capacity + addedCapacity;
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
		% ROJOut is the amount of ROJ reconstituted, to be used as next week's input
		function [ship_out, sold, toss_out, rotten, demand, reconCost, holdCost, ROJOut] = iterateWeek(sf, matsIn, sales)
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

			% add in new inventory
			sf.inventory{1}(1) = sf.inventory{1}(1) + matsIn{1};
			sf.inventory{2}(1:4) = sf.inventory{2}(1:4) + matsIn{2};
			sf.inventory{3}(1) = sf.inventory{3}(1) + matsIn{3};
			sf.inventory{4}(1:4) = sf.inventory{4}(1:4) + matsIn{4};

			% get how much of each product is available
			for i=1:length(sf.inventory)-1
				l = length(sf.inventory{i});
				avails(i) = sum(sf.inventory{i}(1:l-1));
			end

			% special case for FCOJ due to reconstitution
			avails(4) = (1-sf.reconPercent)*(sum(sf.inventory{4}));

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
			% does exclude rotten stuff
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
						toss_out{1}(lo - i) = sf.inventory{1}(lo - i);
						toss_out{2}(lp - i) = sf.inventory{2}(lp - i);
						toss_out{3}(lr - i) = sf.inventory{3}(lr - i);
						toss_out{4}(lf - i) = sf.inventory{4}(lp - i);
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

			% reconstitute, store separatley as it can only be used next week
			FCOJRecon = sum(sf.inventory{4}(1:lf-1)) * sf.reconPercent;
			ROJOut = FCOJRecon;
			reconCost = FCOJRecon * sf.reconC;
			j = length(sf.inventory{4}-1);
			for i=1:j
				sf.inventory{4}(i) = sf.inventory{4}(i)*(1-sf.reconPercent);
			end

			% remove sales from inventory
			demand = sales;
			for i=1:4
				j = length(sf.inventory{i})-1;
				while ((demand(i) > 0) & (sum(sf.inventory{i}(1:length(sf.inventory{i})-1))) > 0)
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