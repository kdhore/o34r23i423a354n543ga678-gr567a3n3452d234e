classdef processingPlant < handle

	properties(SetAccess = private)
		capacity = 0;
		percentPOJ = 0;
		percentFCOJ = 0;
		% 1-4 are that number of weeks in the plant, 5 is rotten
		ora = zeros(5,1); % had to hardcode, working on modularizing
		breakdown = 0;
		fcojCost = 0;
		pojCost = 0;
		tankers = zeros(3,1);
		tankerCost = 0;
		% other properties tbd
		% upper bound on capacity?
		% tankers?
	end

	methods
		% the constructor
		function pp = processingPlant(capacity, percentPOJ, breakdown, ora, pojC, fcojC, tankers, tankerCost)
			% input validation
			if (breakdown ~= 0 & breakdown ~= 1)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'breakdown must be 0 or 1';
				typeException = MException(errID, msg);
				throw(typeException);
			end

			if (~(isequal(size(ora), size(pp.ora)) | isequal(size(transpose(ora)), size(pp.ora))))
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'ORA must be a 5 element vector';
				exc = MException(errID,msg);
				throw(exc);
			end

			if (percentPOJ < 0 | percentPOJ > 100)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				percentErrMsg = 'percentPOJ arguement must be between 0 and 1';
				percentException = MException(errID, percentErrMsg);
				throw(percentException);
			end

			pp.capacity = capacity;
			pp.percentPOJ = percentPOJ;
			pp.percentFCOJ = 100 - percentPOJ;
			pp.ora = ora;
			pp.breakdown = breakdown;
			pp.tankers = tankers;
			pp.tankerCost = tankerCost;
			pp.pojCost = pojC;
			pp.fcojCost = fcojC;
		end

		% update the Percent POJ at each processing plant
		% function to handle input validation internally
		function setPercentPOJ(pp, newPercentPOJ)
			if (newPercentPOJ < 0 | newPercentPOJ > 100)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'percentPOJ arguement must be between 0 and 1';
				percentException = MException(errID, msg);
				throw(percentException);

			else
				pp.percentPOJ = newPercentPOJ;
				pp.percentFCOJ = 100 - newPercentPOJ;
			end
		end % function

		% function to buy/sell capacity at each plant
		% function to handle validation internally
		% if added capacity > 0, buying; < 0, selling 
		function addCapacity(pp, addedCapacity)
			if (pp.capacity + addedCapacity < 0)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'Capacity being sold is larger than available capacity';
				capException = MException(errID, msg);
				throw(capException);

			else	
				pp.capacity = pp.capacity + addedCapacity;
			end
		end

		% more parameter changing functions
		function setTankerCost(pp, newcost)
			pp.tankerCost = newcost;
		end

		function setFCOJC(pp, newcost)
			pp.fcojCost = newcost;
		end

		function setPOJC(pp, newcost)
			pp.pojc = newcost;
		end

		function setTankers(pp, newT)
			pp.tankers = newT;
		end

		% simulate one week, breakdown is 0 for no, 1 for yes
		% oraIn is the number of oranges coming into the system
		% poj is tons of poj
		% fcoj is tons of fcoj
		% throwaway is number of tossed before processing
		% rotten is number of oranges that rotted
		% pCost is the cost of procucing POJ
		% fCost is the cost of producing FCOJ
		% tCost is the cost of tankers
		function [poj,fcoj,throwaway,rotten,pCost,fCost,tCost] = iterateWeek(pp, oraIn, breakdown)
			% input validation
			if (breakdown ~= 0 & breakdown ~= 1)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'breakdown must be 0 or 1';
				typeException = MException(errID, msg);
				throw(typeException);
			end

			if (oraIn < 0)
				errID = 'MATLAB:odearguments:InconsistentDataType';
				msg = 'oraIn must be non-negative';
				capException = MException(errID, msg);
				throw(capException);
			end

			% aging inventory
			for i=5:-1:2
				pp.ora(i) = pp.ora(i-1);
			end
			% adding newly recieved products to inventory
			pp.ora(1) = oraIn;

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

			% producing poj and fcoj or not, depending on breakdown
			pp.breakdown = breakdown;
			poj = 0;
			fcoj = 0;
			% producing stuff if not broken down
			if (breakdown == 0)
				poj = pp.percentPOJ*sum(pp.ora(1:4))/100.0;
				fcoj = pp.percentFCOJ*sum(pp.ora(1:4))/100.0;
				pp.ora = zeros(5,1);
			end
			pCost = pp.pojCost * poj;
			fCost = pp.fcojCost * fcoj;
			% getting rid of the rotten stuff
			pp.ora(5) = 0;

			% modelling the takers and cost
			newTankers = zeros(3,1);
			newTankers(1) = pp.tankers(1)-pp.tankers(2)+pp.tankers(3);
			newTankers(3) = pp.tankers(2);
			newTankers(2) = min(ceil((poj+fcoj)/30),newTankers(1));
			tCost = newTankers(1)*pp.tankerCost;

			pp.tankers = newTankers;
		end
	end
end