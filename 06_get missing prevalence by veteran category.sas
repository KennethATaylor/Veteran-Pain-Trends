libname out "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets\SAS Output";
libname ipums "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets";

OPTIONS FMTSEARCH = ( IPUMS.NHIS_Formats );

*recodes to avoid calculating everyone with a missing variable when estimating missingness 
	*sample adults who refuse to answer, there is failure to ascertain an answer, 
		or respondent is unsure of the answer are considered "MISSING, IN UNIVERSE";
	*missing and not in universe are those who are not part of the sample adult questionnaire, 
		but participated in other parts of the NHIS;
/*
proc format library=ipums.NHIS_formats;
	value vet2fm -1 = "Missing, in universe"
				0 = "Nonveteran"
				1 = "Veteran"; 
	value pain2fm -1 = "Missing, in universe"
					1 = "No"
					2 = "Yes";
	run;
*/

data check;
set zero;
	if lbpain3mo ne 0 then 
	checkit = nmiss(NP3mo_re, lbp3mo_re, fpain3mo_re, Mgrn3mo_re, jntmo_re);
	if vet = . then vetuni=0;
		else vetuni=1;
	if vetuni = 1 and vet ne 1 and vet ne 0 then vet2 = -1;
		else vet2 = vet;
	if NP3mo_re ne . and NP3mo_re ne 1 and NP3mo_re ne 2 then NP3mo_re2 = -1;
		else NP3mo_re2 = NP3mo_re;
	if lbp3mo_re ne . and lbp3mo_re ne 1 and lbp3mo_re ne 2 then lbp3mo_re2 = -1;
		else lbp3mo_re2 = lbp3mo_re;
	if fpain3mo_re ne . and fpain3mo_re ne 1 and fpain3mo_re ne 2 then fpain3mo_re2 = -1;
		else fpain3mo_re2 = fpain3mo_re;
	if Mgrn3mo_re ne . and Mgrn3mo_re ne 1 and Mgrn3mo_re ne 2 then Mgrn3mo_re2 = -1;
		else Mgrn3mo_re2 = Mgrn3mo_re;
	if jntmo_re ne . and jntmo_re ne 1 and jntmo_re ne 2 then jntmo_re2 = -1;
		else jntmo_re2 = jntmo_re;
	if lbp3mo_re ne . and lbp3mo_re ne 1 and lbp3mo_re ne 2 then lbp3mo_re2 = -1;
		else lbp3mo_re2 = lbp3mo_re;
	if legpain3mo_re ne . and legpain3mo_re ne 1 and legpain3mo_re ne 2 then legpain3mo_re2 = -1;
		else legpain3mo_re2 = legpain3mo_re;
	format vet2 vet2fm. 
			NP3mo_re2 lbp3mo_re2 fpain3mo_re2 Mgrn3mo_re2 jntmo_re2 legpain3mo_re2 pain2fm.;
	run;

proc freq data=check;
	where year ge 2002 and lbpain3mo ne 0;
	table vetuni*year*vet2*checkit;
	run;


proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet2*checkit  /row cl;
	ods output crosstabs=numbermissing;
	run;

proc print data=numbermissing;
	where F_vet2 = "Total" and checkit ne . and year ge 2002;
	var year checkit WgtFreq Frequency Percent LowerCL UpperCL;
	run;


proc surveyfreq data=check  missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetuni*year*vet2*mgrn3mo_re2  /row cl;
	ods output crosstabs = vetmgrnmiss;
	run;


data vetmgrnmiss1; set vetmgrnmiss;
	if year lt 2002 or vet2=. or mgrn3mo_re2 = . then delete;
run;

proc print data=vetmgrnmiss1;
	where mgrn3mo_re2 = -1 or mgrn3mo_re2 = 2;
	var year vet2 mgrn3mo_re2 WgtFreq Frequency RowPercent RowLowerCL RowUpperCL;
	run;

	
proc print data=vetmgrnmiss;
	where vetuni = 1 and mgrn3mo_re2 = -1 and F_vet2 = "Total" and year ge 2002;
	var year F_vet2 vet2 mgrn3mo_re2 WgtFreq Frequency Percent LowerCL UpperCL;
	run;



proc surveyfreq data=check  missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetuni*year*vet2*fpain3mo_re2  /row cl;
	ods output crosstabs = vetfpainmiss;
	run;

proc print data=vetfpainmiss;
	where vetuni = 1 and fpain3mo_re2 = -1 and F_vet2 = "Total" and year ge 2002;
	var year WgtFreq Frequency Percent LowerCL UpperCL;
	run;


proc surveyfreq data=check  missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetuni*year*vet2*NP3mo_re2  /row cl;
	ods output crosstabs = vetnpmiss;
	run;

proc print data=vetnpmiss;
	where vetuni = 1 and NP3mo_re2 = -1 and F_vet2 = "Total" and year ge 2002;
	var year WgtFreq Frequency Percent LowerCL UpperCL;
	run;

proc surveyfreq data=check  missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetuni*year*vet2*jntmo_re2  /row cl;
	ods output crosstabs = vetjntmiss;
	run;

proc print data=vetjntmiss;
	where vetuni = 1 and jntmo_re2 = -1 and F_vet2 = "Total" and year ge 2002;
	var year WgtFreq Frequency Percent LowerCL UpperCL;
	run;


proc surveyfreq data=check  missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetuni*year*vet2*lbp3mo_re2  /row cl;
	ods output crosstabs = vetlbpmiss;
	run;

proc print data=vetlbpmiss;
	where vetuni = 1 and lbp3mo_re2 = -1 and F_vet2 = "Total" and year ge 2002;
	var year WgtFreq Frequency Percent LowerCL UpperCL;
	run;
 


proc surveyfreq data=check  missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetuni*year*vet2*legpain3mo_re2  /row cl;
	ods output crosstabs = vetlegmiss;
	run;

proc print data=vetlegmiss;
	where vetuni = 1 and legpain3mo_re2 = -1 and F_vet2 = "Total" and year ge 2002;
	var year WgtFreq Frequency Percent LowerCL UpperCL;
	run;
    
