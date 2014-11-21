function [pricesOut,ratesOut] = genPrices(p0,r0)
	years = 2004:2013;
	fn1 = 'MomPop';
	fn2 = 'Results.xlsm';
	shtname = 'grove';
	means = zeros(6,1);
	stdevs = zeros(6,1);
	ps = zeros(4,1);
	mms = zeros(4,120);

	num_models = 6;
	mdls = cell(num_models,1);
	estmdls = cell(num_models,1);
	rate_mdls = cell(2,1);
	estrate_mdls = cell(2,1);
		

	% indexing is: Fla, Cal, Tex, Arz, Bra, Spa
	Prices = cell(6,1);
	MP = zeros(6,12);
	months = 1:12:120;
	% indexing is: real, euro
	xrates = cell(2,1);

	range = 'C5:N10';
	xrange = 'C14:N15';

	% need to do shit with exchange rates

	for i=1:length(years)
		fname = strcat(fn1, num2str(years(i)),fn2);

		data = xlsread(fname, shtname, range);
		ratedat = xlsread(fname, shtname, xrange);

		for j=1:6
			Prices{j} = [Prices{j} data(j,:)];
		end

		for j=1:2
			xrates{j} = [xrates{j} ratedat(j,:)];
		end
	end

	mat = load('yr2014a');
	data = mat.yr2014a.price_orange_spot_res;
	ratedat = mat.yr2014a.fx_exch_res;

	for j=1:6
		Prices{j} = [Prices{j} data(j,:)];
	end

	for j=1:2
		xrates{j} = [xrates{j} ratedat(j,:)];
	end

	mat = load('yr2014b');
	data = mat.yr2014b.price_orange_spot_res;
	ratedat = mat.yr2014b.fx_exch_res;

	for j=1:6
		Prices{j} = [Prices{j} data(j,:)];
	end

	for j=1:2
		xrates{j} = [xrates{j} ratedat(j,:)];
	end

	oPrices = Prices;

	numpts = length(Prices{1});
	tests = zeros(4,numpts);

	for i=1:6
		for j=0:11
			MP(i,j+1) = mean(Prices{i}(months + j));
		end
	end

	%figure;
	%hold on;
	%title('Monthly historical prices for each grove')

	linespecs = ['r', 'g', 'b', 'k', 'y', 'm'];

	for i=1:6
		%plot(Prices{i}, linespecs(i));
		means(i) = mean(Prices{i});
		stdevs(i) = std(Prices{i});
	end

	% tunable
	stdweights = [1,1.2,0.75,1,1.5,2];
	indices = cell(num_models,1);

	for i=1:num_models
		indices{i} = Prices{i} < means(i) + stdweights(i)*stdevs(i);

		for j=1:length(indices{i}) 
			if (indices{i}(j) == 0)
				Prices{i}(j) = means(i);
			end
		end
	end

	spikesAt = cell(num_models,1);
	probSpike = zeros(num_models,1);
	probMonth = zeros(num_models,12);
	for i=1:num_models
		spikesAt{i} = mod(find(~indices{i}),12);
		probSpike(i) = length(spikesAt{i})/length(Prices{i});
		for j=1:12
			if (j == 12)
				probMonth(i,j) = sum(spikesAt{i} == 0)/length(spikesAt{i});
			else
				probMonth(i,j) = sum(spikesAt{i} == j)/length(spikesAt{i});
			end
		end
	end

	ubound = [4,4,4,4,6,6];
	weights = [1.25, 1.25, 1, 1,10,10];
	tests = cell(6,1);

	for i=1:num_models
		numpts2 = length(Prices{i});
		mdls{i} = arima('Constant',p0(i), 'ARLags', [1:ubound(i)], 'MALags', [1,12]);
		estmdls{i} = estimate(mdls{i},transpose(Prices{i}));
		tests{i} = transpose(simulate(estmdls{i}, 12));

		
		for j=1:12:length(tests{i})
			m = mean(tests{i});
			vals = rand(12,1);
			ra = rand;
			for k=1:12
				if (vals(k) < probMonth(i,k) & ra < probSpike(i))
					if (i ~= 5)
						tests{i}(j+k) = 1.5*m;
					else
						tests{i}(j+k) = 1.1*m
					end
				end
				ra = rand;
			end
		end
	end

	testRates = cell(2,1);
	l = length(xrates{1});
	ratesOut = zeros(2,12);
	ratesOut(1,1) = r0(1) - .015*rand();
	ratesOut(2,1) = r0(2) - .03*rand();
	for j=2:12
		ratesOut(1,j) = ratesOut(1,j-1) + .0013 - rand(1)*.0003
	end

	for j=2:12
		ratesOut(2,j) = ratesOut(2,j-1) + .003 + rand(1)*.0002
	end

	% comment out to keep prices in local currency
	tests(5,:) = tests(5,:).*ratesOut(1,:);
	tests(6,:) = tests(6,:).*ratesOut(2,:);

	pricesOut = cell2mat(tests);

end