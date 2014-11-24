function [] = fitCensoredDemandCurves(yearMax)
	region = {'NE'; 'MA'; 'SE';'MW';'DS';'NW';'SW'};

	yrs = 2004:2013;
	yrs2 = 2014:yearMax;

	c = cell(length(yrs)+2+length(yrs2),1);

	for i=1:length(yrs)
		c{i} = load(strcat('yr',num2str(yrs(i))));
	end

	c{length(yrs)+1} = load('yr2014a.mat');
	c{length(yrs)+2} = load('yr2014b.mat');

	length(yrs)+2+length(yrs2)
	c

 	for i=length(yrs)+2+1:length(yrs)+2+length(yrs2)
 		c{i} = load(strcat('yr',num2str(yrs2+i-length(yrs)-3)));
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

	ORA_fits = zeros(7,3);
	POJ_fits = zeros(7,3);
	ROJ_fits = zeros(7,3);
	FCOJ_fits = zeros(7,3);



	for i=1:length(region)
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
		for j=1:11
			
			sfac_name = matchRegiontoStorage(region(i),OJ_object);

			vn = genvarname(strcat('yr',num2str(yrs(j))));
			compiled_prices_ORA	= [compiled_prices_ORA c{j}.(vn).pricing_ORA_dec(i,:)];
			compiled_sales_ORA = [compiled_sales_ORA c{j}.(vn).sales_tons_month_ORA_res(i,:)];
			compiled_prices_POJ	= [compiled_prices_POJ c{j}.(vn).pricing_POJ_dec(i,:)];
			compiled_sales_POJ = [compiled_sales_POJ c{j}.(vn).sales_tons_month_POJ_res(i,:)];
			compiled_prices_ROJ	= [compiled_prices_ROJ c{j}.(vn).pricing_ROJ_dec(i,:)];
			compiled_sales_ROJ = [compiled_sales_ROJ c{j}.(vn).sales_tons_month_ROJ_res(i,:)];
			compiled_prices_FCOJ = [compiled_prices_FCOJ c{j}.(vn).pricing_FCOJ_dec(i,:)];
			compiled_sales_FCOJ = [compiled_sales_FCOJ c{j}.(vn).sales_tons_month_FCOJ_res(i,:)];

			ORA_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).ORA_Sales(1,:)];
			POJ_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).POJ_Sales(1,:)];
			ROJ_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).ROJ_Sales(1,:)];
			FCOJ_res = [ORA_res c{j}.(vn).storage_res(sfac_name{1}).FCOJ_Sales(1,:)];
			compiled_avails_ORA = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).ORA_Sales(2,:)];
			compiled_avails_POJ = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).POJ_Sales(2,:)];
			compiled_avails_ROJ = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).ROJ_Sales(2,:)];
			compiled_avails_FCOJ = [compiled_avails_ORA c{j}.(vn).storage_res(sfac_name{1}).FCOJ_Sales(2,:)];
            OJ_object = OJ_object.update(strcat('MomPop',num2str(yrs(j)),'Results.xlsm'));

        end
        

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

		log_ORA_sales_out = (ORA_res ~= 0);
		log_POJ_sales_out = (POJ_res ~= 0);
		log_ROJ_sales_out = (ROJ_res ~= 0);
		log_FCOJ_sales_out = (FCOJ_res ~= 0);

		log_ORA_prices_out = (ORA_res ~= 0);
		log_POJ_prices_out = (POJ_res ~= 0);
		log_ROJ_prices_out = (ROJ_res ~= 0);
		log_FCOJ_prices_out = (FCOJ_res ~= 0);

		ORA_sales_out = zeros(size(log_ORA_sales_out));
		POJ_sales_out = zeros(size(log_POJ_sales_out));
		ROJ_sales_out = zeros(size(log_ROJ_sales_out));
		FCOJ_sales_out = zeros(size(log_FCOJ_sales_out));

		ORA_prices_out = zeros(size(log_ORA_prices_out));
		POJ_prices_out = zeros(size(log_POJ_prices_out));
		ROJ_prices_out = zeros(size(log_ROJ_prices_out));
		FCOJ_prices_out = zeros(size(log_FCOJ_prices_out));

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

		ORA_sales_out_indices = find(ORA_sales_out);
		ORA_sales_out = ORA_sales_out(ORA_sales_out_indices);
		ORA_prices_out = ORA_prices_out(ORA_sales_out_indices);

		POJ_sales_out_indices = find(POJ_sales_out);
		POJ_sales_out = POJ_sales_out(POJ_sales_out_indices);
		POJ_prices_out = POJ_prices_out(POJ_sales_out_indices);

		ROJ_sales_out_indices = find(ROJ_sales_out);
		ROJ_sales_out = ROJ_sales_out(ROJ_sales_out_indices);
		ROJ_prices_out = ROJ_prices_out(ROJ_sales_out_indices);

		FCOJ_sales_out_indices = find(FCOJ_sales_out);
		FCOJ_sales_out = FCOJ_sales_out(FCOJ_sales_out_indices);
		FCOJ_prices_out = FCOJ_prices_out(FCOJ_sales_out_indices);


		ORA_fits(i,:) = polyfit(ORA_prices_out, ORA_sales_out, 2);
		POJ_fits(i,:) = polyfit(POJ_prices_out, POJ_sales_out, 2);
		ROJ_fits(i,:) = polyfit(ROJ_prices_out, ROJ_sales_out, 2);
		FCOJ_fits(i,:) = polyfit(FCOJ_prices_out, FCOJ_sales_out, 2);
	end

	save('fitCoefficients','ORA_fits','POJ_fits','ROJ_fits','FCOJ_fits');
end