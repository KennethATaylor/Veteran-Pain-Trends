libname out "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets\SAS Output";
libname ipums "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets";

OPTIONS FMTSEARCH = ( IPUMS.NHIS_Formats WORK);
/*
proc format;
	value vetfm	1 = " Veteran"
				0 = "Non-Veteran";
	run;
*/


*****Any pain - crude;
data post2002_any; set out.vet_anypain_trends_v3;
	if year ge 2002;
	*variable QtrCt is 0 at 2002 1st quarter and increases by 1 every quarter after (number of quarters since start);
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER); 
	run;

data post2002_any; set post2002_any;
	n = _n_;
	run;


proc surveyreg data=post2002_any;
	class vet (ref="Non-Veteran");
	cluster n; *used to obtain robust standard errors for confidence intervals;
	model prev_anypain = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****Any pain - adjusted (repeats from above, but with adjusted output);
data post2002_any_adj; set out.adjusted_vet_anypain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_any_adj; set post2002_any_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_any_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;




*****Severe Headache / Migraine - crude;
data post2002_mgrn; set out.vet_mgrn_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_mgrn; set post2002_mgrn;
	n = _n_;
	run;


proc surveyreg data=post2002_mgrn;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_mgrn = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****Severe Headache / Migraine - adjusted;
data post2002_mgrn_adj; set out.adjusted_vet_mgrn_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_mgrn_adj; set post2002_mgrn_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_mgrn_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****Facial Pain - crude;
data post2002_fpain; set out.vet_facepain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_fpain; set post2002_fpain;
	n = _n_;
	run;


proc surveyreg data=post2002_fpain;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_fpain = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****Facial Pain - adjusted;
data post2002_fpain_adj; set out.adjusted_vet_facepain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_fpain_adj; set post2002_fpain_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_fpain_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****Neck Pain - crude;
data post2002_NP; set out.vet_np_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_NP; set post2002_NP;
	n = _n_;
	run;


proc surveyreg data=post2002_NP;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_np = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****Neck Pain - adjusted;
data post2002_NP_adj; set out.adjusted_vet_NP_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_NP_adj; set post2002_NP_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_NP_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****JOINT pain - crude;
data post2002_JNT; set out.vet_JNTpain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_JNT; set post2002_JNT;
	n = _n_;
	run;


proc surveyreg data=post2002_JNT;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_JNT = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****JOINT pain - adjusted;
data post2002_JNT_adj; set out.adjusted_vet_JNTpain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_JNT_adj; set post2002_any_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_JNT_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****LBP (all) - crude;

data post2002_LBP; set out.vet_lbp_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_LBP; set post2002_LBP;
	n = _n_;
	run;


proc surveyreg data=post2002_LBP;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_lbp = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****LBP (all) - adjusted;
data post2002_LBP_adj; set out.adjusted_vet_lbp_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_LBP_adj; set post2002_LBP_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_LBP_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****LBP ONLY (no leg pain) - crude;
data post2002_LBPonly; set out.vet_lbp_only_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_LBPonly; set post2002_LBPonly;
	n = _n_;
	run;


proc surveyreg data=post2002_LBPonly;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_lbponly = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****LBP ONLY (no leg pain) - adjusted;
data post2002_LBPonly_adj; set out.adjusted_vet_lbp_only_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_LBPonly_adj; set post2002_LBPonly_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_LBPonly_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****LBP with leg pain - crude;
data post2002_LBP_legpain; set out.vet_lbp_legpain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_LBP_legpain; set post2002_LBP_legpain;
	n = _n_;
	run;


proc surveyreg data=post2002_LBP_legpain;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_lbp_wleg = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****LBP with leg pain - adjusted;
data post2002_LBP_legpain_adj; set out.adjusted_vet_lbp_leg_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_LBP_legpain_adj; set post2002_LBP_legpain_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_LBP_legpain_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;


*****Multiple Pain - crude;
data post2002_multi; set out.vet_multipain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_multi; set post2002_multi;
	n = _n_;
	run;


proc surveyreg data=post2002_multi;
	class vet (ref="Non-Veteran");
	cluster n;
	model prev_multipain = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;



*****Multiple Pain - adjusted;
data post2002_multi_adj; set out.adjusted_vet_multipain_trends_v3;
	if year ge 2002;
	QtrCt = ((YEAR - 2001) * 4) - (5-QUARTER);
	run;

data post2002_multi_adj; set post2002_multi_adj;
	n = _n_;
	run;


proc surveyreg data=post2002_multi_adj;
	class vet (ref="Non-Veteran");
	cluster n;
	model mu = vet qtrct vet*qtrct / CLPARM SOLUTION;
	run;
