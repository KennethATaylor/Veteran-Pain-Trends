libname out "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets\SAS Output";
libname ipums "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets";

OPTIONS FMTSEARCH = ( IPUMS.NHIS_Formats );


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



proc freq data=zero;
	table mgrn3mo_re /missing;
	table fpain3mo_re /missing;
	table np3mo_re /missing;
	table lbp3mo_re /missing;
	table legpain3mo_re /missing;
	table lbp3mo_LBPonly /missing;
	table jntmo_re /missing;
	run;

data zero;
	set zero;
	if mgrn3mo_re = . then missmgrn = 1;
		else missmgrn=0;
	if  fpain3mo_re = . then missfpain  = 1;
		else missfpain=0;
	if  np3mo_re = . then missnp  = 1;
		else missnp =0;
	if jntmo_re = . then missjnt  = 1;
		else missjnt =0;
	if lbp3mo_re  = . then misslbp  = 1;
		else misslbp =0;
	if legpain3mo_re  = . then misslbp_LEG  = 1;
		else misslbp_LEG=0;
	if  lbp3mo_LBPonly = . then misslbp_ONLY= 1;
		else misslbp_ONLY =0;
	
	if missmgrn=0 and missfpain=0 and missnp=0 and missjnt=0 and misslbp=0 and misslbp_LEG=0 and misslbp_ONLY=0 then
		do;
			missing_paincount=nmiss(NP3mo_re, lbp3mo_re, fpain3mo_re, Mgrn3mo_re, jntmo_re);
			if missing_paincount = 5 then missingallpain=1;
				else missingallpain=0;
			if missing_paincount ge 1 then missing_1plus_pain = 1;
				else missing_1plus_pain = 0;
			if missing_paincount ge 4 then missing_4plus_pain = 1;
				else missing_4plus_pain = 0;
		end;
	run;
proc freq data=zero;
	*where missmgrn=0 and missfpain=0 and missnp=0 and missjnt=0 and misslbp=0 and misslbp_LEG=0 and misslbp_ONLY=0 and year ge 2002;
	where year ge 2002 and sampweight ne 0 and jntmo ne 0;
	table year*missing_paincount /missing;
	run;
	

proc surveyfreq data=zero missing;
	weight sampweight;
	strata strata;
	cluster psu;
	table year*missing_paincount;
	run;
