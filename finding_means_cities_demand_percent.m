[ORA_month_2004, ORA_yr_2004] = salesfunc(yr2004, 'ORA');
[ORA_month_2005, ORA_yr_2005] = salesfunc(yr2005, 'ORA');
[ORA_month_2006, ORA_yr_2006] = salesfunc(yr2006, 'ORA');
[ORA_month_2007, ORA_yr_2007] = salesfunc(yr2007, 'ORA');
[ORA_month_2008, ORA_yr_2008] = salesfunc(yr2008, 'ORA');
[ORA_month_2009, ORA_yr_2009] = salesfunc(yr2009, 'ORA');
[ORA_month_2010, ORA_yr_2010] = salesfunc(yr2010, 'ORA');
[ORA_month_2011, ORA_yr_2011] = salesfunc(yr2011, 'ORA');
[ORA_month_2012, ORA_yr_2012] = salesfunc(yr2012, 'ORA');
[ORA_month_2013, ORA_yr_2013] = salesfunc(yr2013, 'ORA');
[ORA_month_2014a, ORA_yr_2014a] = salesfunc(yr2014a, 'ORA');
[ORA_month_2014b, ORA_yr_2014b] = salesfunc(yr2014b, 'ORA');

ORA_means_by_city = mean([ORA_yr_2004,ORA_yr_2005,ORA_yr_2006,ORA_yr_2007,ORA_yr_2008,ORA_yr_2009,ORA_yr_2010,ORA_yr_2011,ORA_yr_2012,ORA_yr_2013,ORA_yr_2014a,ORA_yr_2014b],2);

[POJ_month_2004, POJ_yr_2004] = salesfunc(yr2004, 'POJ');
[POJ_month_2005, POJ_yr_2005] = salesfunc(yr2005, 'POJ');
[POJ_month_2006, POJ_yr_2006] = salesfunc(yr2006, 'POJ');
[POJ_month_2007, POJ_yr_2007] = salesfunc(yr2007, 'POJ');
[POJ_month_2008, POJ_yr_2008] = salesfunc(yr2008, 'POJ');
[POJ_month_2009, POJ_yr_2009] = salesfunc(yr2009, 'POJ');
[POJ_month_2010, POJ_yr_2010] = salesfunc(yr2010, 'POJ');
[POJ_month_2011, POJ_yr_2011] = salesfunc(yr2011, 'POJ');
[POJ_month_2012, POJ_yr_2012] = salesfunc(yr2012, 'POJ');
[POJ_month_2013, POJ_yr_2013] = salesfunc(yr2013, 'POJ');
[POJ_month_2014a, POJ_yr_2014a] = salesfunc(yr2014a, 'POJ');
[POJ_month_2014b, POJ_yr_2014b] = salesfunc(yr2014b, 'POJ');

POJ_means_by_city = mean([POJ_yr_2004,POJ_yr_2005,POJ_yr_2006,POJ_yr_2007,POJ_yr_2008,POJ_yr_2009,POJ_yr_2010,POJ_yr_2011,POJ_yr_2012,POJ_yr_2013,POJ_yr_2014a,POJ_yr_2014b],2);

[FCOJ_month_2004, FCOJ_yr_2004] = salesfunc(yr2004, 'FCOJ');
[FCOJ_month_2005, FCOJ_yr_2005] = salesfunc(yr2005, 'FCOJ');
[FCOJ_month_2006, FCOJ_yr_2006] = salesfunc(yr2006, 'FCOJ');
[FCOJ_month_2007, FCOJ_yr_2007] = salesfunc(yr2007, 'FCOJ');
[FCOJ_month_2008, FCOJ_yr_2008] = salesfunc(yr2008, 'FCOJ');
[FCOJ_month_2009, FCOJ_yr_2009] = salesfunc(yr2009, 'FCOJ');
[FCOJ_month_2010, FCOJ_yr_2010] = salesfunc(yr2010, 'FCOJ');
[FCOJ_month_2011, FCOJ_yr_2011] = salesfunc(yr2011, 'FCOJ');
[FCOJ_month_2012, FCOJ_yr_2012] = salesfunc(yr2012, 'FCOJ');
[FCOJ_month_2013, FCOJ_yr_2013] = salesfunc(yr2013, 'FCOJ');
[FCOJ_month_2014a, FCOJ_yr_2014a] = salesfunc(yr2014a, 'FCOJ');
[FCOJ_month_2014b, FCOJ_yr_2014b] = salesfunc(yr2014b, 'FCOJ');

FCOJ_means_by_city = mean([FCOJ_yr_2004,FCOJ_yr_2005,FCOJ_yr_2006,FCOJ_yr_2007,FCOJ_yr_2008,FCOJ_yr_2009,FCOJ_yr_2010,FCOJ_yr_2011,FCOJ_yr_2012,FCOJ_yr_2013,FCOJ_yr_2014a,FCOJ_yr_2014b],2);

[ROJ_month_2004, ROJ_yr_2004] = salesfunc(yr2004, 'ROJ');
[ROJ_month_2005, ROJ_yr_2005] = salesfunc(yr2005, 'ROJ');
[ROJ_month_2006, ROJ_yr_2006] = salesfunc(yr2006, 'ROJ');
[ROJ_month_2007, ROJ_yr_2007] = salesfunc(yr2007, 'ROJ');
[ROJ_month_2008, ROJ_yr_2008] = salesfunc(yr2008, 'ROJ');
[ROJ_month_2009, ROJ_yr_2009] = salesfunc(yr2009, 'ROJ');
[ROJ_month_2010, ROJ_yr_2010] = salesfunc(yr2010, 'ROJ');
[ROJ_month_2011, ROJ_yr_2011] = salesfunc(yr2011, 'ROJ');
[ROJ_month_2012, ROJ_yr_2012] = salesfunc(yr2012, 'ROJ');
[ROJ_month_2013, ROJ_yr_2013] = salesfunc(yr2013, 'ROJ');
[ROJ_month_2014a, ROJ_yr_2014a] = salesfunc(yr2014a, 'ROJ');
[ROJ_month_2014b, ROJ_yr_2014b] = salesfunc(yr2014b, 'ROJ');

ROJ_means_by_city = mean([ROJ_yr_2004,ROJ_yr_2005,ROJ_yr_2006,ROJ_yr_2007,ROJ_yr_2008,ROJ_yr_2009,ROJ_yr_2010,ROJ_yr_2011,ROJ_yr_2012,ROJ_yr_2013,ROJ_yr_2014a,ROJ_yr_2014b],2);

