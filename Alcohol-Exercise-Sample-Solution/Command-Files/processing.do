/*THIS DO-FILE OPENS THE DATA FROM THE
HARVARD SCHOOL OF PUBLIC HEALTH COLLEGE
ALCOHOL STUDY (ICPSR 4291),

THEN PROCESSES THE DATA TO PREPARE THEM
FOR ANALYSIS,

THEN SAVES THE PROCESSED DATA IN A FILE
CALLED analysis.dta
*/

*WHEN YOU RUN THIS DO-FILE, MAKE SURE THAT
**********1) STATA'S WORKING DIRECTORY IS SET 
*************TO THE "Command-Files" FOLDER
**********2) THE HARVARD ALCOHOL STUDY DATA FILE
*************04291-0001-Data.dta IS SAVED IN THE
*************"Original-Data" FOLDER


clear
set more off

*START BY OPENING THE DATA FILE FROM THE HARVARD ALCOHOL STUDY
*Since that file is in the Original-Data folder, which is not
*the working directory, write a relative directory path to specify
*where it is located.
use ../Original-Data/04291-0001-Data.dta


*Drop all cases for which the student's residence is "Off-campus house/apt"
*or "other," or if variable A6 is missing

drop if A6==5 | A6==6 | A6==.

**************************
**************************
*GENERATE NEW VARIABLES
**************************
**************************

*Generate a variable "drunk"
*equal to 0 if student got drunk fewer than 3 times in last 30 days
*equal to 1 if student got drunk 3 or more times in last 30 days
gen drunk=1 if C13>=3
replace drunk=0 if C13==1 | C13==2
replace drunk=. if C13==.

*Generate a variable "hsdrunk"
*equal to 0 if student had 5+ drinks in a row fewer than 3 times in 
*senior year of high school
*equal to 1 if student student had 5+ drinks in a row 3 or more times in 
*senior year of high school
gen hsdrunk=1 if G11>=3
replace hsdrunk=0 if G11==1 | G11==2
replace hsdrunk=. if G11==.

*Generate a variable  "free"
*equal to 1 if student lives in alcohol-free housing
*equal to 0 if student does not live in alcohol-free housing
gen free=B8

*Generate a variable  "volfree"
*equal to 1 if student lives in alcohol-free housing by request  
*equal to 0 if student was assigned to live in alcohol-free housing
gen volfree=1 if free==1 & B9==1
replace volfree=0 if free==1 & B9==2

*Genereate a variable "housing"
*equal to 1 if student does not live in alcohol-free housing
*equal to 2 if student was assigned to live in alcohol-free housing
*equal to 3 if all campus housing is alcohol-free
*equal to 4 if student lives in alcohol-free housing by request
gen housing=1 if free==0
replace housing=2 if free==1 & B9==2
replace housing=3 if free==1 & B9==3
replace housing=4 if volfree==1

*Generate a variable "health"
*indicating student's self-reported health status 
*on a scale of 1 (Excellent) to 5 (Poor)
generate health=G6

**************************
**************************
*DROP UNNECESSARY VARIABLES
**************************
**************************

*Drop all variables except the six created by the 
*preceding commands
keep drunk hsdrunk free volfree housing health


**************************
**************************
*LABEL VARIABLES AND
*LABEL THE VALUES OF VARIABLES
**************************
**************************

*Label the variable "health"
label variable health "Health Rating"
*Label the values of "health"
label define health_labels 1 "Excellent" 2 "Very Good" 3 "Good" ///
	4 "Fair" 5 "Poor"
label values health health_labels

*Label the variable "drunk"
label variable drunk "Times drunk past 30 days"
*Label the values of "drunk"
label define drunk_labels 0 "2 or fewer" 1 "3 or more" 
label values drunk drunk_labels

*Label the variable "hsdrunk"
label variable hsdrunk "Times had 5+ drinks senior year of high school"
*Label the values of "hsdrunk"
label define hsdrunk_labels 0 "2 or fewer" 1 "3 or more" 
label values hsdrunk hsdrunk_labels

*Label the variable "free"
label variable free "Live in alcohol-free housing"
*Label the values of "free"
label define free_labels 0 "No" 1 "Yes" 
label values free free_labels

*Label the variable "volfree"
label variable volfree "Requested alcohol-free housing"
*Label the values of "volfree"
label define volfree_labels 0 "No" 1 "Yes" 
label values volfree volfree_labels

*Label the variable "housing"
label variable housing "Housing type"
*Label the values of "housing"
label define housing_labels 1 "Not alchohol free" 2 "Assigned to alcohol-free housing" ///
	3 "All campus housing alcohol-free" 4 "Requested alcohol-free housing"
label values housing housing_labels

****************************************************
****************************************************
*DROP CASES WITH MISSING VALUES OF KEY VARIABLES
****************************************************
****************************************************

drop if drunk==.
drop if hsdrunk==.
drop if housing==.


****************************************************
****************************************************
*SAVE THE MODIFIED DATA
****************************************************
****************************************************

*Save the modified data in a file called "analysis.dta"
*Use a relative directory path to make sure "analysis.dta" is saved
	*in the "Analysis-Data" folder
save ../Analysis-Data/analysis.dta, replace	

