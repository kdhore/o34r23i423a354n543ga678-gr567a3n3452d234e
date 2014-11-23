function [] = updateModels(yearMax)
	years = 2004:2013;
	%years2 = 2014:yearMax;
	%fn1 = 'MomPop';
	%fn2 = 'Results.xlsm';
	fn1 = 'yr';
	fn2 = '';
	shtname = 'grove';
	means = zeros(6,1);
	stdevs = zeros(6,1);
	ps = zeros(4,1);
	mms = zeros(4,120);

	num_models = 6;
	mdls = cell(num_models,1);
	estmdls = cell(num_models,1);
	rate_mdls = cell(2,1);
		
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
		vn = genvarname(fname);

		data = load(fname);
		%data = xlsread(fname, shtname, range);
		%ratedat = xlsread(fname, shtname, xrange);

		for j=1:6
			Prices{j} = [Prices{j} data.(vn).price_orange_spot_res(j,:)];
		end

		for j=1:2
			xrates{j} = [xrates{j} data.(vn).fx_exch_res(j,:)];
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

	%{
	for i=1:length(years2)
		fname = strcat(fn1, num2str(years2(i)),fn2);
		vn = genvarname(fname);

		data = load(fname);
		%data = xlsread(fname, shtname, range);
		%ratedat = xlsread(fname, shtname, xrange);

		for j=1:6
			Prices{j} = [Prices{j} data.(vn).price_orange_spot_res(j,:)];
		end

		for j=1:2
			xrates{j} = [xrates{j} data.(vn).fx_exch_res(j,:)];
		end
	end
	%}
	

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
	inits = zeros(2,1);

	for i=1:num_models
		numpts2 = length(Prices{i});
		m = mean(Prices{i});
		st = std(Prices{i});

		%inits(i) = m + unifrnd(-1,1)*st;

		mdls{i} = arima('Constant',(m+unifrnd(-1,1)*st), 'ARLags', [1:ubound(i)], 'MALags', [1,12]);
		estmdls{i} = estimate(mdls{i},transpose(Prices{i}));
	end

	inits(1) = xrates{1}(length(xrates{1}));
	inits(2) = xrates{2}(length(xrates{2}));

	save('ARMAModels.mat','estmdls');
	save('probs.mat','spikesAt','probSpike','probMonth');
	save('inits.mat','inits');
end