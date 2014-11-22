classdef DecisionsTemp < handle
    properties
		year;
        proc_plant_dec;
        tank_car_dec;
        storage_dec;
        purchase_spotmkt_dec;
        quant_mult_dec;
        future_mark_dec_ORA_current1;
        future_mark_dec_ORA_current2;
        future_mark_dec_ORA_current3;
        future_mark_dec_ORA_current4;
        future_mark_dec_ORA_current5;
        future_mark_dec_FCOJ_current1;
        future_mark_dec_FCOJ_current2;
        future_mark_dec_FCOJ_current3;
        future_mark_dec_FCOJ_current4;
        future_mark_dec_FCOJ_current5;
        arr_future_dec_ORA;
        arr_future_dec_FCOJ;
        ship_grove_dec;
        manufac_proc_plant_dec = zeros(2,10);
        futures_ship_dec = zeros(71,1);
        ship_proc_plant_storage_dec = struct([]);
        reconst_storage_dec = zeros(71,12);
        pricing_ORA_dec;
        pricing_ORA_weekly_dec;
        pricing_POJ_dec;
        pricing_POJ_weekly_dec;
        pricing_FCOJ_dec;
        pricing_FCOJ_weekly_dec;
        pricing_ROJ_dec;
        pricing_ROJ_weekly_dec;
        storage_res;
        sales_week_ORA_res;
        sales_week_POJ_res;
        sales_week_FCOJ_res;
        sales_week_ROJ_res;
    end
    
    methods
        function dec = DecisionsTemp(yrDataObj)
        dec.year = yrDataObj.year;
        dec.proc_plant_dec = yrDataObj.proc_plant_dec;
        dec.tank_car_dec = yrDataObj.tank_car_dec;
        dec.storage_dec = yrDataObj.storage_dec;
        dec.purchase_spotmkt_dec = yrDataObj.purchase_spotmkt_dec;
        dec.quant_mult_dec = yrDataObj.quant_mult_dec;
        dec.future_mark_dec_ORA_current1 = yrDataObj.future_mark_dec_ORA_current1;
        dec.future_mark_dec_ORA_current2 = yrDataObj.future_mark_dec_ORA_current2;
        dec.future_mark_dec_ORA_current3 = yrDataObj.future_mark_dec_ORA_current3;
        dec.future_mark_dec_ORA_current4 = yrDataObj.future_mark_dec_ORA_current4;
        dec.future_mark_dec_ORA_current5 = yrDataObj.future_mark_dec_ORA_current5;
        dec.future_mark_dec_FCOJ_current1 = yrDataObj.future_mark_dec_FCOJ_current1;
        dec.future_mark_dec_FCOJ_current2 = yrDataObj.future_mark_dec_FCOJ_current2;
        dec.future_mark_dec_FCOJ_current3 = yrDataObj.future_mark_dec_FCOJ_current3;
        dec.future_mark_dec_FCOJ_current4 = yrDataObj.future_mark_dec_FCOJ_current4;
        dec.future_mark_dec_FCOJ_current5 = yrDataObj.future_mark_dec_FCOJ_current5;
        dec.arr_future_dec_ORA = yrDataObj.arr_future_dec_ORA;
        dec.arr_future_dec_FCOJ = yrDataObj.arr_future_dec_FCOJ;
        dec.ship_grove_dec = yrDataObj.ship_grove_dec;
        dec.manufac_proc_plant_dec = yrDataObj.manufac_proc_plant_dec;
        dec.futures_ship_dec = yrDataObj.futures_ship_dec;
        dec.ship_proc_plant_storage_dec = yrDataObj.ship_proc_plant_storage_dec;
        dec.reconst_storage_dec = yrDataObj.reconst_storage_dec;
        dec.pricing_ORA_dec = yrDataObj.pricing_ORA_dec;
        dec.pricing_ORA_weekly_dec = yrDataObj.pricing_ORA_weekly_dec;
        dec.pricing_POJ_dec = yrDataObj.pricing_POJ_dec;
        dec.pricing_POJ_weekly_dec = yrDataObj.pricing_POJ_weekly_dec;
        dec.pricing_FCOJ_dec = yrDataObj.pricing_FCOJ_dec;
        dec.pricing_FCOJ_weekly_dec = yrDataObj.pricing_FCOJ_weekly_dec;
        dec.pricing_ROJ_dec = yrDataObj.pricing_ROJ_dec;
        dec.pricing_ROJ_weekly_dec = yrDataObj.pricing_ROJ_weekly_dec;
        dec.storage_res = yrDataObj.storage_res;
        dec.sales_week_ORA_res = yrDataObj.sales_week_ORA_res;
        dec.sales_week_POJ_res = yrDataObj.sales_week_POJ_res;
        dec.sales_week_FCOJ_res = yrDataObj.sales_week_FCOJ_res;
        dec.sales_week_ROJ_res = yrDataObj.sales_week_ROJ_res;
               
        end
    end
end