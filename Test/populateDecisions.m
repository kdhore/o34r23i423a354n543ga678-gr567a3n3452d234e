% processing to storage shipping
solver = 'Excel Files Orianga/Solver for POJ_grove to storagev2.xlsx';
decisions_file = 'Decisions/oriangagrande2017test.xlsm';
%decisions_file = 'Decisions/oriangagrande2017test_pousch.xlsm';

[~,~,proc_storage_shipping] = xlsread(solver,'Sheet1','C62:H64');
proc_storage_shipping = cell2mat(proc_storage_shipping);
proc_storage_shipping(abs(proc_storage_shipping)<0.00001) = 0;
xlswrite(decisions_file,proc_storage_shipping,'shipping_manufacturing','D27:I29');

% amount to buy
[~,~,amt_purchase] = xlsread(solver,'Sheet1','X34:X39');
amt_purchase = cell2mat(amt_purchase);
amt_purchase(abs(amt_purchase)<0.00001) = 0;
amt_purchase_matrix = zeros(6,12);
for i = 1:12
    amt_purchase_matrix(:,i) = amt_purchase;
end
ORA_futures = 0;
for i=2:2:length(decisions.future_mark_dec_ORA_current)
    ORA_futures = decisions.future_mark_dec_ORA_current(i) + ORA_futures;
end
ORA_futures_week = (ORA_futures*0.0833333)/4;
amt_purchase_matrix(1,:) = amt_purchase_matrix(1,:) - ORA_futures_week;
xlswrite(decisions_file,amt_purchase,'raw_materials','C6:N11');

% shipping from groves
[~,~,grove_shipping] = xlsread(solver,'Sheet1','Z50:AE55');
grove_shipping = cell2mat(grove_shipping);
grove_shipping(abs(grove_shipping)<0.00001) = 0;
xlswrite(decisions_file,grove_shipping,'shipping_manufacturing','C6:H11');

% percent roj in each storage unit
[~,~,roj_percent] = xlsread(solver,'Sheet1','M46:O46');
roj_percent = cell2mat(roj_percent);
roj_percent_matrix = zeros(3,12);
for i = 1:12
    roj_percent_matrix(:,i) = roj_percent';
end
xlswrite(decisions_file,roj_percent_matrix,'shipping_manufacturing','C37:N39');

% poj_percent
[~,~,poj_percent] = xlsread(solver,'Sheet1','C58:E58');
poj_percent = cell2mat(poj_percent);
xlswrite(decisions_file,poj_percent(1),'shipping_manufacturing','C19');
xlswrite(decisions_file,poj_percent(2),'shipping_manufacturing','E19');
xlswrite(decisions_file,poj_percent(3),'shipping_manufacturing','G19');