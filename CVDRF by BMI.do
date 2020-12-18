*----------------------------------------.
*RF by BMI.
*Obesity Journal. December 2020.
*Clean dataset created by prior SPSS file.
*------------------------------------------.

use "N:\RF by BMI\AnalysisFile_Dec2020.dta", clear
renvars, lower

*-------------------.
*Table 1.
*-------------------.

generate year=0
replace year=1 if inlist(hseyear,1,2,3,4)
replace year=2 if inlist(hseyear,5,6,7,8)
replace year=3 if inlist(hseyear,9,10,11,12)
replace year=4 if inlist(hseyear,13,14,15,16)
label define yearlbl 1 "2003-06" 2 "2007-10" 3 "2011-14" 4 "2015-18" 
label values year yearlbl
tab1 year
keep if bmivg52>=0

svyset [pweight=wt_int],psu(point)

*sex.
tab sex year
svy:tab sex year, column

*age.
gen agegroup4=0
replace agegroup4=1 if inlist(ag16g10,1,2)
replace agegroup4=2 if inlist(ag16g10,3,4)
replace agegroup4=3 if inlist(ag16g10,5,6)
replace agegroup4=4 if inlist(ag16g10,7)
tab agegroup4 year
svy:tab agegroup4 year, column

*degree or higher.
gen degree=-2
replace degree=0 if inlist(topqual3,2,3,4,5,6,7)
replace degree=1 if inlist(topqual3,1)
mvdecode degree,mv(-2)
tab degree year
svy:tab degree year, column

*Ethnicity.
mvdecode origin1,mv(-2)
tab origin1 year
svy:tab origin1 year, column

*BMI (continuous).
replace htval=htval/100

svy:mean bmival2 wtval htval
estat sd
svy:mean bmival2 wtval htval, over(year)
estat sd

*BMI status.

generate BMIstatus4=-2
replace BMIstatus4=1 if bmivg52==0          /* underweight */
replace BMIstatus4=2 if bmivg52==1          /* normal-weight */
replace BMIstatus4=3 if bmivg52==2           /* overweight */
replace BMIstatus4=4 if inlist(bmivg52,3,4)   /* obese */
label define status4lbl 1 "Underweight" 2 "Normal-weight" 3 "Overweight" 4 "Obese"
label values BMIstatus4 BMIstatuslbl
tab BMIstatus4 year
svy:tab BMIstatus4 year, column

*Class I obesity.

generate class1=0
replace class1=1 if inlist(bmivg52,3)   /* Class I */
tab class1 year
svy:tab class1 year, column

*Class II-III obesity.

generate class23=0
replace class23=1 if inlist(bmivg52,4)   /* Class II-III */
tab class23 year
svy:tab class23 year, column

*Analysis file going forward.

save "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace


*----------.
*Smoking.
*----------.

use "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace
tab1 smoke                 /* 388 missing */
keep if inlist(smoke,0,1)
tab1 smoke

*-------------------------.
*Analysis 1: all adults.
*------------------------.

svyset, clear
svyset [pweight=wt_int],psu(point)
svy:tab ag16g10 sex, col

generate std_weight=0
replace std_weight=0.146 if (ag16g10==1 & sex==1)
replace std_weight=0.1725 if (ag16g10==2 & sex==1)
replace std_weight=0.1863 if (ag16g10==3 & sex==1)
replace std_weight=0.1735 if (ag16g10==4 & sex==1)
replace std_weight=0.147 if (ag16g10==5 & sex==1)
replace std_weight=0.1075 if (ag16g10==6 & sex==1)
replace std_weight=0.0672 if (ag16g10==7 & sex==1)

replace std_weight=0.1351 if (ag16g10==1 & sex==2)
replace std_weight=0.1613 if (ag16g10==2 & sex==2)
replace std_weight=0.183 if (ag16g10==3 & sex==2)
replace std_weight=0.1718 if (ag16g10==4 & sex==2)
replace std_weight=0.1504 if (ag16g10==5 & sex==2)
replace std_weight=0.112 if (ag16g10==6 & sex==2)
replace std_weight=0.0864 if (ag16g10==7 & sex==2)

*All.

svy:mean smoke,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [smoke]_subpop_4 - [smoke]_subpop_1
lincom [smoke]_subpop_8 - [smoke]_subpop_5

*-----------------------------.
*Analysis 2: four BMI categories.
*-----------------------------.

svy:mean smoke,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [smoke]_subpop_25 - [smoke]_subpop_1                /* Underweight men */
lincom [smoke]_subpop_26 - [smoke]_subpop_2                /* Normal-weight men */
lincom [smoke]_subpop_27 - [smoke]_subpop_3                /* Overweight men */
lincom [smoke]_subpop_28 - [smoke]_subpop_4                /* Obese men */

lincom [smoke]_subpop_29 - [smoke]_subpop_5                /* Underweight women */
lincom [smoke]_subpop_30 - [smoke]_subpop_6                /* Normal-weight women */
lincom [smoke]_subpop_31 - [smoke]_subpop_7                /* Overweight women */
lincom [smoke]_subpop_32 - [smoke]_subpop_8                /* Obese women */

*Change versus normal-weight.
lincom ([smoke]_subpop_27 - [smoke]_subpop_3) - ([smoke]_subpop_26 - [smoke]_subpop_2) 
lincom ([smoke]_subpop_28 - [smoke]_subpop_4) - ([smoke]_subpop_26 - [smoke]_subpop_2) 

lincom ([smoke]_subpop_31 - [smoke]_subpop_7) - ([smoke]_subpop_30 - [smoke]_subpop_6) 
lincom ([smoke]_subpop_32 - [smoke]_subpop_8) - ([smoke]_subpop_30 - [smoke]_subpop_6) 


*----------------------------.
*Analysis 3: Class I Obesity.
*-----------------------------.

svy:mean smoke,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [smoke]_subpop_8 - [smoke]_subpop_5   /* class I men */
lincom [smoke]_subpop_16 - [smoke]_subpop_13   /* class I  women */

*--------------------------------.
*Analysis 4: Classes II and III.
*--------------------------------.

svy:mean smoke,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [smoke]_subpop_8 - [smoke]_subpop_5   /* class II-III men */
lincom [smoke]_subpop_16 - [smoke]_subpop_13   /* class II-III women */

*-----------------------------.
*Analysis 5.
*Compare versus normal-weight.
*------------------------------.

svy:mean smoke,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([smoke]_subpop_16 - [smoke]_subpop_13) - ([smoke]_subpop_8 - [smoke]_subpop_5)     
lincom ([smoke]_subpop_20 - [smoke]_subpop_17) - ([smoke]_subpop_8 - [smoke]_subpop_5) 

lincom ([smoke]_subpop_36 - [smoke]_subpop_33) - ([smoke]_subpop_28 - [smoke]_subpop_25) 
lincom ([smoke]_subpop_40 - [smoke]_subpop_37) - ([smoke]_subpop_28 - [smoke]_subpop_25) 

*------------------.
*Inactivity.
*------------------.

use "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace
tab1 mins10tot0812g            /* 155 missing */
keep if mins10tot0812g>=0 
tab1 mins10tot0812g

gen inactive=-2
replace inactive=0 if inlist(mins10tot0812g,1,2,3)
replace inactive=1 if inlist(mins10tot0812g,4)          /* <30 mins pw */
keep if inlist(inactive,0,1)

svyset, clear
svyset [pweight=wt_int],psu(point)
svy:tab ag16g10 sex, col

generate std_weight=0
replace std_weight=0.1558 if (ag16g10==1 & sex==1)
replace std_weight=0.1692 if (ag16g10==2 & sex==1)
replace std_weight=0.1851 if (ag16g10==3 & sex==1)
replace std_weight=0.1714 if (ag16g10==4 & sex==1)
replace std_weight=0.1478 if (ag16g10==5 & sex==1)
replace std_weight=0.1034 if (ag16g10==6 & sex==1)
replace std_weight=0.0672 if (ag16g10==7 & sex==1)
replace std_weight=0.1436 if (ag16g10==1 & sex==2)
replace std_weight=0.1587 if (ag16g10==2 & sex==2)
replace std_weight=0.1819 if (ag16g10==3 & sex==2)
replace std_weight=0.1692 if (ag16g10==4 & sex==2)
replace std_weight=0.1509 if (ag16g10==5 & sex==2)
replace std_weight=0.1097 if (ag16g10==6 & sex==2)
replace std_weight=0.0861 if (ag16g10==7 & sex==2)

*-------------------------.
*Analysis 1: all adults.
*------------------------.

svy:mean inactive,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [inactive]_subpop_3 - [inactive]_subpop_1
lincom [inactive]_subpop_6 - [inactive]_subpop_4

*-----------------------------.
*Analysis 2: four BMI categories.
*-----------------------------.

svy:mean inactive,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [inactive]_subpop_17 - [inactive]_subpop_1   /* Underweight men */
lincom [inactive]_subpop_18 - [inactive]_subpop_2   /* Normal weight men */
lincom [inactive]_subpop_19 - [inactive]_subpop_3   /* Overweight men */
lincom [inactive]_subpop_20 - [inactive]_subpop_4   /* Obese men */

lincom [inactive]_subpop_21 - [inactive]_subpop_5   /* Underweight women */
lincom [inactive]_subpop_22 - [inactive]_subpop_6   /* Normal weight women */
lincom [inactive]_subpop_23 - [inactive]_subpop_7   /* Overweight women */
lincom [inactive]_subpop_24 - [inactive]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([inactive]_subpop_19 - [inactive]_subpop_3) - ([inactive]_subpop_18 - [inactive]_subpop_2) 
lincom ([inactive]_subpop_20 - [inactive]_subpop_4) - ([inactive]_subpop_18 - [inactive]_subpop_2) 

lincom ([inactive]_subpop_23 - [inactive]_subpop_7) - ([inactive]_subpop_22 - [inactive]_subpop_6) 
lincom ([inactive]_subpop_24 - [inactive]_subpop_8) - ([inactive]_subpop_22 - [inactive]_subpop_6) 

*----------------------------.
*Analysis 3: Class I Obesity.
*-----------------------------.

svy:mean inactive,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [inactive]_subpop_6 - [inactive]_subpop_4   /* class I men */
lincom [inactive]_subpop_12 - [inactive]_subpop_10   /* class I women */

*--------------------------------.
*Analysis 4: Classes II and III.
*--------------------------------.

svy:mean inactive,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [inactive]_subpop_6 - [inactive]_subpop_4   /* class II and III men */
lincom [inactive]_subpop_12 - [inactive]_subpop_10   /* class II and III women */

*-----------------------------.
*Analysis 5.
*Compare versus normal-weight.
*------------------------------.

svy:mean inactive,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([inactive]_subpop_12 - [inactive]_subpop_10) - ([inactive]_subpop_6 - [inactive]_subpop_4) 
lincom ([inactive]_subpop_15 - [inactive]_subpop_13) - ([inactive]_subpop_6 - [inactive]_subpop_4) 

lincom ([inactive]_subpop_27 - [inactive]_subpop_25) - ([inactive]_subpop_21 - [inactive]_subpop_19) 
lincom ([inactive]_subpop_30 - [inactive]_subpop_28) - ([inactive]_subpop_21 - [inactive]_subpop_19)


*------------------------.
*Alcohol consumption.
*------------------------.

use "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace

tab hseyear alclimit07b                          /* missing = 470 */
keep if inlist(alclimit07b,0,1,2,3)

generate alcbin=0
replace alcbin=1 if inlist(alclimit07b,2,3)     /* harmful levels */

svyset [pweight=wt_int],psu(point)
svy:tab ag16g10 sex, col

generate std_weight=0
replace std_weight=0.1436 if (ag16g10==1 & sex==1)
replace std_weight=0.1717 if (ag16g10==2 & sex==1)
replace std_weight=0.1801 if (ag16g10==3 & sex==1)
replace std_weight=0.1767 if (ag16g10==4 & sex==1)
replace std_weight=0.1474 if (ag16g10==5 & sex==1)
replace std_weight=0.1102 if (ag16g10==6 & sex==1)
replace std_weight=0.0704 if (ag16g10==7 & sex==1)

replace std_weight=0.1329 if (ag16g10==1 & sex==2)
replace std_weight=0.1613 if (ag16g10==2 & sex==2)
replace std_weight=0.1777 if (ag16g10==3 & sex==2)
replace std_weight=0.1751 if (ag16g10==4 & sex==2)
replace std_weight=0.1504 if (ag16g10==5 & sex==2)
replace std_weight=0.1149 if (ag16g10==6 & sex==2)
replace std_weight=0.0877 if (ag16g10==7 & sex==2)

*-------------------------.
*Analysis 1: all adults.
*------------------------.

svy:mean alcbin,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [alcbin]_subpop_3 - [alcbin]_subpop_1
lincom [alcbin]_subpop_6 - [alcbin]_subpop_4

*-----------------------------.
*Analysis 2: four BMI categories.
*-----------------------------.

svy:mean alcbin,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [alcbin]_subpop_17 - [alcbin]_subpop_1   /* Underweight men */
lincom [alcbin]_subpop_18 - [alcbin]_subpop_2   /* Normal weight men */
lincom [alcbin]_subpop_19 - [alcbin]_subpop_3   /* Overweight men */
lincom [alcbin]_subpop_20 - [alcbin]_subpop_4   /* Obese men */

lincom [alcbin]_subpop_21 - [alcbin]_subpop_5   /* Underweight women */
lincom [alcbin]_subpop_22 - [alcbin]_subpop_6   /* Normal weight women */
lincom [alcbin]_subpop_23 - [alcbin]_subpop_7   /* Overweight women */
lincom [alcbin]_subpop_24 - [alcbin]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([alcbin]_subpop_19 - [alcbin]_subpop_3) - ([alcbin]_subpop_18 - [alcbin]_subpop_2) 
lincom ([alcbin]_subpop_20 - [alcbin]_subpop_4) - ([alcbin]_subpop_18 - [alcbin]_subpop_2) 

lincom ([alcbin]_subpop_23 - [alcbin]_subpop_7) - ([alcbin]_subpop_22 - [alcbin]_subpop_6) 
lincom ([alcbin]_subpop_24 - [alcbin]_subpop_8) - ([alcbin]_subpop_22 - [alcbin]_subpop_6) 

*----------------------------.
*Analysis 3: Class I Obesity.
*-----------------------------.

svy:mean alcbin,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [alcbin]_subpop_6 - [alcbin]_subpop_4   /* class I men */
lincom [alcbin]_subpop_12 - [alcbin]_subpop_10   /* class I women */

*--------------------------------.
*Analysis 4: Classes II and III.
*--------------------------------.

svy:mean alcbin,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [alcbin]_subpop_6 - [alcbin]_subpop_4   /* class II and III men */
lincom [alcbin]_subpop_12 - [alcbin]_subpop_10   /* class II and III women */

*-----------------------------.
*Analysis 5.
*Compare versus normal-weight.
*------------------------------.

svy:mean alcbin,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([alcbin]_subpop_12 - [alcbin]_subpop_10) - ([alcbin]_subpop_6 - [alcbin]_subpop_4) 
lincom ([alcbin]_subpop_15 - [alcbin]_subpop_13) - ([alcbin]_subpop_6 - [alcbin]_subpop_4) 

lincom ([alcbin]_subpop_27 - [alcbin]_subpop_25) - ([alcbin]_subpop_21 - [alcbin]_subpop_19) 
lincom ([alcbin]_subpop_30 - [alcbin]_subpop_28) - ([alcbin]_subpop_21 - [alcbin]_subpop_19)

*--------------.
*Hypertension.
*wt_nurse.
*--------------.

use "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace
tab hseyear highbp         /* missing = 43, 912 */
keep if highbp>=0 

svyset, clear
svyset [pweight=wt_nurse],psu(point)
svy:tab ag16g10 sex, col

generate std_weight=0
replace std_weight=0.1477 if (ag16g10==1 & sex==1)
replace std_weight=0.1651 if (ag16g10==2 & sex==1)
replace std_weight=0.1835 if (ag16g10==3 & sex==1)
replace std_weight=0.1705 if (ag16g10==4 & sex==1)
replace std_weight=0.1492 if (ag16g10==5 & sex==1)
replace std_weight=0.1122 if (ag16g10==6 & sex==1)
replace std_weight=0.0719 if (ag16g10==7 & sex==1)

replace std_weight=0.1324 if (ag16g10==1 & sex==2)
replace std_weight=0.1569 if (ag16g10==2 & sex==2)
replace std_weight=0.1799 if (ag16g10==3 & sex==2)
replace std_weight=0.1685 if (ag16g10==4 & sex==2)
replace std_weight=0.1509 if (ag16g10==5 & sex==2)
replace std_weight=0.116 if (ag16g10==6 & sex==2)
replace std_weight=0.0954 if (ag16g10==7 & sex==2)

*-------------------------.
*Analysis 1: all adults.
*------------------------.

svy:mean highbp,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [highbp]_subpop_4 - [highbp]_subpop_1
lincom [highbp]_subpop_8 - [highbp]_subpop_5

*-----------------------------.
*Analysis 2: 4 BMI categories.
*-----------------------------.

svy:mean highbp,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [highbp]_subpop_25 - [highbp]_subpop_1   /* Underweight men */
lincom [highbp]_subpop_26 - [highbp]_subpop_2   /* Normal weight men */
lincom [highbp]_subpop_27 - [highbp]_subpop_3   /* Overweight men */
lincom [highbp]_subpop_28 - [highbp]_subpop_4   /* Obese men */

lincom [highbp]_subpop_29 - [highbp]_subpop_5   /* Underweight women */
lincom [highbp]_subpop_30 - [highbp]_subpop_6   /* Normal weight women */
lincom [highbp]_subpop_31 - [highbp]_subpop_7   /* Overweight women */
lincom [highbp]_subpop_32 - [highbp]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([highbp]_subpop_27 - [highbp]_subpop_3) - ([highbp]_subpop_26 - [highbp]_subpop_2) 
lincom ([highbp]_subpop_28 - [highbp]_subpop_4) - ([highbp]_subpop_26 - [highbp]_subpop_2) 

lincom ([highbp]_subpop_31 - [highbp]_subpop_7) - ([highbp]_subpop_30 - [highbp]_subpop_6) 
lincom ([highbp]_subpop_32 - [highbp]_subpop_8) - ([highbp]_subpop_30 - [highbp]_subpop_6) 

*----------------------------.
*Analysis 3: Class I Obesity.
*-----------------------------.

svy:mean highbp,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [highbp]_subpop_8 - [highbp]_subpop_5   /* class I men */
lincom [highbp]_subpop_16 - [highbp]_subpop_13   /* class II women */

*--------------------------------.
*Analysis 4: Classes II and III.
*--------------------------------.

*Class II and III.

svy:mean highbp,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [highbp]_subpop_8 - [highbp]_subpop_5   /* class II and III men */
lincom [highbp]_subpop_16 - [highbp]_subpop_13   /* class II and III women */

*-----------------------------.
*Analysis 5.
*Compare versus normal-weight.
*------------------------------.

*Change versus normal-weight.

svy:mean highbp,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([highbp]_subpop_16 - [highbp]_subpop_13) - ([highbp]_subpop_8 - [highbp]_subpop_5) 
lincom ([highbp]_subpop_20 - [highbp]_subpop_17) - ([highbp]_subpop_8 - [highbp]_subpop_5) 

lincom ([highbp]_subpop_36 - [highbp]_subpop_33) - ([highbp]_subpop_28 - [highbp]_subpop_25) 
lincom ([highbp]_subpop_40 - [highbp]_subpop_37) - ([highbp]_subpop_28 - [highbp]_subpop_25) 

*-----------------------------------------.
*3 indicators of hypertension management.
*------------------------------------------.

keep if inlist(hy140om,2,3,4)              /* Condition on being hypertensive */
tab hseyear bp1                            /* Diagnosed */ 

*------------------------------.
*Treated (among hypertensives).
*------------------------------.

generate treated=0
replace treated=1 if inlist(hy140om,2,3)    /* Treatment */

*-------------------------------.
*Control (among hypertensives).
*--------------------------------.

generate control=0
replace control=1 if inlist(hy140om,2)      /* Control */

*-------------------------------------.
*standard population (hypertensives).
*-------------------------------------.

svyset, clear
svyset [pweight=wt_nurse],psu(point)
svy:tab ag16g10 sex, col

drop std_weight
generate std_weight=0
replace std_weight=0.0285 if (ag16g10==1 & sex==1)
replace std_weight=0.0656 if (ag16g10==2 & sex==1)
replace std_weight=0.1117 if (ag16g10==3 & sex==1)
replace std_weight=0.179 if (ag16g10==4 & sex==1)
replace std_weight=0.2382 if (ag16g10==5 & sex==1)
replace std_weight=0.2228 if (ag16g10==6 & sex==1)
replace std_weight=0.1543 if (ag16g10==7 & sex==1)

replace std_weight=0.0076 if (ag16g10==1 & sex==2)
replace std_weight=0.0259 if (ag16g10==2 & sex==2)
replace std_weight=0.0698 if (ag16g10==3 & sex==2)
replace std_weight=0.145 if (ag16g10==4 & sex==2)
replace std_weight=0.2278 if (ag16g10==5 & sex==2)
replace std_weight=0.2609 if (ag16g10==6 & sex==2)
replace std_weight=0.263 if (ag16g10==7 & sex==2)

*-------------------------------------.
*Analysis 1: all adults (Treatment).
*------------------------------------.

svy:mean treated,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [treated]_subpop_4 - [treated]_subpop_1
lincom [treated]_subpop_8 - [treated]_subpop_5

*-------------------------------------.
*Analysis 2: BMIstatus4 (Treatment).
*------------------------------------.

svy:mean treated,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [treated]_subpop_25 - [treated]_subpop_1   /* Underweight men */
lincom [treated]_subpop_26 - [treated]_subpop_2   /* Normal weight men */
lincom [treated]_subpop_27 - [treated]_subpop_3   /* Overweight men */
lincom [treated]_subpop_28 - [treated]_subpop_4   /* Obese men */

lincom [treated]_subpop_29 - [treated]_subpop_5   /* Underweight women */
lincom [treated]_subpop_30 - [treated]_subpop_6   /* Normal weight women */
lincom [treated]_subpop_31 - [treated]_subpop_7   /* Overweight women */
lincom [treated]_subpop_32 - [treated]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([treated]_subpop_27 - [treated]_subpop_3) - ([treated]_subpop_26 - [treated]_subpop_2) 
lincom ([treated]_subpop_28 - [treated]_subpop_4) - ([treated]_subpop_26 - [treated]_subpop_2) 
lincom ([treated]_subpop_31 - [treated]_subpop_7) - ([treated]_subpop_30 - [treated]_subpop_6) 
lincom ([treated]_subpop_32 - [treated]_subpop_8) - ([treated]_subpop_30 - [treated]_subpop_6) 

*-------------------------------------.
*Analysis 3: class I (Treatment).
*------------------------------------.

svy:mean treated,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [treated]_subpop_8 - [treated]_subpop_5   /* class I men */
lincom [treated]_subpop_16 - [treated]_subpop_13   /* class I women */

*-------------------------------------.
*Analysis 4: class II-III (Treatment).
*------------------------------------.

svy:mean treated,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [treated]_subpop_8 - [treated]_subpop_5   /* class II and III men */
lincom [treated]_subpop_16 - [treated]_subpop_13   /* class II and III women */

*------------------------------------------------------.
*Analysis 5: Compare versus normal-weight  (Treatment).
*------------------------------------------------------.

svy:mean treated,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
*Change versus normal-weight.
lincom ([treated]_subpop_16 - [treated]_subpop_13) - ([treated]_subpop_8 - [treated]_subpop_5) 
lincom ([treated]_subpop_20 - [treated]_subpop_17) - ([treated]_subpop_8 - [treated]_subpop_5)
 
lincom ([treated]_subpop_36 - [treated]_subpop_33) - ([treated]_subpop_28 - [treated]_subpop_25) 
lincom ([treated]_subpop_40 - [treated]_subpop_37) - ([treated]_subpop_28 - [treated]_subpop_25) 

*--------------------------------------.
*Indicator 2: controlled hypertension.
*-------------------------------------.

*-------------------------------------.
*Analysis 1: all adults (Control).
*------------------------------------.

svy:mean control,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [control]_subpop_4 - [control]_subpop_1
lincom [control]_subpop_8 - [control]_subpop_5

*-------------------------------------.
*Analysis 2: BMIstatus4 (Control).
*------------------------------------.

svy:mean control,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [control]_subpop_25 - [control]_subpop_1   /* Underweight men */
lincom [control]_subpop_26 - [control]_subpop_2   /* Normal weight men */
lincom [control]_subpop_27 - [control]_subpop_3   /* Overweight men */
lincom [control]_subpop_28 - [control]_subpop_4   /* Obese men */

lincom [control]_subpop_29 - [control]_subpop_5   /* Underweight women */
lincom [control]_subpop_30 - [control]_subpop_6   /* Normal weight women */
lincom [control]_subpop_31 - [control]_subpop_7   /* Overweight women */
lincom [control]_subpop_32 - [control]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([control]_subpop_27 - [control]_subpop_3) - ([control]_subpop_26 - [control]_subpop_2) 
lincom ([control]_subpop_28 - [control]_subpop_4) - ([control]_subpop_26 - [control]_subpop_2) 
lincom ([control]_subpop_31 - [control]_subpop_7) - ([control]_subpop_30 - [control]_subpop_6) 
lincom ([control]_subpop_32 - [control]_subpop_8) - ([control]_subpop_30 - [control]_subpop_6) 

*-------------------------------------.
*Analysis 3: class I (Control).
*------------------------------------.

svy:mean control,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [control]_subpop_8 - [control]_subpop_5   /* class I men */
lincom [control]_subpop_16 - [control]_subpop_13   /* class I women */

*-------------------------------------.
*Analysis 4: class II-III (Control).
*------------------------------------.

svy:mean control,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [control]_subpop_8 - [control]_subpop_5   /* class II and III men */
lincom [control]_subpop_16 - [control]_subpop_13   /* class II and III women */

*----------------------------------------------------.
*Analysis 5: Compare versus normal-weight. (Control).
*----------------------------------------------------.

svy:mean control,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([control]_subpop_16 - [control]_subpop_13) - ([control]_subpop_8 - [control]_subpop_5) 
lincom ([control]_subpop_20 - [control]_subpop_17) - ([control]_subpop_8 - [control]_subpop_5)
lincom ([control]_subpop_36 - [control]_subpop_33) - ([control]_subpop_28 - [control]_subpop_25) 
lincom ([control]_subpop_40 - [control]_subpop_37) - ([control]_subpop_28 - [control]_subpop_25)


*----------------------------------------------------------------------.
*Indicator 3.
*Diagnosed hypertension (among those with survey-defined hypertension).
*----------------------------------------------------------------------.

drop if hseyear==3                             /*Exclude the 2005 data (65+ only) */
drop if hseyear==4 & (samptype==2)             /*need samptype = 1 for 2006  */
tab hseyear bp1   
keep if inlist(bp1,1,2)

generate DiagBP=-2
replace DiagBP=1 if bp1==1              /* Diagnosed */
replace DiagBP=0 if bp1==2

svyset, clear
svyset [pweight=wt_nurse],psu(point)
svy:tab ag16g10 sex, col

drop std_weight
generate std_weight=0
replace std_weight=0.0249 if (ag16g10==1 & sex==1)
replace std_weight=0.0603 if (ag16g10==2 & sex==1)
replace std_weight=0.1099 if (ag16g10==3 & sex==1)
replace std_weight=0.1822 if (ag16g10==4 & sex==1)
replace std_weight=0.2352 if (ag16g10==5 & sex==1)
replace std_weight=0.2292 if (ag16g10==6 & sex==1)
replace std_weight=0.1583 if (ag16g10==7 & sex==1)

replace std_weight=0.0082 if (ag16g10==1 & sex==2)
replace std_weight=0.0269 if (ag16g10==2 & sex==2)
replace std_weight=0.0656 if (ag16g10==3 & sex==2)
replace std_weight=0.1459 if (ag16g10==4 & sex==2)
replace std_weight=0.2261 if (ag16g10==5 & sex==2)
replace std_weight=0.2605 if (ag16g10==6 & sex==2)
replace std_weight=0.2668 if (ag16g10==7 & sex==2)

*-------------------------------------.
*Analysis 1: all adults (Diagnosed).
*------------------------------------.

svy:mean DiagBP,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [DiagBP]_subpop_4 - [DiagBP]_subpop_1
lincom [DiagBP]_subpop_8 - [DiagBP]_subpop_5

*-------------------------------------.
*Analysis 2: BMIstatus4 (Diagnosed).
*------------------------------------.

svy:mean DiagBP,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [DiagBP]_subpop_25 - [DiagBP]_subpop_1   /* Underweight men */
lincom [DiagBP]_subpop_26 - [DiagBP]_subpop_2   /* Normal weight men */
lincom [DiagBP]_subpop_27 - [DiagBP]_subpop_3   /* Overweight men */
lincom [DiagBP]_subpop_28 - [DiagBP]_subpop_4   /* Obese men */
lincom [DiagBP]_subpop_29 - [DiagBP]_subpop_5   /* Underweight women */
lincom [DiagBP]_subpop_30 - [DiagBP]_subpop_6   /* Normal weight women */
lincom [DiagBP]_subpop_31 - [DiagBP]_subpop_7   /* Overweight women */
lincom [DiagBP]_subpop_32 - [DiagBP]_subpop_8   /* Obese women */

*Compare versus normal-weight.
lincom ([DiagBP]_subpop_27 - [DiagBP]_subpop_3) - ([DiagBP]_subpop_26 - [DiagBP]_subpop_2) 
lincom ([DiagBP]_subpop_28 - [DiagBP]_subpop_4) - ([DiagBP]_subpop_26 - [DiagBP]_subpop_2) 
lincom ([DiagBP]_subpop_31 - [DiagBP]_subpop_7) - ([DiagBP]_subpop_30 - [DiagBP]_subpop_6) 
lincom ([DiagBP]_subpop_32 - [DiagBP]_subpop_8) - ([DiagBP]_subpop_30 - [DiagBP]_subpop_6)

*-------------------------------------.
*Analysis 3: class I (Diagnosed).
*------------------------------------.

svy:mean DiagBP,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [DiagBP]_subpop_8 - [DiagBP]_subpop_5   /* class1 men */
lincom [DiagBP]_subpop_16 - [DiagBP]_subpop_13   /* class1 women */

*-------------------------------------.
*Analysis 4: class II-III (Diagnosed).
*------------------------------------.

svy:mean DiagBP,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [DiagBP]_subpop_8 - [DiagBP]_subpop_5   /* class II men */
lincom [DiagBP]_subpop_16 - [DiagBP]_subpop_13   /* class II women */

*------------------------------------------------------.
*Analysis 5: Compare versus normal-weight (Diagnosed).
*--------------------------------------------------------.

svy:mean DiagBP,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([DiagBP]_subpop_16 - [DiagBP]_subpop_13) - ([DiagBP]_subpop_8 - [DiagBP]_subpop_5) 
lincom ([DiagBP]_subpop_20 - [DiagBP]_subpop_17) - ([DiagBP]_subpop_8 - [DiagBP]_subpop_5)
lincom ([DiagBP]_subpop_36 - [DiagBP]_subpop_33) - ([DiagBP]_subpop_28 - [DiagBP]_subpop_25) 
lincom ([DiagBP]_subpop_40 - [DiagBP]_subpop_37) - ([DiagBP]_subpop_28 - [DiagBP]_subpop_25)

*------------.
*Diabetes.
*wt_blood.
*------------.

use "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace

*Total diabetes.

tab hseyear diabete3b,missing           /*missing = (36,363)+(3062+3518)*/ 
keep if inlist(diabete3b,1,2,3) 

generate totaldiab=-2
replace totaldiab=0 if inlist(diabete3b,1)
replace totaldiab=1 if inlist(diabete3b,2,3)

svyset [pweight=wt_blood],psu(point)
svy:tab ag16g10 sex, col

generate std_weight=0
replace std_weight=0.1507 if (ag16g10==1 & sex==1)
replace std_weight=0.1729 if (ag16g10==2 & sex==1)
replace std_weight=0.1872 if (ag16g10==3 & sex==1)
replace std_weight=0.1753 if (ag16g10==4 & sex==1)
replace std_weight=0.1473 if (ag16g10==5 & sex==1)
replace std_weight=0.1023 if (ag16g10==6 & sex==1)
replace std_weight=0.0642 if (ag16g10==7 & sex==1)

replace std_weight=0.1379 if (ag16g10==1 & sex==2)
replace std_weight=0.1697 if (ag16g10==2 & sex==2)
replace std_weight=0.1818 if (ag16g10==3 & sex==2)
replace std_weight=0.1723 if (ag16g10==4 & sex==2)
replace std_weight=0.1486 if (ag16g10==5 & sex==2)
replace std_weight=0.1049 if (ag16g10==6 & sex==2)
replace std_weight=0.0848 if (ag16g10==7 & sex==2)

*-----------------------------------------.
*Analysis 1: all adults (total diabetes).
*---------------------------------------.

svy:mean totaldiab,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [totaldiab]_subpop_4 - [totaldiab]_subpop_1
lincom [totaldiab]_subpop_8 - [totaldiab]_subpop_5

*-------------------------------------.
*Analysis 2: BMIstatus4(total diabetes).
*------------------------------------.

svy:mean totaldiab,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [totaldiab]_subpop_25 - [totaldiab]_subpop_1   /* Underweight men */
lincom [totaldiab]_subpop_26 - [totaldiab]_subpop_2   /* Normal weight men */
lincom [totaldiab]_subpop_27 - [totaldiab]_subpop_3   /* Overweight men */
lincom [totaldiab]_subpop_28 - [totaldiab]_subpop_4   /* Obese men */

lincom [totaldiab]_subpop_29 - [totaldiab]_subpop_5   /* Underweight women */
lincom [totaldiab]_subpop_30 - [totaldiab]_subpop_6   /* Normal weight women */
lincom [totaldiab]_subpop_31 - [totaldiab]_subpop_7   /* Overweight women */
lincom [totaldiab]_subpop_32 - [totaldiab]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([totaldiab]_subpop_27 - [totaldiab]_subpop_3) - ([totaldiab]_subpop_26 - [totaldiab]_subpop_2) 
lincom ([totaldiab]_subpop_28 - [totaldiab]_subpop_4) - ([totaldiab]_subpop_26 - [totaldiab]_subpop_2) 
lincom ([totaldiab]_subpop_31 - [totaldiab]_subpop_7) - ([totaldiab]_subpop_30 - [totaldiab]_subpop_6) 
lincom ([totaldiab]_subpop_32 - [totaldiab]_subpop_8) - ([totaldiab]_subpop_30 - [totaldiab]_subpop_6)

*-------------------------------------.
*Analysis 3: class I (total diabetes).
*------------------------------------.

svy:mean totaldiab,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [totaldiab]_subpop_8 - [totaldiab]_subpop_5   /* class I men */
lincom [totaldiab]_subpop_16 - [totaldiab]_subpop_13   /* class I women */

*-------------------------------------.
*Analysis 4: class II-III (total diabetes).
*------------------------------------.

svy:mean totaldiab,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [totaldiab]_subpop_8 - [totaldiab]_subpop_5   /* class II and III men */
lincom [totaldiab]_subpop_16 - [totaldiab]_subpop_13   /* class II and III women */

*-----------------------------------------------------------.
*Analysis 5:Compare versus normal-weight. (total diabetes).
*------------------------------------------------------------.

svy:mean totaldiab,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([totaldiab]_subpop_16 - [totaldiab]_subpop_13) - ([totaldiab]_subpop_8 - [totaldiab]_subpop_5) 
lincom ([totaldiab]_subpop_20 - [totaldiab]_subpop_17) - ([totaldiab]_subpop_8 - [totaldiab]_subpop_5) 
lincom ([totaldiab]_subpop_36 - [totaldiab]_subpop_33) - ([totaldiab]_subpop_28 - [totaldiab]_subpop_25) 
lincom ([totaldiab]_subpop_40 - [totaldiab]_subpop_37) - ([totaldiab]_subpop_28 - [totaldiab]_subpop_25)

*-------------------.
*Indicator 2.
*Diagnosed diabetes.
*-------------------.

recode diabete2 (2=0) (1=1)

*------------------------------------------.
*Analysis 1:All adults (Diagnosed diabetes).
*------------------------------------------.

svy:mean diabete2,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [diabete2]_subpop_4 - [diabete2]_subpop_1
lincom [diabete2]_subpop_8 - [diabete2]_subpop_5

*------------------------------------------.
*Analysis 2:BMIstatus4 (Diagnosed diabetes).
*------------------------------------------.

svy:mean diabete2,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)

lincom [diabete2]_subpop_25 - [diabete2]_subpop_1   /* Underweight men */
lincom [diabete2]_subpop_26 - [diabete2]_subpop_2   /* Normal weight men */
lincom [diabete2]_subpop_27 - [diabete2]_subpop_3   /* Overweight men */
lincom [diabete2]_subpop_28 - [diabete2]_subpop_4   /* Obese men */

lincom [diabete2]_subpop_29 - [diabete2]_subpop_5   /* Underweight women */
lincom [diabete2]_subpop_30 - [diabete2]_subpop_6   /* Normal weight women */
lincom [diabete2]_subpop_31 - [diabete2]_subpop_7   /* Overweight women */
lincom [diabete2]_subpop_32 - [diabete2]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([diabete2]_subpop_27 - [diabete2]_subpop_3) - ([diabete2]_subpop_26 - [diabete2]_subpop_2) 
lincom ([diabete2]_subpop_28 - [diabete2]_subpop_4) - ([diabete2]_subpop_26 - [diabete2]_subpop_2) 
lincom ([diabete2]_subpop_31 - [diabete2]_subpop_7) - ([diabete2]_subpop_30 - [diabete2]_subpop_6) 
lincom ([diabete2]_subpop_32 - [diabete2]_subpop_8) - ([diabete2]_subpop_30 - [diabete2]_subpop_6)

*------------------------------------------.
*Analysis 3:class I (Diagnosed diabetes).
*------------------------------------------.

svy:mean diabete2,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [diabete2]_subpop_8 - [diabete2]_subpop_5   /* class I men */
lincom [diabete2]_subpop_16 - [diabete2]_subpop_13   /* class I women */

*------------------------------------------.
*Analysis 4:class II-III (Diagnosed diabetes).
*------------------------------------------.

svy:mean diabete2,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [diabete2]_subpop_8 - [diabete2]_subpop_5   /* class II-III men */
lincom [diabete2]_subpop_16 - [diabete2]_subpop_13   /* class II-III women */

*----------------------------------------------------------------.
*Analysis 5: Compare versus normal-weight (Diagnosed diabetes).
*----------------------------------------------------------------.

svy:mean diabete2,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([diabete2]_subpop_16 - [diabete2]_subpop_13) - ([diabete2]_subpop_8 - [diabete2]_subpop_5) 
lincom ([diabete2]_subpop_20 - [diabete2]_subpop_17) - ([diabete2]_subpop_8 - [diabete2]_subpop_5) 
lincom ([diabete2]_subpop_36 - [diabete2]_subpop_33) - ([diabete2]_subpop_28 - [diabete2]_subpop_25) 
lincom ([diabete2]_subpop_40 - [diabete2]_subpop_37) - ([diabete2]_subpop_28 - [diabete2]_subpop_25)

*----------------------.
*Indicator 3.
*Undiagnosed diabetes.
*-----------------------.

generate diabete3=0
replace diabete3=1 if (diabete2==0 & totaldiab==1)

*------------------------------------------.
*Analysis 1:All adults (Undiagnosed diabetes).
*------------------------------------------.

svy:mean diabete3,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [diabete3]_subpop_4 - [diabete3]_subpop_1
lincom [diabete3]_subpop_8 - [diabete3]_subpop_5

*------------------------------------------.
*Analysis 2:BMIstatus4 (Undiagnosed diabetes).
*------------------------------------------.

svy:mean diabete3,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [diabete3]_subpop_25 - [diabete3]_subpop_1   /* Underweight men */
lincom [diabete3]_subpop_26 - [diabete3]_subpop_2   /* Normal weight men */
lincom [diabete3]_subpop_27 - [diabete3]_subpop_3   /* Overweight men */
lincom [diabete3]_subpop_28 - [diabete3]_subpop_4   /* Obese men */
lincom [diabete3]_subpop_29 - [diabete3]_subpop_5   /* Underweight women */
lincom [diabete3]_subpop_30 - [diabete3]_subpop_6   /* Normal weight women */
lincom [diabete3]_subpop_31 - [diabete3]_subpop_7   /* Overweight women */
lincom [diabete3]_subpop_32 - [diabete3]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([diabete3]_subpop_27 - [diabete3]_subpop_3) - ([diabete3]_subpop_26 - [diabete3]_subpop_2) 
lincom ([diabete3]_subpop_28 - [diabete3]_subpop_4) - ([diabete3]_subpop_26 - [diabete3]_subpop_2) 
lincom ([diabete3]_subpop_31 - [diabete3]_subpop_7) - ([diabete3]_subpop_30 - [diabete3]_subpop_6) 
lincom ([diabete3]_subpop_32 - [diabete3]_subpop_8) - ([diabete3]_subpop_30 - [diabete3]_subpop_6) 

*------------------------------------------.
*Analysis 3:Class I (Undiagnosed diabetes).
*------------------------------------------.

svy:mean diabete3,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [diabete3]_subpop_8 - [diabete3]_subpop_5   /* class I men */
lincom [diabete3]_subpop_16 - [diabete3]_subpop_13   /* class I women */

*------------------------------------------.
*Analysis 4:Class II-III (Undiagnosed diabetes).
*------------------------------------------.

svy:mean diabete3,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [diabete3]_subpop_8 - [diabete3]_subpop_5   /* class II-III men */
lincom [diabete3]_subpop_16 - [diabete3]_subpop_13   /* class II-III women */

*-----------------------------------------------------------------.
*Analysis 5:Compare versus normal-weight.(Undiagnosed diabetes).
*------------------------------------------------------------------.

svy:mean diabete3,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([diabete3]_subpop_16 - [diabete3]_subpop_13) - ([diabete3]_subpop_8 - [diabete3]_subpop_5) 
lincom ([diabete3]_subpop_20 - [diabete3]_subpop_17) - ([diabete3]_subpop_8 - [diabete3]_subpop_5) 
lincom ([diabete3]_subpop_36 - [diabete3]_subpop_33) - ([diabete3]_subpop_28 - [diabete3]_subpop_25) 
lincom ([diabete3]_subpop_40 - [diabete3]_subpop_37) - ([diabete3]_subpop_28 - [diabete3]_subpop_25)


*------------------.
*Total cholesterol.
*------------------.

use "N:\RF by BMI\AnalysisFile_Dec2020_v1.dta", replace

tab hseyear raised        /*missing = 36,473 */
keep if inlist(raised,0,1) 


svyset [pweight=wt_blood],psu(point)
svy:tab ag16g10 sex, col

generate std_weight=0
replace std_weight=0.1478 if (ag16g10==1 & sex==1)
replace std_weight=0.171 if (ag16g10==2 & sex==1)
replace std_weight=0.1841 if (ag16g10==3 & sex==1)
replace std_weight=0.1737 if (ag16g10==4 & sex==1)
replace std_weight=0.1459 if (ag16g10==5 & sex==1)
replace std_weight=0.1094 if (ag16g10==6 & sex==1)
replace std_weight=0.0681 if (ag16g10==7 & sex==1)

replace std_weight=0.1363 if (ag16g10==1 & sex==2)
replace std_weight=0.1686 if (ag16g10==2 & sex==2)
replace std_weight=0.1768 if (ag16g10==3 & sex==2)
replace std_weight=0.1707 if (ag16g10==4 & sex==2)
replace std_weight=0.1459 if (ag16g10==5 & sex==2)
replace std_weight=0.1122 if (ag16g10==6 & sex==2)
replace std_weight=0.0896 if (ag16g10==7 & sex==2)

*------------------------.
*Analysis 1: all adults.
*-----------------------.

svy:mean raised,stdize(ag16g10) stdweight(std_weight) over(sex year)
lincom [raised]_subpop_3 - [raised]_subpop_1
lincom [raised]_subpop_6 - [raised]_subpop_4

*------------------------.
*Analysis 2: BMIstatus4.
*-----------------------.

svy:mean raised,stdize(ag16g10) stdweight(std_weight) over(year sex BMIstatus4)
lincom [raised]_subpop_17 - [raised]_subpop_1   /* Underweight men */
lincom [raised]_subpop_18 - [raised]_subpop_2   /* Normal weight men */
lincom [raised]_subpop_19 - [raised]_subpop_3   /* Overweight men */
lincom [raised]_subpop_20 - [raised]_subpop_4   /* Obese men */
lincom [raised]_subpop_21 - [raised]_subpop_5   /* Underweight women */
lincom [raised]_subpop_22 - [raised]_subpop_6   /* Normal weight women */
lincom [raised]_subpop_23 - [raised]_subpop_7   /* Overweight women */
lincom [raised]_subpop_24 - [raised]_subpop_8   /* Obese women */

*Change versus normal-weight.
lincom ([raised]_subpop_19 - [raised]_subpop_3) - ([raised]_subpop_18 - [raised]_subpop_2) 
lincom ([raised]_subpop_20 - [raised]_subpop_4) - ([raised]_subpop_18 - [raised]_subpop_2) 
lincom ([raised]_subpop_23 - [raised]_subpop_7) - ([raised]_subpop_22 - [raised]_subpop_6) 
lincom ([raised]_subpop_24 - [raised]_subpop_8) - ([raised]_subpop_22 - [raised]_subpop_6) 

*------------------------.
*Analysis 3:Class I.
*-----------------------.

svy:mean raised,stdize(ag16g10) stdweight(std_weight) over(sex class1 year)
lincom [raised]_subpop_6 - [raised]_subpop_4   /* class I men */
lincom [raised]_subpop_12 - [raised]_subpop_10   /* class I women */

*------------------------.
*Analysis 4:Class II-III.
*-----------------------.

svy:mean raised,stdize(ag16g10) stdweight(std_weight) over(sex class23 year)
lincom [raised]_subpop_6 - [raised]_subpop_4   /* class II and III men */
lincom [raised]_subpop_12 - [raised]_subpop_10   /* class II and III women */

*---------------------------------------.
*Analysis 5:Change versus normal-weight.
*----------------------------------------.

svy:mean raised,stdize(ag16g10) stdweight(std_weight) over(sex bmivg52 year)
lincom ([raised]_subpop_12 - [raised]_subpop_10) - ([raised]_subpop_6 - [raised]_subpop_4) 
lincom ([raised]_subpop_15 - [raised]_subpop_13) - ([raised]_subpop_6 - [raised]_subpop_4) 
lincom ([raised]_subpop_27 - [raised]_subpop_25) - ([raised]_subpop_21 - [raised]_subpop_19) 
lincom ([raised]_subpop_30 - [raised]_subpop_28) - ([raised]_subpop_21 - [raised]_subpop_19)























































