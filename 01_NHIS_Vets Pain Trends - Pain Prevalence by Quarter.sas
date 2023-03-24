libname out "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets\SAS Output";
libname ipums "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets";

OPTIONS FMTSEARCH = ( IPUMS.NHIS_Formats );

/*
proc format library = IPUMS.NHIS_Formats;
	value vetfm	1 = " Veteran"
				0 = "Non-Veteran";
	run;
*/

data zero;
	set out.nhis_vets_v3;
	*create veteran variable that uses veteran status indicator pre-and-post NHIS variable change;
	if year le 2010 then
				do;
					if HONDSCG = 1 then vet = 1;
						else if HONDSCG = 2 then vet = 0;
							else if HONDSCG = 0 then vet = .;
								else if HONDSCG = 7 then vet = .R;
									else if HONDSCG = 8 then vet = .N;
										else if HONDSCG = 9 then vet = .U;
				end;
	if year ge 2011 then 
		do;
			if ARMFEV = 20 then vet = 1;
				else if ARMFEV = 10 then vet = 0;
					else if ARMFEV = 00 then vet = .;
						else if ARMFEV = 97 then vet = .R;
							else if ARMFEV = 98 then vet = .N;
								else if ARMFEV = 99 then vet = .U;
		end;

	*recode neck pain;
	if (NECKPAIN3MO = 1 or NECKPAIN3MO = 2) then NP3mo_re = NECKPAIN3MO;
			else if NECKPAIN3MO = 0 then NP3mo_re = .;
				else if NECKPAIN3MO = 7 then NP3mo_re = .R;
					else if NECKPAIN3MO = 8 then NP3mo_re = .N;
						else if NECKPAIN3MO = 9 then NP3mo_re = .U;

	*recode migraine/severe headache;
	if (MIGRAIN3MO = 1 or MIGRAIN3MO = 2) then Mgrn3mo_re = MIGRAIN3MO;
		else if MIGRAIN3MO = 0 then Mgrn3mo_re = .;
			else if MIGRAIN3MO = 7 then Mgrn3mo_re = .R;
				else if MIGRAIN3MO = 8 then Mgrn3mo_re = .N;
					else if MIGRAIN3MO = 9 then Mgrn3mo_re = .U;

	*recode facial pain;
	if (facepain3mo = 1 or facepain3mo = 2) then fpain3mo_re = facepain3mo;
		else if facepain3mo = 0 then fpain3mo_re = .;
			else if facepain3mo = 7 then fpain3mo_re = .R;
				else if facepain3mo = 8 then fpain3mo_re = .N;
					else if facepain3mo = 9 then fpain3mo_re = .U;

	*recode LBP;
	if (lbpain3mo = 1 or lbpain3mo = 2) then lbp3mo_re = lbpain3mo;
			else if lbpain3mo = 0 then lbp3mo_re = .;
				else if lbpain3mo = 7 then lbp3mo_re = .R;
					else if lbpain3mo = 8 then lbp3mo_re = .N;
						else if lbpain3mo = 9 then lbp3mo_re = .U;

	*recode LBP (with and without leg pain);
	if (legpain3mo = 1 or legpain3mo = 2) then legpain3mo_re = legpain3mo;
		else if legpain3mo=0 and lbpain3mo = 0 then legpain3mo_re = .;
			else if legpain3mo = 7 then legpain3mo_re = .R;
				else if legpain3mo = 8 then legpain3mo_re = .N;
					else if legpain3mo = 9 then legpain3mo_re = .U;
						else if legpain3mo = 0 and lbpain3mo ne 0 then legpain3mo_re = lbp3mo_re;
	
		*leg pain question only asked to individuals indicating they had LBP
		recoding so that those who said they had no LBP to the first question also
		reflect "no" for LBP with associated leg pain;
	if lbp3mo_re=2 and legpain3mo_re=1 then lbp3mo_LBPonly = 2;
		else if lbp3mo_re = 2 and legpain3mo_re = 2 then lbp3mo_LBPonly = 1;
			else lbp3mo_LBPonly = legpain3mo_re;

	*recode joint pain;
	if (jntmo = 1 or jntmo = 2) then jntmo_re = jntmo;
			else if jntmo = 0 then jntmo_re = .;
				else if jntmo = 7 then jntmo_re = .R;
					else if jntmo = 8 then jntmo_re = .N;
						else if jntmo = 9 then jntmo_re = .U;

	*create ANY pain variable;
	array painvars[*] NP3mo_re lbp3mo_re fpain3mo_re Mgrn3mo_re jntmo_re;

	*if any pain complaint present, then anypain3mo = "yes";
	anypain3mo = (2 in painvars); 

	*multiple pain complaints
		does not include legpain variable since it is a subgroup of people answering yes to LBP3mo;
	*2 = yes and 1 = no from IPUMS harmonization, code below accounts for this coding to calculate 
		cumulative number of pain complaints for each person;
	paincount = sum(NP3mo_re, lbp3mo_re, fpain3mo_re, Mgrn3mo_re, jntmo_re) - (5-(nmiss(NP3mo_re, lbp3mo_re, fpain3mo_re, Mgrn3mo_re, jntmo_re)));
	
	*if 2 or more pain complaints, then person classified as having "multiple pain complaints";
	if paincount gt 1 then multipain3mo = 2;
		else if paincount = 0 or paincount = 1 then multipain3mo = 1;


	*set anypain3mo to missing if paincount missing (no pain variables recorded) 
			and turning into 1-2 var instead of 0-1 to match coding of other pain complaint variables;
	if paincount=. then anypain3mo=.;
		else anypain3mo = anypain3mo+1;

	*recoding special missing for age;
	if age = 997 then age = .R;
		else if age = 998 then age = .N;
			else if age = 999 then age = .U;

	*recoding special missing for race;
	if racenew = 997 then racenew = .R;
		else if racenew = 998 then racenew = .N;
			else if racenew = 999 then racenew = .U;
	if racea = 970 then racea = .R;
		else if racea = 980 then racea = .N;
			else if racea = 990 then racea = .U;
	
	*recoding special missing for Hispanic ethnicity status indicator;
	if HISPYN = 7 then HISPYN = .R;
		else if HISPYN = 8 then HISPYN = .N;
			else if HISPYN = 9 then HISPYN = .U;

	*converts annual sample weight back to quarterly weights;
	quarter_sampwt = sampweight*4;		

	*creates flag variable for adults, but likely unecessary since
		sample child not asked pain questions (would not count in weighting);	
	if age ge 18 then adult = 1;
		else adult = 0;

	*creates flag variable for 2002 (some earlier data were in original pull 
		- only interested in post-2002 trends;
	if YEAR ge 2002 then post2002 = 1;
		else post2002 = 0;

	format NP3mo_re NECKPAIN3MO_f. lbp3mo_re lbp3mo_LBPonly lbpain3mo_f. legpain3mo_re legpain3mo_f.
			fpain3mo_re facepain3mo_f. Mgrn3mo_re MIGRAIN3MO_f.
			vet vetfm. multipain3mo anypain3mo NECKPAIN3MO_f. jntmo_re jntmo_f.;
run;


***************GET DATASET LIMITED TO ADULTS 2002-2018 TO USE
				WITH OBSMARGINS STATEMENT FOR ASSIGNING CATEGORICAL COVARIATE 
				  VALUES TO THEIR OBSERVED DISTRIBUTIONS FOR THE OVERALL STUDY PERIOD;

data just_adults;
	set zero;

	*original annual weighting variable divided by number of study years (17)
	** OBSMARGINS will use this weight to determine what value to set for categorical
		covariates when calculating adjusted prevalence estimates;
	wt17 = sampweight / 17;

	*OBSMARGINS looks for the same weighting variable called in the weight statement 
		for proc surveylogistic (quarter_sampwt). Since we want to use wt17 in just_adults to determine categorical
		covariate totals, we rename wt17 in just_adults to quarter_sampwt. This makes OBSMARGINS use mean covariate 
		distributions for categorical variables observed across the study period;
		** this is only used to set the values for covariates in the LSMEANS statement after 
			proc surveylogistic uses the actual quarter_sampwt variable from the dataset "zero" to estimate
			regression coefficients in addition to the strata and cluster variables to correctly estimate variance;
	quarter_sampwt = wt17;

	*limiting just adjuts to adults from 2002-2018;
	if adult=1 and post2002 = 1;

	run;

*get mean observed in adults across the 17-year study period to plug into the AT option in LSMEANS
	to set the age covariate to this value when estimating the adjusted prevalence;
proc surveymeans data = just_adults;
	weight wt17;
	strata strata;
	cluster psu;
	var age;
	run;

*****MEAN AGE = 46.37;



****************ANY PAIN prevalence by quarter;

proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*anypain3mo/ row cl;
	ods output CrossTabs=vetanypain;
run;

*limit to just prevalence estimates;

data one; set vetanypain (
	drop= _SkipLine F_anypain3mo F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_AnyPain RowStdErr=prev_AnyPain_StdErr RowLowerCL=prevAnyPainLowerCL RowUpperCL=prevAnyPainUpperCL)
	);
	if anypain3mo = 2;
	if vet = . then delete;
	drop anypain3mo table Frequency WgtFreq StdDev;
	label prev_AnyPain = "Any Pain Prevalence"
			prevAnyPainLowerCL = "95% Lower Confidence Limit, Any Pain Prevalence"
			prevAnyPainUpperCL = "95% Upper Confidence Limit, Any Pain Prevalence"
			prev_AnyPain_StdErr = "Standard Error of Any Pain Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;


*output permanent dataset;
data out.vet_AnyPain_trends_v3; set one;
run;



*get adjusted estimates;
proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model anypain3mo(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
		*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
			**AT option above sets age covariate to 46.37;*
			**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
				(other than those in the interaction term) in the dataset just_adults, which weights
				based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansAnyPain;
run;

*limit to preavlence estimates;
data out.adjusted_vet_AnyPain_trends_v3; set LsmeansAnyPain;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Any Pain Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Any Pain Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Any Pain Prevalence, Adjusted"
			StdErrMu = "Standard Error of Any Pain Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_AnyPain_trends_v3; by vet year quarter; run;





****************FACIAL PAIN prevalence by quarter;
proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*fpain3mo_re/ row cl;
	ods output CrossTabs=vetfpain;
run;

*limit to prevalence estimate data;
data one; set vetfpain (
	drop= _SkipLine F_fpain3mo_re F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_fpain RowStdErr=prev_fpain_StdErr RowLowerCL=prevfpainLowerCL RowUpperCL=prevfpainUpperCL)
	);
	if fpain3mo_re = 2;
	if vet = . then delete;
	drop fpain3mo_re table Frequency WgtFreq;
	label prev_fpain = "Facial Pain Prevalence"
			prevfpainLowerCL = "95% Lower Confidence Limit, Facial Pain Prevalence"
			prevfpainUpperCL = "95% Upper Confidence Limit, Facial Pain Prevalence"
			prev_fpain_StdErr = "Standard Error of Facial Pain Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_facepain_trends_v3; set one;
run;



*get adjusted preavlence estimates;
proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model fpain3mo_re(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
		*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
			**AT option above sets age covariate to 46.37;*
			**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
				(other than those in the interaction term) in the dataset just_adults, which weights
				based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansFacePain;
run;

*limit to prevalence estimates;
data out.adjusted_vet_facepain_trends_v3; set LsmeansFacePain;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Facial Pain Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Facial Pain Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Facial Pain Prevalence, Adjusted"
			StdErrMu = "Standard Error of Facial Pain Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_facepain_trends_v3; by vet year quarter; run;




****************SEVERE HEADACHE / MIGRAINE prevalence by quarter;


proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*Mgrn3mo_re/ row cl;
	ods output CrossTabs=vetMGRN;
run;

*limit to prevalence estimates;
data one; set vetMGRN (
	drop= _SkipLine F_Mgrn3mo_re F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_MGRN RowStdErr=prev_MGRN_StdErr RowLowerCL=prevMGRNLowerCL RowUpperCL=prevMGRNUpperCL)
	);
	if Mgrn3mo_re = 2;
	if vet = . then delete;
	drop Mgrn3mo_re table Frequency WgtFreq StdDev;
	label prev_MGRN = "Severe Headache/Migraine Prevalence"
			prevMGRNLowerCL = "95% Lower Confidence Limit, Severe Headache/Migraine Prevalence"
			prevMGRNUpperCL = "95% Upper Confidence Limit, Severe Headache/Migraine Prevalence"
			prev_MGRN_StdErr = "Standard Error of Severe Headache/Migraine Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_mgrn_trends_v3; set one;
run;


*get adjusted estimates;

proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model Mgrn3mo_re(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
		lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
		*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
			**AT option above sets age covariate to 46.37;*
			**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
				(other than those in the interaction term) in the dataset just_adults, which weights
				based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansMgrn;
run;

*limit to prevalence estimates;
data out.adjusted_vet_MGRN_trends_v3; set LsmeansMgrn;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Severe Headache/Migraine Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Severe Headache/Migraine Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Severe Headache/Migraine Prevalence, Adjusted"
			StdErrMu = "Standard Error of Severe Headache/Migraine Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_MGRN_trends_v3; by vet year quarter; run;




****************NECK PAIN prevalence by quarter;

proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*NP3mo_re/ row cl;
	ods output CrossTabs=vetNP;
run;

*limit to prevalence estimates;
data one; set vetNP (
	drop= _SkipLine F_NP3mo_re F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_NP RowStdErr=prev_NP_StdErr RowLowerCL=prevNPLowerCL RowUpperCL=prevNPUpperCL)
	);
	if NP3mo_re = 2;
	if vet = . then delete;
	drop NP3mo_re table Frequency WgtFreq StdDev;
	label prev_NP = "Neck Pain Prevalence"
			prevNPLowerCL = "95% Lower Confidence Limit, Neck Pain Prevalence"
			prevNPUpperCL = "95% Upper Confidence Limit, Neck Pain Prevalence"
			prev_NP_StdErr = "Standard Error of Neck Pain Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_NP_trends_v3; set one;
run;



*get adjusted estimates;
proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model NP3mo_re(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
		lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
		*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
			**AT option above sets age covariate to 46.37;*
			**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
				(other than those in the interaction term) in the dataset just_adults, which weights
				based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansNP;
run;

*limit to prevalence estiamtes;
data out.adjusted_vet_NP_trends_v3; set LsmeansNP;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Neck Pain Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Neck Pain Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Neck Pain Prevalence, Adjusted"
			StdErrMu = "Standard Error of Neck Pain Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_NP_trends_v3; by vet year quarter; run;



****************JOINT PAIN prevalence by quarter;

proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*jntmo_re/ row cl;
	ods output CrossTabs=vetjntpain;
run;

*limit to prevalence estimates;

data one; set vetjntpain (
	drop= _SkipLine F_jntmo_re F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_JNT RowStdErr=prev_JNT_StdErr RowLowerCL=prevJNTLowerCL RowUpperCL=prevJNTUpperCL)
	);
	if jntmo_re = 2;
	if vet = . then delete;
	drop jntmo_re table Frequency WgtFreq StdDev;
	label prev_JNT = "Joint Pain Prevalence"
			prevJNTLowerCL = "95% Lower Confidence Limit, Joint Pain Prevalence"
			prevJNTUpperCL = "95% Upper Confidence Limit, Joint Pain Prevalence"
			prev_JNT_StdErr = "Standard Error of Joint Pain Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_JNTpain_trends_v3; set one;
run;



*get adjusted estimates;
proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model jntmo_re(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
	*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
		**AT option above sets age covariate to 46.37;*
		**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
			(other than those in the interaction term) in the dataset just_adults, which weights
			based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansJNTPain;
run;

*limit to prevalence estimates;
data out.adjusted_vet_JNTpain_trends_v3; set LsmeansJNTPain;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Joint Pain Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Joint Pain Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Joint Pain Prevalence, Adjusted"
			StdErrMu = "Standard Error of Joint Pain Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_JNTpain_trends_v3; by vet year quarter; run;




****************LOW BACK PAIN prevalence by quarter;


*Get LBP prevalence for each quarter;
proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*lbp3mo_re/ row cl;
	ods output CrossTabs=vetlbp;
run;


*clean output -- keep prevalence estimates;
data one; set vetlbp (
	drop= _SkipLine F_lbp3mo_re F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_lbp RowStdErr=prev_LBP_StdErr RowLowerCL=prevlbpLowerCL RowUpperCL=prevlbpUpperCL)
	);
	if lbp3mo_re = 2;
	if vet = . then delete;
	drop lbp3mo_re;
	label prev_lbp = "Low Back Pain Prevalence"
			prevlbpLowerCL = "95% Lower Confidence Limit, LBP Prevalence"
			prevlbpUpperCL = "95% Upper Confidence Limit, LBP Prevalence"
			prev_LBP_StdErr = "Standard Error of LBP Prevalence"
			vet = "Veteran Status";
	run;


proc sort data=one; by vet year quarter; run;


*output permanent dataset; 
data out.vet_lbp_trends_v3; set one;
run;




*get adjusted prevalence estimates for each quarter;

proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model lbp3mo_re(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
	*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
		**AT option above sets age covariate to 46.37;*
		**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
			(other than those in the interaction term) in the dataset just_adults, which weights
			based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansLBP;
run;

*output permanent dataset;

data out.adjusted_vet_LBP_trends_v3; set LsmeansLBP;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Low Back Pain Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, LBP Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, LBP Prevalence, Adjusted"
			StdErrMu = "Standard Error of LBP Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_LBP_trends_v3; by vet year quarter; run;



****************LOW BACK PAIN (SUBGROUPS) prevalence by quarter;


*LBP Only prevalence;

proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*lbp3mo_LBPonly/ row cl;
	ods output CrossTabs=vetLBPonly;
run;

*limit to prevalence estimates;

data one; set vetLBPonly (
	drop= _SkipLine F_lbp3mo_LBPonly F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_LBPonly RowStdErr=prev_LBPonly_StdErr RowLowerCL=prevLBPonlyLowerCL RowUpperCL=prevLBPonlyUpperCL)
	);
	if lbp3mo_LBPonly = 2;
	if vet = . then delete;
	drop lbp3mo_LBPonly table Frequency WgtFreq StdDev;
	label prev_LBPonly = "Low Back Pain Only Prevalence"
			prevLBPonlyLowerCL = "95% Lower Confidence Limit, Low Back Pain Only Prevalence"
			prevLBPonlyUpperCL = "95% Upper Confidence Limit, Low Back Pain Only Prevalence"
			prev_LBPonly_StdErr = "Standard Error of Low Back Pain Only Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_LBP_ONLY_trends_v3; set one;
run;



*get adjusted estimates;
proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model lbp3mo_LBPonly(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
	*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
		**AT option above sets age covariate to 46.37;*
		**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
			(other than those in the interaction term) in the dataset just_adults, which weights
			based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansLBP_only;
run;

*limit to prevalence estimate data;
data out.adjusted_vet_LBP_ONLY_trends_v3; set LsmeansLBP_only;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Low Back Pain Only  Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Low Back Pain Only Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Low Back Pain Only  Prevalence, Adjusted"
			StdErrMu = "Standard Error of Low Back Pain Only  Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_LBP_ONLY_trends_v3; by vet year quarter; run;




******LBP with Leg Pain prevalence;


proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*legpain3mo_re/ row cl;
	ods output CrossTabs=vetLBP_legpain;
run;

data one; set vetLBP_legpain (
	drop= _SkipLine F_legpain3mo_re F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_LBP_wleg RowStdErr=prev_LBP_wleg_StdErr RowLowerCL=prevLBP_wlegLowerCL RowUpperCL=prevLBP_wlegUpperCL)
	);
	if legpain3mo_re = 2;
	if vet = . then delete;
	drop legpain3mo_re table Frequency WgtFreq StdDev;
	label prev_LBP_wleg = "Low Back Pain with Leg Pain Prevalence"
			prevLBP_wlegLowerCL = "95% Lower Confidence Limit, Low Back Pain with Leg Pain Prevalence"
			prevLBP_wlegUpperCL = "95% Upper Confidence Limit, Low Back Pain with Leg Pain Prevalence"
			prev_LBP_wleg_StdErr = "Standard Error of Low Back Pain with Leg Pain Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_LBP_LEGPAIN_trends_v3; set one;
run;


*get adjusted estimates;

proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model legpain3mo_re(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
	*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
		**AT option above sets age covariate to 46.37;*
		**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
			(other than those in the interaction term) in the dataset just_adults, which weights
			based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansLBP_LEGPain;
run;

*limit to prevalence estimates;
data out.adjusted_vet_LBP_LEG_trends_v3; set LsmeansLBP_LEGPain;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Low Back Pain with Leg Pain  Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Low Back Pain with Leg Pain Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Low Back Pain with Leg Pain  Prevalence, Adjusted"
			StdErrMu = "Standard Error of Low Back Pain with Leg Pain Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_LBP_LEG_trends_v3; by vet year quarter; run;



****************MULTIPLE PAIN COMPLAINT prevalence by quarter;


proc surveyfreq data=zero;
	weight quarter_sampwt;
	strata strata;
	cluster psu;
	table year*QUARTER*vet*Multipain3mo/ row cl;
	ods output CrossTabs=vetMultipain;
run;

*limit to prevalence estimates;
data one; set vetMultipain (
	drop= _SkipLine F_Multipain3mo F_vet percent stderr LowerCL UpperCL 
	rename=(RowPercent=prev_MultiPain RowStdErr=prev_MultiPain_StdErr RowLowerCL=prevMultiPainLowerCL RowUpperCL=prevMultiPainUpperCL)
	);
	if Multipain3mo = 2;
	if vet = . then delete;
	drop Multipain3mo table Frequency WgtFreq StdDev;
	label prev_MultiPain = "Multiple Pain Prevalence"
			prevMultiPainLowerCL = "95% Lower Confidence Limit, Multiple Pain Prevalence"
			prevMultiPainUpperCL = "95% Upper Confidence Limit, Multiple Pain Prevalence"
			prev_MultiPain_StdErr = "Standard Error of Multiple Pain Prevalence"
			vet = "Veteran Status";
	run;



proc sort data=one; by vet year quarter; run;

data out.vet_MultiPain_trends_v3; set one;
run;


*get adjusted prevalence;

proc surveylogistic data=zero;
	strata strata;
	cluster psu;
	weight quarter_sampwt;
	class year quarter vet HISPYN racenew sex / param=glm;
	model Multipain3mo(descending) = year*quarter*vet age sex HISPYN racenew / link=logit ;
	lsmeans year*quarter*vet / ilink cl means at age=46.37 obsmargins=just_adults plots=none;
	*can add 'e' option to LSMEANS statement to observe the assigned covariate values:
		**AT option above sets age covariate to 46.37;*
		**OBSMARGINS=just_adults option uses the observed distributions of categorical covariates
			(other than those in the interaction term) in the dataset just_adults, which weights
			based on the mean marginal distribution observed across the study period;
	ods output LSMeans = LsmeansMultiPain;
run;

*limit to prevalence estimates;
data out.adjusted_vet_MultiPain_trends_v3; set LsmeansMultiPain;
	keep year quarter vet Mu LowerMu UpperMu StdErrMu;
	label vet = "Veteran Status"
			Mu = "Multiple Pain Prevalence, Adjusted"
			LowerMu = "95% Lower Confidence Limit, Multiple Pain Prevalence, Adjusted"
			UpperMu = "95% Upper Confidence Limit, Multiple Pain Prevalence, Adjusted"
			StdErrMu = "Standard Error of Multiple Pain Prevalence, Adjusted";
	Mu = Mu*100;
	LowerMu = LowerMu*100;
	UpperMu = UpperMu*100;
	StdErrMu = StdErrMu*100;
	run;

proc sort data=out.adjusted_vet_MultiPain_trends_v3; by vet year quarter; run;
