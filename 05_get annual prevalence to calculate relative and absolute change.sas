libname out "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets\SAS Output";
libname ipums "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets";

OPTIONS FMTSEARCH = ( IPUMS.NHIS_Formats WORK);



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



proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*lbp3mo_re  /row cl;
	ods output crosstabs=annualLBP;
	run;

data annualLBP1; set annualLBP;
	if year ge 2002 and lbp3mo_re = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualLBP1;
	by descending vet year;
	run;

proc print data=annualLBP1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;



proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*legpain3mo_re  /row cl;
	ods output crosstabs=annualLEG;
	run;

data annualLEG1; set annualLEG;
	if year ge 2002 and legpain3mo_re = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualLEG1;
	by descending vet year;
	run;

proc print data=annualLEG1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;




proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*lbp3mo_LBPonly  /row cl;
	ods output crosstabs=annualLBPonly;
	run;

data annualLBPonly1; set annualLBPonly;
	if year ge 2002 and lbp3mo_LBPonly = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualLBPonly1;
	by descending vet year;
	run;

proc print data=annualLBPonly1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;



proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*anypain3mo  /row cl;
	ods output crosstabs=annualany;
	run;

data annualany1; set annualany;
	if year ge 2002 and anypain3mo = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualany1;
	by descending vet year;
	run;

proc print data=annualany1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;



proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*Mgrn3mo_re  /row cl;
	ods output crosstabs=annualmgrn;
	run;

data annualmgrn1; set annualmgrn;
	if year ge 2002 and Mgrn3mo_re = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualmgrn1;
	by descending vet year;
	run;

proc print data=annualmgrn1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;




proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*fpain3mo_re  /row cl;
	ods output crosstabs=annualfpain;
	run;

data annualfpain1; set annualfpain;
	if year ge 2002 and fpain3mo_re = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualfpain1;
	by descending vet year;
	run;

proc print data=annualfpain1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;



proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*NP3mo_re  /row cl;
	ods output crosstabs=annualNP;
	run;

data annualNP1; set annualNP;
	if year ge 2002 and NP3mo_re = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualNP1;
	by descending vet year;
	run;

proc print data=annualNP1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;




proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*jntmo_re  /row cl;
	ods output crosstabs=annualJNT;
	run;

data annualJNT1; set annualJNT;
	if year ge 2002 and jntmo_re = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualJNT1;
	by descending vet year;
	run;

proc print data=annualJNT1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;





proc surveyfreq data=check;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*vet*multipain3mo  /row cl;
	ods output crosstabs=annualmulti;
	run;

data annualmulti1; set annualmulti;
	if year ge 2002 and multipain3mo = 2;
	if vet ne 1 and vet ne 0 then delete;
	run;
	
proc sort data= annualmulti1;
	by descending vet year;
	run;

proc print data=annualmulti1;
	where year = 2002 or year = 2018;
	var year vet wgtfreq rowpercent rowstderr rowlowercl rowuppercl;
run;
