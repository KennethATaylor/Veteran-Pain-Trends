libname out "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets\SAS Output";
libname ipums "C:\Users\kt250\Box\SENSITIVE Folder kt250\NHIS Veterans and Pain\NHIS Vets";

OPTIONS FMTSEARCH = ( IPUMS.NHIS_Formats );

data anypain; set out.vet_anypain_trends_v3;
	run;

proc sort data= anypain;
	by descending vet prev_AnyPain;
	run;

proc print data=anypain;
	where year ge 2002;
run;



data mgrnpain; set out.vet_mgrn_trends_v3;
	run;

proc sort data= mgrnpain;
	by descending vet prev_MGRN;
	run;

proc print data=mgrnpain;
	where year ge 2002;
run;



data facepain; set out.vet_facepain_trends_v3;
	run;

proc sort data= facepain;
	by descending vet  prev_fpain;
	run;

proc print data=facepain;
	where year ge 2002;
run;


data neckpain; set out.vet_NP_trends_v3;
	run;

proc sort data= neckpain;
	by descending vet  prev_np;
	run;

proc print data=neckpain;
	where year ge 2002;
run;



data jointpain; set out.vet_JNT_trends_v3;
	run;

proc sort data= jointpain;
	by descending vet  prev_JNT;
	run;

proc print data=jointpain;
	where year ge 2002;
run;


data backpain; set out.vet_LBP_trends_v3;
	run;

proc sort data= backpain;
	by descending vet  prev_LBP;
	run;

proc print data=backpain;
	where year ge 2002;
run;



data backpainonly; set out.vet_LBP_only_trends_v3;
	run;

proc sort data= backpainonly;
	by descending vet  prev_LBPonly;
	run;

proc print data=backpainonly;
	where year ge 2002;
run;



data backpainleg; set out.vet_LBP_legpain_trends_v3;
	run;

proc sort data= backpainleg;
	by descending vet  prev_LBP_wleg;
	run;

proc print data=backpainleg;
	where year ge 2002;
run;

data multipain; set out.vet_multipain_trends_v3;
	run;

proc sort data= multipain;
	by descending vet  prev_multipain;
	run;

proc print data=multipain;
	where year ge 2002;
run;



