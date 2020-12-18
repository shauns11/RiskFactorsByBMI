*Analysis file for CVD risk factors by BMI (HSE 2003 to 2018).
*Datasets required (download from UKDS).
*2003: hse03ai.sav.
*2005: hse05ai.sav.
*2006: hse06ai.sav.
*2007: hse07ai.sav.
*2008: hse08ai.sav.
*2009: hse09ai.sav.
*2010: hse10ai.sav.
*2011: hse2011ai.sav.
*2012: hse2012ai.sav.
*2013: hse2013ai.sav.
*2014: hse2014ai.sav.
*2015: hse2015ai.sav.
*2016: hse2016_eul.sav.
*2017: hse17i_eul_v1.sav.
*2018: hse_2018_eul.sav.


*2003.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse03ai.sav"
/KEEP area cluster sex age nurse_wt int_wt blood_wt
hyper1om hyper2om
hy140om hibp1om hibp2om hbp140om hyper1di hyper2di hy140di hibp1di
hibp2di hbp140di omsysval omdiaval topqual3 sclass bpmedd 
medcnjd ag16g10 bmival nuroutc cigsta3 diabete2 glyhbval
cholest cholval lipid wtval htval bp1 ethnici.

select if age>=16.
EXECUTE.

rename var(nurse_wt int_wt blood_wt = wt_nurse wt_int wt_blood).
exe.

compute psu99=area.
EXECUTE.

FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2003".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=1.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ethnici=1 origin1=1.
if any(ethnici,2,3,4,5,6,7) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".

* High cholesterol.

compute raised=-2.
if range(cholest,0,4.9) raised=0.
if cholest>4.9 raised=1.
EXECUTE.

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoking status.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.


*Hypertension (meds prescribed for high BP).

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes (6.5%).

compute diabete3b=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3b=1.
If (Glyhbval>0 & diabete2=1) diabete3b=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3b=3.
If any(-9,diabete2) diabete3b=-9.
If any(-8,diabete2) diabete3b=-8.
If any(-1,diabete2) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3b "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3b (-9,-8,-1).
exe.

save outfile = "N:\Temp\HSE2003RF.sav"
/keep point1 HSEyear sex age wt_int wt_nurse wt_blood omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 bmivg52 smoke highBP diabete3b raised lipid cholest
wtval htval topqual3 bp1 bpmedd origin1.


* 2005.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse05ai.sav"
/KEEP area cluster sex age wt_nurse wt_int cigsta3 diabete2 glyhbval 
hyper1om hyper2om hy140om
hibp1om hibp2om hbp140om
hyper1di hyper2di hy140di hibp1di hibp2di
hbp140di samptype omsysval omdiaval topqual3 
bpmedd medcnjd ag16g10 bmival nuroutc wtval htval bp1 
everbp docnurbp ethinda.

select if (samptype=1 & age>=16).
EXECUTE.

compute psu99=area.
EXECUTE.
FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2005".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=3.
EXECUTE.

compute wt_blood = wt_nurse.
exe.

*Ethnicity.

compute origin1=-2.
if ethinda=1 origin1=1.
if any(ethinda,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
exe.

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoking.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Hypertension (meds prescribed for high BP).

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

save outfile = "N:\Temp\HSE2005RF.sav"
/keep point1 HSEyear sex age wt_int wt_nurse wt_blood omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52
wtval htval topqual3 bp1 bpmedd origin1.


* 2006.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse06ai.sav"
/KEEP psu sex age wt_nurse wt_int wt_blood cigsta3 diabete2
hyper1om
hyper2om
hy140om
hibp1om
hibp2om
hbp140om
hyper1di
hyper2di
hy140di
hibp1di
hibp2di
hbp140di omsysval omdiaval topqual3 sclass
bpmedd 
medbi01 to medbi22
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd ag16g10 bmival nuroutc glyhbval cholest lipid wt_int_s1
wtval htval bp1 everbp samptype ethinda.

select if age>=16.
EXECUTE.

compute psu99=psu.
EXECUTE.

FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2006".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=4.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ethinda=1 origin1=1.
if any(ethinda,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
exe.

* Cholesterol.

compute raised=-2.
if range(cholest,0,4.9) raised=0.
if cholest>4.9 raised=1.
EXECUTE.

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoking.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Hypertension (meds prescribed for high BP).

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.

compute diabete3b=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3b=1.
If (Glyhbval>0 & diabete2=1) diabete3b=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3b=3.
If any(-9,diabete2) diabete3b=-9.
If any(-8,diabete2) diabete3b=-8.
If any(-1,diabete2) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3b "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3b (-9,-8,-1).
exe.

save outfile = "N:\Temp\HSE2006RF.sav"
/keep point1 HSEyear sex age wt_int wt_nurse wt_blood omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52 diabete3b
cholest lipid raised wt_int_s1 wtval htval topqual3 bp1 samptype bpmedd origin1.



* 2007.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse07ai.sav"
/KEEP area sex age wt_nurse wt_int cigsta3 
hyper1om hyper2om hy140om
hibp1om hibp2om hbp140om
hyper1di
hyper2di
hy140di
hibp1di
hibp2di
hbp140di omsysval omdiaval topqual3 sclass
bpmedd 
medbi01 to medbi22
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd ag16g10 bmival nuroutc
wtval htval alclimit07b ethinda.

select if age>=16.
EXECUTE.

compute psu99=area.
EXECUTE.
FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2007".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=5.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ethinda=1 origin1=1.
if any(ethinda,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

**Hypertension (prescribed for high BP).

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

save outfile = "N:\Temp\HSE2007RF.sav"
/keep point1 HSEyear sex age wt_nurse wt_int omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 smoke highBP bmivg52
wtval htval topqual3 bpmedd alclimit07b origin1.



* 2008.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse08ai.sav".

select if age>=16.
EXECUTE.

compute psu99=psu.
EXECUTE.

FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2008".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=6.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ANy(origin,1,2,3) origin1=1.
if any(origin,4,5,6,7,8,9,10,11,12,13,14,15,16) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
exe.

*BMI.

compute bmival2=bmival.
exe.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Hypertension.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Inactivity.

*---------------------------.
* Heavy housework.
*---------------------------.

*desc var hswrkhm hwrklsthm hvyhwkhm hvydyhm hwtimhm.

recode hwtimhm (0 thru 9=0) (else=copy) into hw10tim2.
compute mins10hwk=0.
compute mins10hwk=(hw10tim2* hvydyhm)/4.
IF (hswrkhm=2 OR hvyhwkhm=2) mins10hwk=0.
IF hw10tim2=0 mins10hwk=0.
IF any(-9,hswrkhm, hwrklsthm, hvyhwkhm, hvydyhm, hwtimhm) mins10hwk=-9.
IF any(-8,hswrkhm, hwrklsthm, hvyhwkhm, hvydyhm, hwtimhm) mins10hwk=-8.
IF age<=15 mins10hwk=-1.
variable label mins10hwk '(D) Average minutes doing heavy housework per week(>=10mins) - all moderate'.
EXECUTE.


*---------------------------.
* Heavy manual.
*---------------------------.

recode diytimhm (0 thru 9=0) (else=copy) into diy10tim2.
compute mins10man=0.
compute mins10man=(diy10tim2*mndayhm)/4.
IF (gardnhm=2 OR manwrkhm=2) mins10man=0.
IF diy10tim2=0 mins10man=0.
IF any(-9, gardnhm, gardlistm, manwrkhm, mndayhm, diytimhm) mins10man=-9.
IF any(-8,gardnhm, gardlistm, manwrkhm, mndayhm, diytimhm) mins10man=-8.
IF age<=15 mins10man=-1.
variable label mins10man '(D) Average minutes doing heavy manual per week (>=10mins) - all moderate'.
exe.

*Wlk5it: (walk for at least 5 minutes: yes; no; cant walkt at all).

*Wlk10m: (walk for at least 10 minutes: yes; no): - 1 = no walk for 5 mins or cant walk at all: 12,182 = Yes.
*daywlk: (days for a walk for at least 10 minutes): base = 12,182 (wlk10m=Yes).

*day1wlk (more than 1 walk for 10min+: 8412 = Yes).
*day1wlk (number of days having more than 1 walk for 10min+: # for 8412).

* Days (# days doing just 1 walk).

compute days = daywlk-day2wlk.
IF daywlk=-8 days=-8.
IF daywlk=-1 days=-1.
IF day1wlk=-8 days=-8.
IF day1wlk=-1 days=-1.
IF day2wlk=-8 days=-8.
IF day2wlk=-1 days=-1.
exe.

*Number of days walking for 10+ min.
*A) Zero: no walks for 5 min+; no walks for 10min+ = No.
*B) if 1 walk a day only, then days = daywlk.


Compute Walk10no=0.
IF (Wlk5it=2) OR (Wlk5it=3) Walk10no=0.
IF Wlk10M=2 Walk10no=0.
IF (Day1Wlk=2) Walk10no=DayWlk.
exe.

* Walked on only one day, but did more than one: so number of days = 2.

IF (Day1Wlk=1 and DayWlk=1) Walk10no=(Day1Wlk*2).
EXECUTE.

*Number of days did 1 plus (number of days did more than  1 times 2).

IF (Day1Wlk=1 and DayWlk>1) Walk10no=((day2wlk*2)+(days)).
EXECUTE.

IF any (-8,Wlk5it,wlk10m,daywlk,day1wlk,day2wlk) walk10no=-8.
IF any (-9,Wlk5it,wlk10m,daywlk,day1wlk,day2wlk) walk10no=-9.
IF walkpace=1 walk10no=0.
IF walkpace=2 walk10no=0.
IF walkpace=5 walk10no=0.
IF age<16 walk10no=-1.
variable label walk10no '(D) Number of brisk/fast walks of 10 mins+ in last 4 weeks'.
exe.

* Minutes.

Recode tottim (0 thru 9=0) (else=copy) into tottim10.
compute mins10wlk=0.
compute mins10wlk =(tottim10*walk10no)/4.
IF tottim10=0 mins10wlk =0.
IF walk10no=-8 mins10wlk =-8.
IF walk10no=-9 mins10wlk =-9.
IF walk10no=-1 mins10wlk =-1.
variable label mins10wlk '(D) Average minutes walking of 10 mins+ per week brisk or fast - moderate'.
exe.

*Occupational.
*wrkdays wrkact21 wrkact22 wrkact23 wrkact24.
* Walking; lifting; climbing at work.

* archived variables.

compute mins10wrk08 = (hrs10wrk08 * 60).
exe.

* Sports.

*act11 act12 act13 act14 act15 act16
*whtact01 whtact02 whtact03 whtact04 whtact05
*whtact06 whtact07 whtact08 whtact09 whtact10

*excswt01 excswt02 excswt03 excswt04 excswt05 excswt06 excswt07excswt08
*excswt09 excswt10 excswt11 excswt12 excswt13 excswt14 excswt15 excswt16

*dayexc01 dayexc02 dayexc03 dayexc04 dayexc05 dayexc06 dayexc07 dayexc08
*dayexc09 dayexc10 dayexc11 dayexc12 dayexc13 dayexc14 dayexc15 dayexc16
*exctim01 exctim02 exctim03 exctim04 exctim05 exctim06 exctim07 exctim08
*exctim09 exctim10 exctim11 exctim12 exctim13 exctim14 exctim15 exctim16

compute mins10spta=0.

* Light Intensity.

IF (act11=1 OR act12=1 OR act13=1 OR act14=1 Or Act15=1 OR act16=1)  mins10spta=mins10spta+0.
IF (WhtAct05=1 AND excswt05<>1) mins10spta=mins10spta+0.
IF (WhtAct10=1 AND excswt10<>1) mins10spta=mins10spta+0.
exe.

* Moderate.

IF (WhtAct01=1 AND range(dayexc01,1,28) AND excswt01<>1 AND exctim01>=10) mins10spta=mins10spta+((dayexc01* exctim01)/4).
IF (WhtAct02=1 AND range(dayexc02,1,28) AND excswt02<>1 AND exctim02>=10) mins10spta=mins10spta+((dayexc02* exctim02)/4).
IF (WhtAct03=1 AND range(dayexc03,1,28) AND excswt03<>1 AND exctim03>=10) mins10spta=mins10spta+((dayexc03* exctim03)/4).
IF (WhtAct04=1 AND range(dayexc04,1,28) AND excswt04<>1 AND exctim04>=10) mins10spta=mins10spta+((dayexc04* exctim04)/4).
IF (WhtAct05=1 AND range(dayexc05,1,28) AND excswt05=1 AND exctim05>=10) mins10spta=mins10spta+((dayexc05* exctim05)/4).
IF (WhtAct07=1 AND range(dayexc07,1,28) AND excswt07<>1 AND exctim07>=10) mins10spta=mins10spta+((dayexc07* exctim07)/4).
IF (WhtAct08=1 AND range(dayexc08,1,28) AND excswt08<>1 AND exctim08>=10) mins10spta=mins10spta+((dayexc08* exctim08)/4).
IF (WhtAct10=1 AND range(dayexc10,1,28) AND excswt10=1 AND exctim10>=10) mins10spta=mins10spta+((dayexc10* exctim10)/4).
IF (act11=2 AND range(dayexc11,1,28) AND exctim11>=10) mins10spta=mins10spta+((dayexc11* exctim11)/4).
IF (act12=2 AND range(dayexc12,1,28) AND exctim12>=10) mins10spta=mins10spta+((dayexc12* exctim12)/4).
IF (act13=2 AND range(dayexc13,1,28) AND exctim13>=10) mins10spta=mins10spta+((dayexc13* exctim13)/4).
IF (act14=2 AND range(dayexc14,1,28) AND exctim14>=10) mins10spta=mins10spta+((dayexc14* exctim14)/4).
IF (act15=2 AND range(dayexc15,1,28) AND exctim15>=10) mins10spta=mins10spta+((dayexc15* exctim15)/4).
IF (act16=2 AND range(dayexc16,1,28) AND exctim16>=10) mins10spta=mins10spta+((dayexc16* exctim16)/4).
IF (act11=3 AND range(dayexc11,1,28) AND excswt11<>1 AND exctim11>=10) mins10spta=mins10spta+((dayexc11* exctim11)/4).
IF (act12=3 AND range(dayexc12,1,28) AND excswt12<>1 AND exctim12>=10) mins10spta=mins10spta+((dayexc12* exctim12)/4).
IF (act13=3 AND range(dayexc13,1,28) AND excswt13<>1 AND exctim13>=10) mins10spta=mins10spta+((dayexc13* exctim13)/4).
IF (act14=3 AND range(dayexc14,1,28) AND excswt14<>1 AND exctim14>=10) mins10spta=mins10spta+((dayexc14* exctim14)/4).
IF (act15=3 AND range(dayexc15,1,28) AND excswt15<>1 AND exctim15>=10) mins10spta=mins10spta+((dayexc15* exctim15)/4).
IF (act16=3 AND range(dayexc16,1,28) AND excswt16<>1 AND exctim16>=10) mins10spta=mins10spta+((dayexc16* exctim16)/4).
IF (act11=4 AND range(dayexc11,1,28) AND excswt11<>1 AND exctim11>=10) mins10spta=mins10spta+((dayexc11* exctim11)/4).
IF (act12=4 AND range(dayexc12,1,28) AND excswt12<>1 AND exctim12>=10) mins10spta=mins10spta+((dayexc12* exctim12)/4).
IF (act13=4 AND range(dayexc13,1,28) AND excswt13<>1 AND exctim13>=10) mins10spta=mins10spta+((dayexc13* exctim13)/4).
IF (act14=4 AND range(dayexc14,1,28) AND excswt14<>1 AND exctim14>=10) mins10spta=mins10spta+((dayexc14* exctim14)/4).
IF (act15=4 AND range(dayexc15,1,28) AND excswt15<>1 AND exctim15>=10) mins10spta=mins10spta+((dayexc15* exctim15)/4).
IF (act16=4 AND range(dayexc16,1,28) AND excswt16<>1 AND exctim16>=10) mins10spta=mins10spta+((dayexc16* exctim16)/4).
exe.

* Vigorous.

IF (WhtAct01=1 AND range(dayexc01,1,28) AND excswt01=1 AND exctim01>=10) mins10spta=mins10spta+(((dayexc01* exctim01)/4)*2).
IF (WhtAct02=1 AND range(dayexc02,1,28) AND excswt02=1 AND exctim02>=10) mins10spta=mins10spta+(((dayexc02* exctim02)/4)*2).
IF (WhtAct03=1 AND range(dayexc03,1,28) AND excswt03=1 AND exctim03>=10) mins10spta=mins10spta+(((dayexc03* exctim03)/4)*2).
IF (WhtAct04=1 AND range(dayexc04,1,28) AND excswt04=1 AND exctim04>=10) mins10spta=mins10spta+(((dayexc04* exctim04)/4)*2).
IF (WhtAct07=1 AND range(dayexc07,1,28) AND excswt07=1 AND exctim07>=10) mins10spta=mins10spta+(((dayexc07* exctim07)/4)*2).
IF (WhtAct08=1 AND range(dayexc08,1,28) AND excswt08=1 AND exctim08>=10) mins10spta=mins10spta+(((dayexc08* exctim08)/4)*2).
IF (WhtAct06=1 AND range(dayexc06,1,28) AND exctim06>=10) mins10spta=mins10spta+(((dayexc06* exctim06)/4)*2).
IF (WhtAct09=1 AND range(dayexc09,1,28) AND exctim09>=10) mins10spta=mins10spta+(((dayexc09* exctim09)/4)*2).
IF (act11=3 AND range(dayexc11,1,28) AND excswt11=1 AND exctim11>=10) mins10spta=mins10spta+(((dayexc11* exctim11)/4)*2).
IF (act11=4 AND range(dayexc11,1,28) AND excswt11=1 AND exctim11>=10) mins10spta=mins10spta+(((dayexc11* exctim11)/4)*2).
IF (act11=5 AND range(dayexc11,1,28) AND exctim11>=10) mins10spta=mins10spta+(((dayexc11* exctim11)/4)*2).
IF (act11=6 AND range(dayexc11,1,28) AND exctim11>=10) mins10spta=mins10spta+(((dayexc11* exctim11)/4)*2).
IF (act12=3 AND range(dayexc12,1,28) AND excswt12=1 AND exctim12>=10) mins10spta=mins10spta+(((dayexc12* exctim12)/4)*2).
IF (act12=4 AND range(dayexc12,1,28) AND excswt12=1 AND exctim12>=10) mins10spta=mins10spta+(((dayexc12* exctim12)/4)*2).
IF (act12=5 AND range(dayexc12,1,28) AND exctim12>=10) mins10spta=mins10spta+(((dayexc12* exctim12)/4)*2).
IF (act12=6 AND range(dayexc12,1,28) AND exctim12>=10) mins10spta=mins10spta+(((dayexc12* exctim12)/4)*2).
IF (act13=3 AND range(dayexc13,1,28) AND excswt13=1 AND exctim13>=10) mins10spta=mins10spta+(((dayexc13* exctim13)/4)*2).
IF (act13=4 AND range(dayexc13,1,28) AND excswt13=1 AND exctim13>=10) mins10spta=mins10spta+(((dayexc13* exctim13)/4)*2).
IF (act13=5 AND range(dayexc13,1,28) AND exctim13>=10) mins10spta=mins10spta+(((dayexc13* exctim13)/4)*2).
IF (act13=6 AND range(dayexc13,1,28) AND exctim13>=10) mins10spta=mins10spta+(((dayexc13* exctim13)/4)*2).
IF (act14=3 AND range(dayexc14,1,28) AND excswt14=1 AND exctim14>=10) mins10spta=mins10spta+(((dayexc14* exctim14)/4)*2).
IF (act14=4 AND range(dayexc14,1,28) AND excswt14=1 AND exctim14>=10) mins10spta=mins10spta+(((dayexc14* exctim14)/4)*2).
IF (act14=5 AND range(dayexc14,1,28) AND exctim14>=10) mins10spta=mins10spta+(((dayexc14* exctim14)/4)*2).
IF (act14=6 AND range(dayexc14,1,28) AND exctim14>=10) mins10spta=mins10spta+(((dayexc14* exctim14)/4)*2).
IF (act15=3 AND range(dayexc15,1,28) AND excswt15=1 AND exctim15>=10) mins10spta=mins10spta+(((dayexc15* exctim15)/4)*2).
IF (act15=4 AND range(dayexc15,1,28) AND excswt15=1 AND exctim15>=10) mins10spta=mins10spta+(((dayexc15* exctim15)/4)*2).
IF (act15=5 AND range(dayexc15,1,28) AND exctim15>=10) mins10spta=mins10spta+(((dayexc15* exctim15)/4)*2).
IF (act15=6 AND range(dayexc15,1,28) AND exctim15>=10) mins10spta=mins10spta+(((dayexc15* exctim15)/4)*2).
IF (act16=3 AND range(dayexc16,1,28) AND excswt16=1 AND exctim16>=10) mins10spta=mins10spta+(((dayexc16* exctim16)/4)*2).
IF (act16=4 AND range(dayexc16,1,28) AND excswt16=1 AND exctim16>=10) mins10spta=mins10spta+(((dayexc16* exctim16)/4)*2).
IF (act16=5 AND range(dayexc16,1,28) AND exctim16>=10) mins10spta=mins10spta+(((dayexc16* exctim16)/4)*2).
IF (act16=6 AND range(dayexc16,1,28) AND exctim16>=10) mins10spta=mins10spta+(((dayexc16* exctim16)/4)*2).
exe.

* these are combined.
* maximum of 40 hours a week.

recode mins10spta (2400 thru hi = 2400).
exe.

* Overall summary = maximum of 60 hours a week.

compute mins10tot0812 =  mins10hwk  + mins10man + mins10wlk + mins10wrk08 + mins10spta.
exe.
recode mins10tot0812 (3600 thru hi = 3600).
exe.

IF any(-9,hswrkhm, hwrklsthm, hvyhwkhm, hvydyhm, hwtimhm) mins10tot0812=-9.
IF any(-8,hswrkhm, hwrklsthm, hvyhwkhm, hvydyhm, hwtimhm) mins10tot0812=-8.
IF any(-9, gardnhm, gardlistm, manwrkhm, mndayhm, diytimhm) mins10tot0812=-9.
IF any(-8,gardnhm, gardlistm, manwrkhm, mndayhm, diytimhm) mins10tot0812=-8.
IF any (-8,Wlk5it,wlk10m,daywlk,day1wlk,day2wlk) mins10tot0812=-8.
IF any (-9,Wlk5it,wlk10m,daywlk,day1wlk,day2wlk) mins10tot0812=-9.
If any(-9,wrkact22,wrkact23,wrkact24,wrkdays,wkactwlk,wkactclb,wkactlft,active) mins10tot0812=-9.
If any(-8,wrkact22,wrkact23,wrkact24,wrkdays,wkactwlk,wkactclb,wkactlft,active) mins10tot0812=-8.
If any(-9,actphy) mins10tot0812=-9.
If any(-8,actphy) mins10tot0812=-8.
exe.

missing values mins10tot0812 (-9,-8,-1).
EXECUTE.

compute mins10tot0812g=-1.
if range(mins10tot0812,150.00000,3600) mins10tot0812g=1.
if range(mins10tot0812,60.00000,149.9999)  mins10tot0812g=2.
if range(mins10tot0812,30.00000,59.9999)  mins10tot0812g=3.
if range(mins10tot0812,0.00000,29.9999)  mins10tot0812g=4.
val labels  mins10tot0812g 
1 'Meets guidelines'
2 'Some activity'
3 'Low activity'
4 'Inactive'.
var label mins10tot0812g "(D) 2012 recommendations on HSE 2008 data".
exe.

save outfile = "N:\Temp\HSE2008RF.sav"
/keep point1 HSEyear sex age wt_nurse wt_int omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 smoke highBP bmivg52 mins10tot0812 mins10tot0812g
wtval htval topqual3 bpmedd alclimit07b origin1.


* 2009.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse09ai.sav"
/KEEP psu sex age wt_nurse wt_int wt_blood cigsta3 diabete2 glyhbval
hyper1om hyper2om hy140om
hibp1om hibp2om hbp140om
hyper1di hyper2di hy140di
hibp1di hibp2di
hbp140di omsysval omdiaval topqual3 sclass
medbi01 to medbi22
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd bpmedd ag16g10 bmival nuroutc
wtval htval bp1 alclimit07b origin.

select if age>=16.
exe.

compute psu99=psu.
EXECUTE.

FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2009".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=7.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ANy(origin,1,2,3) origin1=1.
if any(origin,4,5,6,7,8,9,10,11,12,13,14,15,16) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
exe.

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Hypertension (meds for high BP).

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.

compute diabete3b=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3b=1.
If (Glyhbval>0 & diabete2=1) diabete3b=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3b=3.
If any(-9,diabete2) diabete3b=-9.
If any(-8,diabete2) diabete3b=-8.
If any(-1,diabete2) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3b "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3b (-9,-8,-1).
exe.

save outfile = "N:\Temp\HSE2009RF.sav"
/keep point1 HSEyear sex age wt_nurse wt_int wt_blood omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52 diabete3b
wtval htval topqual3 bp1 bpmedd alclimit07b origin1.

* 2010.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse10ai.sav"
/KEEP psu sex age wt_blood wt_nurse wt_int cigsta3 diabete2 glyhbval
hyper1om
hyper2om
hy140om
hibp1om
hibp2om
hbp140om
hyper1di
hyper2di
hy140di
hibp1di
hibp2di
hbp140di omsysval omdiaval topqual3
medbi01 to medbi22
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd bpmedd ag16g10 bmival nuroutc
wtval htval bp1 alclimit07b origin.

select if age>=16.
EXECUTE.

compute psu99=psu.
EXECUTE.

FORMAT psu99 (F4).
EXE.
string areastr (a4).
compute AREAstr = STRING(psu99,F4).
exe.
compute AREAstr = LTRIM(areastr).
exe.
string year1 (a4).
compute year1="2010".
exe.
STRING point1 (A8).
COMPUTE point1 = CONCAT(year1,areastr).
EXECUTE.

compute HSEyear=8.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ANy(origin,1,2,3) origin1=1.
if any(origin,4,5,6,7,8,9,10,11,12,13,14,15,16) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
EXECUTE.

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

**Hypertension (meds prescribed for high BP).

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.

compute diabete3b=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3b=1.
If (Glyhbval>0 & diabete2=1) diabete3b=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3b=3.
If any(-9,diabete2) diabete3b=-9.
If any(-8,diabete2) diabete3b=-8.
If any(-1,diabete2) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3b "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3b (-9,-8,-1).
exe.

save outfile = "N:\Temp\HSE2010RF.sav"
/keep point1 HSEyear sex age wt_blood wt_nurse wt_int omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52 diabete3b
wtval htval topqual3 bp1 bpmedd alclimit07b origin1.



* 2011.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse2011ai.sav"
/KEEP psu sex age wt_nurse wt_blood omsysval omdiaval hy140om2 topqual3
medbi01 to medbi15 wt_int cigsta3 diabete2
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd bpmedd ag16g10 bmival nuroutc glyhbval lipid cholval1old
wtval htval bp1 alclimit07b origin.

select if age>=16.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu, F7.0).
EXECUTE.

compute HSEyear=9.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ANy(origin,1,2,3,4) origin1=1.
if any(origin,5,6,7,8,9,10,11,12,13,14,15,16,17,18) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
exe.

*Raised cholesterol.

compute raised=-2.
if range(cholval1old,0,4.9) raised=0.
if cholval1old>4.9 raised=1.
exe.

*BMI.

compute bmival2=bmival.
exe.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Hypertension.

compute hy140om=hy140om2.
EXECUTE.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.

compute diabete3a=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3a=1.
If (Glyhbval>0 & diabete2=1) diabete3a=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3a=3.
If any(-9,diabete2) diabete3a=-9.
If any(-8,diabete2) diabete3a=-8.
If any(-1,diabete2) diabete3a=-1.
Value labels diabete3a
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3a "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3a (-9,-8,-1).
EXECUTE.

**** use 6.5 for 2011 (48+ after).

compute diabete3b=diabete3a.
exe.

save outfile = "N:\Temp\HSE2011RF.sav"
/keep point1 HSEyear sex age wt_blood wt_nurse wt_int omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52 diabete3a diabete3b
lipid cholval1old raised wtval htval topqual3 bp1 bpmedd alclimit07b origin1.


* 2012.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse2012ai.sav"
/KEEP psu sex age wt_nurse wt_int wt_blood diabete2 cigsta3 omsysval omdiaval hy140om2 topqual3 sclass
medbi01 to medbi15
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd bpmedd2 ag16g10 bmival2 nuroutc mins10tot0812g glyhbval cholest ifcca1
wtval htval bp1 alclimit07b origin.

select if age>=16.
EXECUTE.

compute psu99=psu.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

compute HSEyear=10.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ANy(origin,1,2,3,4) origin1=1.
if any(origin,5,6,7,8,9,10,11,12,13,14,15,16,17,18) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
EXECUTE.

*Hypertension.

compute bpmedd=bpmedd2.
exe.

compute hy140om=hy140om2.
EXECUTE.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Cholesterol.

compute cholest2=cholest - 0.1.
EXECUTE.

compute raised=-2.
if range(cholest2,0,4.9) raised=0.
if cholest2>4.9 raised=1.
EXECUTE.

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Diabetes.

compute diabete3b=-11.
If (ifcca1>0 & ifcca1<48) & (diabete2=2) diabete3b=1.
If (ifcca1>0 & diabete2=1) diabete3b=2.
If (ifcca1>=48) & (diabete2=2) diabete3b=3.
If any(-9,diabete2) diabete3b=-9.
If any(-8,diabete2) diabete3b=-8.
If any(-1,diabete2) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=48mmol/l".
Variable label diabete3b "(D) Diabetes from blood sample (48+mmol/mol) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values  diabete3b (-9,-8,-1).
EXECUTE.

compute diabete3a=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3a=1.
If (Glyhbval>0 & diabete2=1) diabete3a=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3a=3.
If any(-9,diabete2) diabete3a=-9.
If any(-8,diabete2) diabete3a=-8.
If any(-1,diabete2) diabete3a=-1.
Value labels diabete3a
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3a "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3a (-9,-8,-1).

save outfile = "N:\Temp\HSE2012RF.sav"
/keep point1 HSEyear sex age wt_blood wt_nurse wt_int omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52 mins10tot0812g diabete3a diabete3b
raised cholest2 wtval htval topqual3 bp1 bpmedd alclimit07b origin1.


* 2013.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse2013ai.sav"
/KEEP psu sex age wt_blood wt_nurse wt_int cigsta3 diabete2 omsysval omdiaval hy140om2 topqual3 sclass
medbi01 to medbi15
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd bpmedd2 ag16g10 bmival2 nuroutc Glyhbval qrtnvis ifcca1
wtval htval everbp alclimit07b origin cholest.

select if age>=16.
EXECUTE.

compute psu99=psu.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

compute HSEyear=11.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if ANy(origin,1,2,3,4) origin1=1.
if any(origin,5,6,7,8,9,10,11,12,13,14,15,16,17,18) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
EXECUTE.

*Cholesterol.

compute cholest2=cholest - 0.1.
EXECUTE.

compute raised=-2.
if range(cholest2,0,4.9) raised=0.
if cholest2>4.9 raised=1.
EXECUTE.


*Hypertension.

compute bpmedd=bpmedd2.
exe.

compute hy140om=hy140om2.
exe.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.


*Diabetes.

compute adjusted=-1.
if range(qrtnvis,1,3) adjusted=ifcca1.
if (qrtnvis=4) & range(ifcca1,15,44) adjusted=ifcca1+1.
if (qrtnvis=4) & range(ifcca1,45,74) adjusted=ifcca1+2.
if (qrtnvis=4) & range(ifcca1,75,168) adjusted=ifcca1+3.
exe.
desc var adjusted.

compute diabete3b=-11.
If (adjusted>0 & adjusted<48) & (diabete2=2) diabete3b=1.
If (adjusted>0 & diabete2=1) diabete3b=2.
If (adjusted>=48) & (diabete2=2) diabete3b=3.
If any(-9,diabete2) diabete3b=-9.
If any(-8,diabete2) diabete3b=-8.
If any(-1,diabete2) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=48mmol/l".
Variable label diabete3b "(D) Diabetes from blood sample (48+mmol/mol) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values  diabete3b (-9,-8,-1).

compute diabete3a=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3a=1.
If (Glyhbval>0 & diabete2=1) diabete3a=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3a=3.
If any(-9,diabete2) diabete3a=-9.
If any(-8,diabete2) diabete3a=-8.
If any(-1,diabete2) diabete3a=-1.
Value labels diabete3a
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3a "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3a (-9,-8,-1).

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

save outfile = "N:\Temp\HSE2013RF.sav"
/keep point1 HSEyear sex age wt_blood wt_nurse wt_int omsysval omdiaval hy140om ag16g10 bmival2 cigsta3 diabete2 smoke highBP bmivg52 diabete3a diabete3b
wtval htval topqual3 bpmedd alclimit07b origin1 raised.


* 2014.

dataset close all.
GET FILE="N:\RF by BMI\Updated archive files\hse2014ai.sav"
/KEEP psu sex ag16g10 wt_blood wt_nurse wt_int omsysval omdiaval hy140om2 topqual3 sclass
medbi01 to medbi15
ytake012 ytake022 ytake032 ytake042 ytake052 ytake062 ytake072 ytake082
ytake092 ytake102 ytake112 ytake122 ytake132 ytake142 ytake152 ytake162 ytake172
ytake182 ytake192 ytake202 ytake212 ytake222 medcnjd bpmedd2 ag16g10 age90 bmival2 nuroutc cigsta3 diabete2 Glyhbval cholest ifcca1
wtval htval bp1 alclimit07b origin2.

compute age=age90.
exe.
select if ag16g10>=1.
EXECUTE.

compute psu99=psu.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

compute HSEyear=12.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if any(origin2,1) origin1=1.
if any(origin2,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".
fre origin1.

*Hypertension.

compute bpmedd=bpmedd2.
exe.

compute hy140om = hy140om2.
exe.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.
* Reproduce the new adjustment from the old (CORRECT).

compute iffcvala=0.
if range(ifcca1,15,44) iffcvala=ifcca1+1.
if range(ifcca1,45,74) iffcvala=ifcca1+2.
if range(ifcca1,75,168) iffcvala=ifcca1+3.
exe.

compute diabete3b=-11.
If (iffcvala>0 & iffcvala<48) & (diabete2=2) diabete3b=1.
If (iffcvala>0 & diabete2=1) diabete3b=2.
If (iffcvala>=48) & (diabete2=2) diabete3b=3.
If any(-9,diabete2,iffcvala) diabete3b=-9.
If any(-8,diabete2,iffcvala) diabete3b=-8.
If any(-1,diabete2,iffcvala) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=48mmol/l".
Variable label diabete3b "(D) Diabetes from blood sample (48+mmol/mol) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values  diabete3b (-9,-8,-1).

compute diabete3a=-11.
If (Glyhbval>0 & Glyhbval<6.5) & (diabete2=2) diabete3a=1.
If (Glyhbval>0 & diabete2=1) diabete3a=2.
If (Glyhbval>6.4) & (diabete2=2) diabete3a=3.
If any(-9,diabete2) diabete3a=-9.
If any(-8,diabete2) diabete3a=-8.
If any(-1,diabete2) diabete3a=-1.
Value labels diabete3a
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=6.5%".
Variable label diabete3a "(D) Diabetes from blood sample (>=6.5%) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values diabete3a (-9,-8,-1).

*Cholesterol.

compute adjusted=cholest - 0.1.
EXECUTE.

compute raised=-2.
if range(adjusted,0,4.9) raised=0.
if adjusted>4.9 raised=1.
EXECUTE.

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

save outfile = "N:\Temp\HSE2014RF.sav"
/keep point1 HSEyear sex ag16g10 wt_blood wt_nurse wt_int omsysval omdiaval hy140om ag16g10 age bmival2 cigsta3 diabete2 smoke highBP bmivg52 
diabete3a diabete3b cholest raised wtval htval topqual3 bp1 bpmedd alclimit07b origin1.


*2015.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse2015ai.sav"
/KEEP psu sex ag16g10 wt_blood wt_nurse wt_int cigsta3 diabete2 omsysval omdiaval hy140om2 topqual3 sclass medcnjd bpmedd2
hyper1om2
hyper2om2
hy140om2
hibp1om2
hibp2om2
hbp140om2 ag16g10 age16g5 bmival2 nuroutc diabete3 iffcvala wtval htval bp1 alclimit07b origin2 cholest.

compute age=0.
exe.
if age16g5=1 age=16.5.
if age16g5=2 age=18.5.
if age16g5=3 age=22.
if age16g5=4 age=27.
if age16g5=5 age=32.
if age16g5=6 age=37.
if age16g5=7 age=42.
if age16g5=8 age=47.
if age16g5=9 age=52.
if age16g5=10 age=57.
if age16g5=11 age=62.
if age16g5=12 age=67.
if age16g5=13 age=72.
if age16g5=14 age=77.
if age16g5=15 age=82.
if age16g5=16 age=87.
if age16g5=17 age=90.
EXECUTE.

select if ag16g10>=1.
exe.

compute psu99=psu.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

compute HSEyear=13.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if any(origin2,1) origin1=1.
if any(origin2,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".

*Cholesterol.

compute cholest2=cholest - 0.1.
EXECUTE.

compute raised=-2.
if range(cholest2,0,4.9) raised=0.
if cholest2>4.9 raised=1.
EXECUTE.

*Hypertension.

compute bpmedd=bpmedd2.
exe.
compute hy140om=hy140om2.
exe.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.

compute  diabete3b=-11.
If (iffcvala>0 & iffcvala<48) & (diabete2=2) diabete3b=1.
If (iffcvala>0 & diabete2=1) diabete3b=2.
If (iffcvala>=48) & (diabete2=2) diabete3b=3.
If any(-9,diabete2,iffcvala) diabete3b=-9.
If any(-8,diabete2,iffcvala) diabete3b=-8.
If any(-1,diabete2,iffcvala) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=48mmol/l".
Variable label diabete3b "(D) Diabetes from blood sample (48+mmol/mol) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values  diabete3b (-9,-8,-1).

compute diabete3a = diabete3.
EXECUTE.

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

save outfile = "N:\Temp\HSE2015RF.sav"
/keep point1 HSEyear sex ag16g10 wt_nurse wt_int omsysval omdiaval hy140om ag16g10 age16g5 age bmival2 cigsta3 diabete2 smoke highBP bmivg52 
wt_blood diabete3a diabete3b wtval htval topqual3 bp1 bpmedd alclimit07b origin1 raised.


* 2016.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse2016_eul.sav"
/KEEP psu sex ag16g10 wt_blood wt_nurse wt_int omsysval omdiaval hy140om2 topqual3 sclass bpmedd2 medcnjd hy140om2 PregNowB
PregNTJ NCPregJ age16g5 bmival2 nuroutc mins10tot0812g cigsta3 diabete2 diabete3 iffcvala
wtval htval bp1 alclimit07b origin2 cholest. 

compute age=0.
exe.
if age16g5=1 age=16.5.
if age16g5=2 age=18.5.
if age16g5=3 age=22.
if age16g5=4 age=27.
if age16g5=5 age=32.
if age16g5=6 age=37.
if age16g5=7 age=42.
if age16g5=8 age=47.
if age16g5=9 age=52.
if age16g5=10 age=57.
if age16g5=11 age=62.
if age16g5=12 age=67.
if age16g5=13 age=72.
if age16g5=14 age=77.
if age16g5=15 age=82.
if age16g5=16 age=87.
if age16g5=17 age=90.
EXECUTE.

select if ag16g10>=1.
exe.

compute psu99=psu.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

compute HSEyear=14.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if any(origin2,1) origin1=1.
if any(origin2,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".

*Cholesterol.

compute cholest2=cholest - 0.1.
EXECUTE.
compute raised=-2.
if range(cholest2,0,4.9) raised=0.
if cholest2>4.9 raised=1.
EXECUTE.

*Hypertension.

compute bpmedd=bpmedd2.
exe.
compute hy140om = hy140om2.
EXECUTE.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Diabetes.

compute diabete3b=-11.
If (iffcvala>0 & iffcvala<48) & (diabete2=2) diabete3b=1.
If (iffcvala>0 & diabete2=1) diabete3b=2.
If (iffcvala>=48) & (diabete2=2) diabete3b=3.
If any(-9,diabete2,iffcvala) diabete3b=-9.
If any(-8,diabete2,iffcvala) diabete3b=-8.
If any(-1,diabete2,iffcvala) diabete3b=-1.
Value labels diabete3b
1 "No diabetes"
2 "Doctor diagnosed diabetes"
3 "Undiagnosed diabetes HbA1c>=48mmol/l".
Variable label diabete3b "(D) Diabetes from blood sample (48+mmol/mol) or doctor diagnosis (excluding pregnancy-only diabetes)".
missing values  diabete3b (-9,-8,-1).

compute diabete3a = diabete3.
EXECUTE.

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

save outfile = "N:\Temp\HSE2016RF.sav"
/keep point1 HSEyear sex ag16g10 wt_blood wt_nurse wt_int omsysval omdiaval hy140om age16g5 age bmival2 diabete2 smoke highBP bmivg52 
mins10tot0812g diabete3a diabete3b wtval htval topqual3 bp1 bpmedd alclimit07b origin1 raised.


*2017.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse17i_eul_v1.sav"
/KEEP psu sex ag16g10 wt_blood wt_nurse wt_int omsysval omdiaval hy140om2 topqual3 sclass bpmedd2 medcnjd hy140om2 PregNowB
PregNTJ NCPregJ age16g5 bmival2 nuroutc cigsta3 diabete2 diabete3
diab3mmol
diab3mmolg cholval13 cholfivea diab3mmol wtval htval bp1 alclimit07b origin2.

compute age=0.
exe.
if age16g5=1 age=16.5.
if age16g5=2 age=18.5.
if age16g5=3 age=22.
if age16g5=4 age=27.
if age16g5=5 age=32.
if age16g5=6 age=37.
if age16g5=7 age=42.
if age16g5=8 age=47.
if age16g5=9 age=52.
if age16g5=10 age=57.
if age16g5=11 age=62.
if age16g5=12 age=67.
if age16g5=13 age=72.
if age16g5=14 age=77.
if age16g5=15 age=82.
if age16g5=16 age=87.
if age16g5=17 age=90.
EXECUTE.

select if ag16g10>=1.
exe.

compute psu99=psu.
EXECUTE.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.
compute HSEyear=15.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if any(origin2,1) origin1=1.
if any(origin2,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".

*Hypertension.

compute bpmedd=bpmedd2.
exe.
compute hy140om = hy140om2.
exe.

compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Cholesterol.

compute raised=-2.
if range(cholval13,0,4.9) raised=0.
if cholval13>4.9 raised=1.
exe.

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.

*Diabetes.

compute diabete3a = diabete3.
EXECUTE.
compute diabete3b =  diab3mmol.
EXECUTE.

save outfile = "N:\Temp\HSE2017RF.sav"
/keep point1 HSEyear sex ag16g10 wt_nurse wt_int omsysval omdiaval hy140om age16g5 age bmival2 diabete2 smoke highBP bmivg52 wt_blood diabete3a diabete3b raised
wtval htval topqual3 bp1 bpmedd alclimit07b origin1.


*2018.

DATASET CLOSE ALL.
GET FILE="N:\RF by BMI\Updated archive files\hse_2018_eul.sav"
/KEEP PSU_SCR sex ag16g10 wt_blood wt_nurse wt_int omsysval omdiaval hy140om2 topqual3 sclass bpmedd2 medcnjd hy140om2 PregNowB
PregNTJ NCPregJ age16g5 bmival2 nuroutc cigsta3 diabete2 diabete3
diab3mmol diab3mmolg cholval13 cholfivea diab3mmol wtval htval origin2 bp1 alclimit07b origin2.

compute age=0.
exe.
if age16g5=1 age=16.5.
if age16g5=2 age=18.5.
if age16g5=3 age=22.
if age16g5=4 age=27.
if age16g5=5 age=32.
if age16g5=6 age=37.
if age16g5=7 age=42.
if age16g5=8 age=47.
if age16g5=9 age=52.
if age16g5=10 age=57.
if age16g5=11 age=62.
if age16g5=12 age=67.
if age16g5=13 age=72.
if age16g5=14 age=77.
if age16g5=15 age=82.
if age16g5=16 age=87.
if age16g5=17 age=90.
EXECUTE.

select if ag16g10>=1.
exe.

compute psu99 = PSU_SCR.
exe.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.
compute HSEyear=16.
EXECUTE.

*Ethnicity.

compute origin1=-2.
if any(origin2,1) origin1=1.
if any(origin2,2,3,4,5) origin1=0.
exe.
value labels origin1 0 "non-white" 1 "white".

*Hypertension.

compute bpmedd=bpmedd2.
exe.
compute hy140om = hy140om2.
exe.
compute highBP=-2.
if hy140om=1 highBP=0.
if range(hy140om,2,4) highBP=1.
value labels highBP 0 "Normotensive" 1 "HighBP".
EXECUTE.

*Cholesterol.

compute raised=-2.
if range(cholval13,0,4.9) raised=0.
if cholval13>4.9 raised=1.
exe.

*BMI.

compute bmivg52=-2.
if range(bmival2,0,18.4999) bmivg52=0.
if range(bmival2,18.5,24.9999) bmivg52=1.
if range(bmival2,25.000,29.9999) bmivg52=2.
if range(bmival2,30,34.9999) bmivg52=3.
if range(bmival2,35,100) bmivg52=4.
EXECUTE.
value labels bmivg52 0 "Underweight" 1 "Normal-weight" 2 "Overweight" 3 "Obese I" 4 "Obese II".

*Smoke.

compute smoke=-2.
if (cigsta3=2|cigsta3=3) smoke=0.
if cigsta3=1 smoke=1.
value labels smoke 0 "Non-smoke" 1 "Smoke".
EXECUTE.


*Diabetes.

compute diabete3a = diabete3.
EXECUTE.
compute diabete3b =  diab3mmol.
EXECUTE.

save outfile = "N:\Temp\HSE2018RF.sav"
/keep point1 HSEyear sex ag16g10 wt_nurse wt_int omsysval omdiaval hy140om age16g5 age bmival2 diabete2 smoke highBP bmivg52 wt_blood diabete3a diabete3b raised
wtval htval topqual3 origin2 bp1 bpmedd alclimit07b origin1.


*2003-2018.

dataset close all.
get file = "N:\Temp\HSE2003RF.sav".
add files/file=*/file= "N:\Temp\HSE2005RF.sav".
add files/file=*/file= "N:\Temp\HSE2006RF.sav".
add files/file=*/file= "N:\Temp\HSE2007RF.sav".
add files/file=*/file= "N:\Temp\HSE2008RF.sav".
add files/file=*/file= "N:\Temp\HSE2009RF.sav".
add files/file=*/file= "N:\Temp\HSE2010RF.sav".
add files/file=*/file= "N:\Temp\HSE2011RF.sav".
add files/file=*/file= "N:\Temp\HSE2012RF.sav".
add files/file=*/file= "N:\Temp\HSE2013RF.sav".
add files/file=*/file= "N:\Temp\HSE2014RF.sav".
add files/file=*/file= "N:\Temp\HSE2015RF.sav".
add files/file=*/file= "N:\Temp\HSE2016RF.sav".
add files/file=*/file= "N:\Temp\HSE2017RF.sav".
add files/file=*/file= "N:\Temp\HSE2018RF.sav".
exe.
value labels HSEyear 
1 "2003"
2 "2004"
3 "2005"
4 "2006"
5 "2007"
6 "2008"
7 "2009"
8 "2010"
9 "2011"
10 "2012"
11 "2013"
12 "2014"
13 "2015"
14 "2016"
15 "2017"
16 "2018".
fre HSEyear.

* 115,860.

TEMPORARY.
sel if bmivg52>=0.
fre HSEyear.

SAVE TRANSLATE OUTFILE='N:\RF by BMI\AnalysisFile_Dec2020.dta'
  /TYPE=STATA
  /VERSION=8
  /EDITION=SE
  /MAP
  /REPLACE.































