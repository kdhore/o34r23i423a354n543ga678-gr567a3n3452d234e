function [pricesOut,ratesOut] = genPrices()
	load('Grove Price Model/ARMAModels.mat');
	load('Grove Price Model/probs.mat');
	rPrev = load('Grove Price Model/inits.mat');
	rPrev = rPrev.inits;
	num_models = length(estmdls);

	tests = cell(6,1);

	for i=1:num_models
		tests{i} = transpose(simulate(estmdls{i}, 12));
		
		for j=1:12:length(tests{i})
			m = mean(tests{i});
			vals = rand(12,1);
			ra = rand;
			for k=1:12
				if (vals(k) < probMonth(i,k))
					if (i ~= 5)
						tests{i}(j+k - 1) = 1.5*m;
					else
						tests{i}(j+k - 1) = 1.1*m;
					end
				end
				ra = rand;
			end
		end
	end

	testRates = cell(2,1);
	ratesOut = zeros(2,12);
	ratesOut(1,1) = rPrev(1) - .015*rand();
	ratesOut(2,1) = rPrev(2) - .03*rand();
	for j=2:12
		ratesOut(1,j) = ratesOut(1,j-1) + .0013 - rand(1)*.0003;
	end

	for j=2:12
		ratesOut(2,j) = ratesOut(2,j-1) + .003 + rand(1)*.0002;
	end

	% comment out to keep prices in local currency
	tests{5} = tests{5}.*ratesOut(1,:);
	tests{6} = tests{6}.*ratesOut(2,:);

	pricesOut = cell2mat(tests);

end