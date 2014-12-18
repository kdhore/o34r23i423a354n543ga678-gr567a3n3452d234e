function [] = fitCensoredDemandCurves2(yearMax)
	region = {'NE'; 'MA'; 'SE';'MW';'DS';'NW';'SW'};
	dist = load('Distance Data/storage2market_dist.mat');
	dist = cell2mat(dist.storage2market_dist);

	yrs = 2004:2013;
	yrs2 = 2014:yearMax;

	c = cell(length(yrs)+length(yrs2),1);

	for i=1:length(yrs)
		c{i} = load(strcat('YearData Offline/yr',num2str(yrs(i))));
	end

	%c{length(yrs)+1} = load('yr2014a.mat');
	%c{length(yrs)+2} = load('yr2014b.mat');

 	for i=1:length(yrs2)
 		c{i+10} = load(strcat('YearData Orianga/yr',num2str(yrs2(i))));
 	end

	compiled_prices_ORA = [];
	compiled_prices_POJ = [];
	compiled_prices_ROJ = [];
	compiled_prices_FCOJ = [];

	compiled_sales_ORA = [];
	compiled_sales_POJ = [];
	compiled_sales_ROJ = [];
	compiled_sales_FCOJ = [];

	compiled_avails_ORA = [];
	compiled_avails_POJ = [];
	compiled_avails_ROJ = [];
	compiled_avails_FCOJ = [];

	% the fits of each product for each region
	ORA_fits = cell(7,1);
	POJ_fits = cell(7,1);
	ROJ_fits = cell(7,1);
	FCOJ_fits = cell(7,1);

	% for every region
	for i=1:length(region)
		% initialization fort later use
		compiled_prices_ORA = [];
		compiled_prices_POJ = [];
		compiled_prices_ROJ = [];
		compiled_prices_FCOJ = [];

		compiled_sales_ORA = [];
		compiled_sales_POJ = [];
		compiled_sales_ROJ = [];
		compiled_sales_FCOJ = [];

		compiled_avails_ORA = [];
		compiled_avails_POJ = [];
		compiled_avails_ROJ = [];
		compiled_avails_FCOJ = [];

		ORA_res = [];
		POJ_res = [];
		ROJ_res = [];
		FCOJ_res = [];

		% get associated storage units, then process accordingly
        OJ_object = OJGame('MomPop2004Results.xlsm');
		for j=1:length(c)
			
			% which storage facility corresponds to the region
			sfac_name = matchRegiontoStorage(region(i),OJ_object,dist);
			% the name associated with each YearData object, for accessing the struct
			vn = '';
			if (j < 11)
				vn = genvarname(strcat('yr',num2str(yrs(j))));
			elseif (j < length(c)+1)
				%vn = genvarname(strcat('yr',num2str(yrs2(j-12)),'_new'));
				vn = genvarname(strcat('yr',num2str(yrs2(j-10))));
			end

			% putting all the prices for each region in one place, for easier manipulation
			compiled_prices_ORA	= [compiled_prices_ORA c{j}.(vn).pricing_ORA_dec(i,:)];
			compiled_sales_ORA = [compiled_sales_ORA c{j}.(vn).sales_tons_month_ORA_res(i,:)];
			compiled_prices_POJ	= [compiled_prices_POJ c{j}.(vn).pricing_POJ_dec(i,:)];
			compiled_sales_POJ = [compiled_sales_POJ c{j}.(vn).sales_tons_month_POJ_res(i,:)];
			compiled_prices_ROJ	= [compiled_prices_ROJ c{j}.(vn).pricing_ROJ_dec(i,:)];
			compiled_sales_ROJ = [compiled_sales_ROJ c{j}.(vn).sales_tons_month_ROJ_res(i,:)];
			compiled_prices_FCOJ = [compiled_prices_FCOJ c{j}.(vn).pricing_FCOJ_dec(i,:)];
			compiled_sales_FCOJ = [compiled_sales_FCOJ c{j}.(vn).sales_tons_month_FCOJ_res(i,:)];

			% doing the same for the amount purchased
			ORA_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).ORA_Sales(1,:)];
			POJ_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).POJ_Sales(1,:)];
			ROJ_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).ROJ_Sales(1,:)];
			FCOJ_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).FCOJ_Sales(1,:)];
			compiled_avails_ORA = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).ORA_Sales(2,:)];
			compiled_avails_POJ = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).POJ_Sales(2,:)];
			compiled_avails_ROJ = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).ROJ_Sales(2,:)];
			compiled_avails_FCOJ = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).FCOJ_Sales(2,:)];

			% updating the OJ_object (needed for finding storage facilities for each region)
            OJ_object = OJ_object.update(c{j}.(vn));
        end
        
        % uncensor by checking if the purchased is equal to the available
        % if it is, set the value to 0, which will be excluded later
		for j=1:length(ORA_res)
			if (ORA_res(j) == compiled_avails_ORA(j))
				ORA_res(j) = 0;
				compiled_avails_ORA(j) = 0;
			end
			if (POJ_res(j) == compiled_avails_POJ(j))
				POJ_res(j) = 0;
				compiled_avails_POJ(j) = 0;
			end
			if (ROJ_res(j) == compiled_avails_ROJ(j))
				ROJ_res(j) = 0;
				compiled_avails_ROJ(j) = 0;
			end
			if (FCOJ_res(j) == compiled_avails_FCOJ(j))
				FCOJ_res(j) = 0;
				compiled_avails_FCOJ(j) = 0;
			end
		end

		% log for logistic, identifies the zero values
		log_ORA_sales_out = (ORA_res ~= 0);
		log_POJ_sales_out = (POJ_res ~= 0);
		log_ROJ_sales_out = (ROJ_res ~= 0);
		log_FCOJ_sales_out = (FCOJ_res ~= 0);

		log_ORA_prices_out = (ORA_res ~= 0);
		log_POJ_prices_out = (POJ_res ~= 0);
		log_ROJ_prices_out = (ROJ_res ~= 0);
		log_FCOJ_prices_out = (FCOJ_res ~= 0);

		% more initialization
		ORA_sales_out = zeros(size(log_ORA_sales_out));
		POJ_sales_out = zeros(size(log_POJ_sales_out));
		ROJ_sales_out = zeros(size(log_ROJ_sales_out));
		FCOJ_sales_out = zeros(size(log_FCOJ_sales_out));

		ORA_prices_out = zeros(size(log_ORA_prices_out));
		POJ_prices_out = zeros(size(log_POJ_prices_out));
		ROJ_prices_out = zeros(size(log_ROJ_prices_out));
		FCOJ_prices_out = zeros(size(log_FCOJ_prices_out));

		% convert from monthly scale to weekly
		for j=1:length(compiled_sales_ORA)
			ORA_sales_out(4*j-3:4*j) = log_ORA_sales_out(4*j-3:4*j)*compiled_sales_ORA(j);
			ORA_prices_out(4*j-3:4*j) = log_ORA_prices_out(4*j-3:4*j)*compiled_prices_ORA(j);
			POJ_sales_out(4*j-3:4*j) = log_POJ_sales_out(4*j-3:4*j)*compiled_sales_POJ(j);
			POJ_prices_out(4*j-3:4*j) = log_POJ_prices_out(4*j-3:4*j)*compiled_prices_POJ(j);
			ROJ_sales_out(4*j-3:4*j) = log_ROJ_sales_out(4*j-3:4*j)*compiled_sales_ROJ(j);
			ROJ_prices_out(4*j-3:4*j) = log_ROJ_prices_out(4*j-3:4*j)*compiled_prices_ROJ(j);
			FCOJ_sales_out(4*j-3:4*j) = log_FCOJ_sales_out(4*j-3:4*j)*compiled_sales_FCOJ(j);
			FCOJ_prices_out(4*j-3:4*j) = log_FCOJ_prices_out(4*j-3:4*j)*compiled_prices_FCOJ(j);
		end

		% gets the non-zero terms (aka, those that aren't censored)
		% takes both the sales figures and the prices
		ORA_sales_out_indices = find(ORA_sales_out);
		ORA_sales_out = log(ORA_sales_out(ORA_sales_out_indices));
		ORA_prices_out = ORA_prices_out(ORA_sales_out_indices);

		POJ_sales_out_indices = find(POJ_sales_out);
		POJ_sales_out = log(POJ_sales_out(POJ_sales_out_indices));
		POJ_prices_out = POJ_prices_out(POJ_sales_out_indices);

		ROJ_sales_out_indices = find(ROJ_sales_out);
		ROJ_sales_out = log(ROJ_sales_out(ROJ_sales_out_indices));
		ROJ_prices_out = ROJ_prices_out(ROJ_sales_out_indices);

		FCOJ_sales_out_indices = find(FCOJ_sales_out);
		FCOJ_sales_out = log(FCOJ_sales_out(FCOJ_sales_out_indices));
		FCOJ_prices_out = FCOJ_prices_out(FCOJ_sales_out_indices);

		% hardcoded, as 7 regions for 4 products
		% manually assigned based on fits
		% generally, poly fits were better by order of .0001 on the r^2
		% these fit the tails better, but mostly fit everything else worse
		% default was 1 unless there was reason to switch to 2
		order = ones(28,1);
		order(5) = 2;
		order(21) = 2;
		order(23) = 2;
		order(25) = 2;
		order = ones(28,1);

		% note fits log of sales to prices
		ORA_fits{i} = polyfit(ORA_prices_out, ORA_sales_out, order(4*(i-1) + 1));
		POJ_fits{i} = polyfit(POJ_prices_out, POJ_sales_out, order(4*(i-1) + 2));
		ROJ_fits{i} = polyfit(ROJ_prices_out, ROJ_sales_out, order(4*(i-1) + 3));
		FCOJ_fits{i} = polyfit(FCOJ_prices_out, FCOJ_sales_out, order(4*(i-1) + 4));

		% removing outliers
		% need to look at distribution of residuals

		% modelled values
		ora_model = polyval(ORA_fits{i},ORA_prices_out);
		poj_model = polyval(POJ_fits{i},POJ_prices_out);
		roj_model = polyval(ROJ_fits{i},ROJ_prices_out);
		fcoj_model = polyval(FCOJ_fits{i},FCOJ_prices_out);

		% calculating residuals
		ora_res = ORA_sales_out - ora_model;
		poj_res = POJ_sales_out - poj_model;
		roj_res = ROJ_sales_out - roj_model;
		fcoj_res = FCOJ_sales_out - fcoj_model;

		% getting the statistics for the residual distribution
		ora_res_m = mean(ora_res);
		poj_res_m = mean(poj_res);
		roj_res_m = mean(roj_res);
		fcoj_res_m = mean(fcoj_res);

		ora_res_var = var(ora_res);
		poj_res_var = var(poj_res);
		roj_res_var = var(roj_res);
		fcoj_res_var = var(fcoj_res);

		% which values to keep
		ora_keep = ones(size(ORA_sales_out));
		poj_keep = ones(size(POJ_sales_out));
		roj_keep = ones(size(ROJ_sales_out));
		fcoj_keep = ones(size(FCOJ_sales_out));

		% remove the values that are outliers
		% also, remove prices < 2 since we'll never price that low,
		% and those might be fucking up the fits
		for s=1:length(ORA_sales_out)
			if(ora_res(s) < (ora_res_m - ora_res_var))
				ora_keep(s) = 0;
			end
			if (ORA_prices_out(s) < 2)
				ora_keep(s) = 0;
			end
		end

		for s=1:length(POJ_sales_out)
			if(poj_res(s) < (poj_res_m - poj_res_var))
				poj_keep(s) = 0;
			end
			if (POJ_prices_out(s) < 2)
				poj_keep(s) = 0;
			end
		end

		for s=1:length(ROJ_sales_out)
			if(roj_res(s) < (roj_res_m - roj_res_var))
				roj_keep(s) = 0;
			end
			if (ROJ_prices_out(s) < 2)
				roj_keep(s) = 0;
			end
		end

		for s=1:length(FCOJ_sales_out)
			if(fcoj_res(s) < (fcoj_res_m - fcoj_res_var))
				fcoj_keep(s) = 0;
			end
			if (FCOJ_prices_out(s) < 2)
				fcoj_keep(s) = 0;
			end
		end

		% removing the outliers by removing anything that was set to 0 above
		% need to remove the prices and sales to keep the vector lengths equal
		ora_not_outlier = find(ora_keep);
		poj_not_outlier = find(poj_keep);
		roj_not_outlier = find(roj_keep);
		fcoj_not_outlier = find(fcoj_keep);

		% code for testing how well the algorithm is removing points
		%{
		figure
		scatter(ORA_prices_out,ORA_sales_out,'b');
		hold on
		scatter(ORA_prices_out,ora_model,'g')
		ORA_sales_out = ORA_sales_out(ora_not_outlier);
		ORA_prices_out = ORA_prices_out(ora_not_outlier);
		scatter(ORA_prices_out,ORA_sales_out,'r+');

		figure
		scatter(POJ_prices_out,POJ_sales_out,'b');
		hold on
		scatter(POJ_prices_out,poj_model,'g')
		POJ_sales_out = POJ_sales_out(poj_not_outlier);
		POJ_prices_out = POJ_prices_out(poj_not_outlier);
		scatter(POJ_prices_out,POJ_sales_out,'r+');

		figure
		scatter(ROJ_prices_out,ROJ_sales_out,'b');
		hold on
		scatter(ROJ_prices_out,roj_model,'g')
		ROJ_sales_out = ROJ_sales_out(roj_not_outlier);		
		ROJ_prices_out = ROJ_prices_out(roj_not_outlier);
		scatter(ROJ_prices_out,ROJ_sales_out,'r+');

		figure
		scatter(FCOJ_prices_out,FCOJ_sales_out,'b');
		hold on
		scatter(FCOJ_prices_out,fcoj_model,'g')
		FCOJ_prices_out = FCOJ_prices_out(fcoj_not_outlier);
		FCOJ_sales_out = FCOJ_sales_out(fcoj_not_outlier);
		scatter(FCOJ_prices_out,FCOJ_sales_out,'r+');

		return
		%}

		% removing the outlier points (both x and y)
		ORA_sales_out = ORA_sales_out(ora_not_outlier);
		ORA_prices_out = ORA_prices_out(ora_not_outlier);
		POJ_sales_out = POJ_sales_out(poj_not_outlier);
		POJ_prices_out = POJ_prices_out(poj_not_outlier);
		ROJ_sales_out = ROJ_sales_out(roj_not_outlier);		
		ROJ_prices_out = ROJ_prices_out(roj_not_outlier);
		FCOJ_prices_out = FCOJ_prices_out(fcoj_not_outlier);
		FCOJ_sales_out = FCOJ_sales_out(fcoj_not_outlier);

		% refit the model with no outliers
		
		ORA_fits{i} = polyfit(ORA_prices_out, ORA_sales_out, order(4*(i-1) + 1));
		POJ_fits{i} = polyfit(POJ_prices_out, POJ_sales_out, order(4*(i-1) + 2));
		ROJ_fits{i} = polyfit(ROJ_prices_out, ROJ_sales_out, order(4*(i-1) + 3));
		FCOJ_fits{i} = polyfit(FCOJ_prices_out, FCOJ_sales_out, order(4*(i-1) + 4));

		% calculating r^2, for comparing fits and plotting
		
		ora_model = polyval(ORA_fits{i},ORA_prices_out);
		poj_model = polyval(POJ_fits{i},POJ_prices_out);
		roj_model = polyval(ROJ_fits{i},ROJ_prices_out);
		fcoj_model = polyval(FCOJ_fits{i},FCOJ_prices_out);

		% getting residuals
		ora_res = ORA_sales_out - ora_model;
		poj_res = POJ_sales_out - poj_model;
		roj_res = ROJ_sales_out - roj_model;
		fcoj_res = FCOJ_sales_out - fcoj_model;

		ora_ss_res = sum(ora_res.^2);
		poj_ss_res = sum(poj_res.^2);
		roj_ss_res = sum(roj_res.^2);
		fcoj_ss_res = sum(fcoj_res.^2);

		ora_ss_total = (length(ORA_prices_out)-1)*var(ORA_prices_out);
		poj_ss_total = (length(POJ_prices_out)-1)*var(POJ_prices_out);
		roj_ss_total = (length(ROJ_prices_out)-1)*var(ROJ_prices_out);
		fcoj_ss_total = (length(FCOJ_prices_out)-1)*var(FCOJ_prices_out);

		ora_rsq = 1 - ora_ss_res/ora_ss_total;
		poj_rsq = 1 - poj_ss_res/poj_ss_total;
		roj_rsq = 1 - roj_ss_res/roj_ss_total;
		fcoj_rsq = 1 - fcoj_ss_res/fcoj_ss_total;

		%{
		figure;
		scatter(ORA_prices_out,ORA_sales_out);
		hold on
		scatter(ORA_prices_out,ora_model,'r')
		%hold on
		%scatter(ORA_prices_out(end-12:end),ora_model(end-12:end),'g')
		grid on
		title(strcat('lin ORA, ', region(i),',',num2str(ora_rsq)));

		figure;
		scatter(POJ_prices_out,POJ_sales_out);
		hold on
		scatter(POJ_prices_out,poj_model,'r')
		%hold on
		%scatter(POJ_prices_out(end-12:end),poj_model(end-12:end),'g')
		grid on
		title(strcat('lin POJ, ', region(i),',',num2str(poj_rsq)));

		figure;
		scatter(ROJ_prices_out,ROJ_sales_out);
		hold on
		scatter(ROJ_prices_out,roj_model,'r')
		%hold on
		%scatter(ROJ_prices_out(end-12:end),roj_model(end-12:end),'g')
		grid on
		title(strcat('lin ROJ, ', region(i),',',num2str(roj_rsq)));

		figure;
		scatter(FCOJ_prices_out,FCOJ_sales_out);
		hold on
		scatter(FCOJ_prices_out,fcoj_model,'r')
		%hold on
		%scatter(FCOJ_prices_out(end-12:end),fcoj_model(end-12:end),'g')
		grid on
		title(strcat('lin FCOJ, ', region(i),',',num2str(fcoj_rsq)));
		%}
			
	end
	% save as coefficients, note: generated values still need to be de-logged
	save('fitCoefficients','ORA_fits','POJ_fits','ROJ_fits','FCOJ_fits');
	save('ORA_fits_log.mat','ORA_fits');
	save('POJ_fits_log.mat','POJ_fits');
	save('ROJ_fits_log.mat','ROJ_fits');
	save('FCOJ_fits_log.mat','FCOJ_fits');
end