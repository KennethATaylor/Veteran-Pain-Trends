data one1;
	set zero;
	run;

*get ANNUAL sex, race, and ethnicity estimates by veteran status for supplemental table;
proc surveyfreq data=one1 nosummary;
	weight sampweight;
	strata strata;
	cluster psu;
	table post2002*year*vet*(sex racenew HISPYN) /   row cl nostd nofreq nototal domain=row;
	ods output OneWay = CatVarbyVet;
	run;

*results in same as above, just outputing different table based on statements used;
proc surveyfreq data=one1 nosummary;
	weight sampweight;
	strata strata;
	cluster psu;
	table post2002*year*vet*(sex racenew HISPYN) /   row cl nostd nofreq nototal nocellpercent;
	ods output CrossTabs = CatVarbyVet;
	run;

data CatVarbyVet1; set CatVarbyVet 
		(drop = F_vet F_SEX WgtFreq LowerCL UpperCL
			_SkipLine F_RACENEW F_HISPYN);
	if post2002 = 1; 	*limit to data after 2002;
	if sex ne 1;		*limit to female sex prevalence;
	if HISPYN ne 1;		*limit to Hispanic ethnicity prevalence;
	drop post2002;
	run;

proc print data=CatVarbyVet1 (obs=5);
run;


	

*get ANNUAL mean age by Veteran Status for supplemental table - limit to post-2002;
proc surveymeans data=one1 mean clm nmiss sumwgt plots=none;
	weight sampweight;
	strata strata;
	cluster psu;
	domain post2002('1')*year*vet;
	var age;
	ods output Domain = Meanage;
	run;


data meanage1; set meanage;
	drop DomainLabel post2002 VarName StdErr;
	rename mean=meanage;
	run;



*outupt ANNUAL mean age for supplemental table;
proc tabulate data=meanage1 ;
	class vet year;
   var meanage LowerCLMean UpperCLMean;
   table vet='Veteran Status'*(meanage='Age, mean'*sum='' LowerCLMean='Lower CL'*sum='' UpperCLMean='Upper CL'*sum=''),
			year='Survey Year';
   title 'Age';
run;



*outupt ANNUAL weighted N for supplemental table;
proc tabulate data=meanage1 ;
	class vet year ;
   var SumWgt;
   table vet='Veteran Status'*SumWgt='Weighted N'*sum='',
			year='Survey Year';
   title 'Weighted N';
run;



*outupt ANNUAL sex distribution for supplemental table;
data sex; set CatVarbyVet1;
	if sex ne .;
	run;

proc tabulate data=sex ;
	class vet year sex;
   var RowPercent RowLowerCL RowUpperCL;
   table vet='Veteran Status'*sex*(rowpercent=' '*sum=' ' RowLowerCL='Lower CL'*sum='' RowUpperCL='Upper CL'*sum=''),
			year='Survey Year';
   title 'Sex';
run;


*outupt ANNUAL race distribution for supplemental table;
data race; set CatVarbyVet1;
	if racenew ne .;
	run;


proc tabulate data=race ;
	class vet year racenew;
   var RowPercent RowLowerCL RowUpperCL;
   table vet='Veteran Status'*racenew='Race'*(rowpercent=' '*sum=' ' RowLowerCL='Lower CL'*sum='' RowUpperCL='Upper CL'*sum=''),
			year='Survey Year';
   title 'Race';
run;


*outupt ANNUAL ethnicitiy distribution for supplemental table;
data hisp; set CatVarbyVet1;
	if hispyn ne .;
	run;

proc tabulate data=hisp ;
	class vet year hispyn;
   var RowPercent RowLowerCL RowUpperCL;
   table vet='Veteran Status'*hispyn='Hispanic Ethinicity'*(rowpercent=' '*sum=' ' RowLowerCL='Lower CL'*sum='' RowUpperCL='Upper CL'*sum=''),
			year='Survey Year';
   title 'Hispanic ethnicity';
run;



*get missing veteran status estimates for supplemental table;
data one1; set one1;
	if vet = . then vetmiss=1;
		else vetmiss=0;
	run;


proc surveyfreq data=one1 missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table vetmiss*year*vet /   row cl nostd domain=row ;
	ods output CrossTabs = vetbyyear;
	run;

data verbyyear1; set vetbyyear;
	if vet = . or vet = 0 or vet = 1 then delete;
	run;

proc print data=verbyyear1;
	var year vet WgtFreq;
	run;


data verbyyear2; set vetbyyear;
	if vet = . or vet = 0 or year lt 2002 or vetmiss = 1 then delete;
	run;

proc print data=verbyyear2;
	var year vet RowPercent RowLowerCL RowUpperCL;
	run;


data verbyyear3; set vetbyyear;
	if vet = 1 or vet = 0 or year lt 2002 then delete;
	run;

proc print data=verbyyear3;
	var year F_vet WgtFreq Frequency;
	run;

data verbyyear4; set vetbyyear;
	if vet = 1 or vet = 0 or vet = . or year lt 2002 then delete;
	run;

proc print data=verbyyear4;
	var year vet RowPercent RowLowerCL RowUpperCL;
	run;


data verbyyear5; set vetbyyear;
	if vet = 1 or vet = 0 or vet = .R or vet = .N or vet = .U or year lt 2002 then delete;
	run;

proc print data=verbyyear5;
	var year F_vet WgtFreq Frequency;
	run;

data vetbyyear6; set vetbyyear;
	if vet = . or year lt 2002 then delete;
	run;

proc print data=vetbyyear6;
	var year F_vet WgtFreq Frequency;
	run;
