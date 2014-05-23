GettingAndCleaningData
======================
repository for files and data sets required for Coursera class Getting and Cleaning Data
tidy data project

#Inlcudes files: 
#r-script file
run_analysis.R
#resulting tidy data file
UCIHAR_avg_data.txt
#input data files
X_test.txt,
X_train.txt,
y_test.txt,
y_train.txt,
features.txt,

#getting and cleaning data project instructions:
You should create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each
   measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable 
   for each activity and each subject.

#Project implementation: 
file run_analysis.R has been documented with decriptions of instructions and information
regarding process choices

I will describe many of the process decisions here.

Project task #3: "Uses descriptive activity names to name the activities in the data set".
Implemented using the following multi step process:

#read labels from features.txt file 
CLabels=read.table("features.txt",sep="",dec=".")[2]

Project task #2: "Extracts only the measurements on the mean and standard deviation for each measurement". 
is handled in the process of accomplishing task #3:

#collect row index values for text strings with substring mean() and std()
#Do not include meanFreq as this should be counted as a mean of set of variables and it does not
#have a corresponding set of stdev values
CMean=grep("mean()",CLabels$V2,fixed=TRUE) #collect row indices with mean() in text string 
CStd=grep("std()",CLabels$V2,fixed=TRUE) #collect row indices with std() in text string
 
Project task #4: "Appropriately labels the data set with descriptive activity names" is accomplished by 
modfying the strings collected from features.txt
#remove string characters that don't work well for variable names

#remove the parenthesis from all strings
replace_parens=function(x){gsub("[()]","",x)}
CLabels$V2=sapply(CLabels$V2,replace_parens)

#for readability, we will replace the commas separating the numbers with a dash
replace_comma=function(x){gsub(",","-",x)}
CLabels$V2=sapply(CLabels$V2,replace_comma)

#If a dash exists in a variable name string, these are automatically converted to 
# a "." when adding column names in read.table(). Therefore, for readability and to 
# avoid the conversion to ".", I've chosen to use the underscore to separate words in 
# the variable names, despite the concern that this goes against naming convention
replace_dash=function(x){gsub("-","_",x)}
CLabels$V2=sapply(CLabels$V2,replace_dash)

#I feel that in this instance, casting all characters to lower case would 
#drastically reduce readability.
#CLabels$V2=to_lower(CLabels$V2)#don't do this

#In addition, I've chosen to leave the decimal point character in some of the variable 
# names. Removing these characters would make these variables less descriptive and 
# possibly misleading

Complete project task #3 by adding our processed labels to the numerical data sets
#read in test data, using CLabels to provide names for the columns
Xtest=read.table("test/X_test.txt",sep="",dec=".",col.names=CLabels$V2)
#read in test data labels and name the column "activity.label"
Ytest=read.table("test/y_test.txt",col.names=c("activity.label"))

#read in training data
Xtrain=read.table("train/X_train.txt",sep="",dec=".",col.names=CLabels$V2)
#read in training data labels and name the column "activity.label"
Ytrain=read.table("train/y_train.txt",col.names=c("activity.label"))

Project task 1: "Merges the training and the test sets to create one data set."
#join training and test variable sets into single set
Xcomplete=rbind(Xtrain,Xtest)
#join training and test label sets into single set
Ycomplete=rbind(Ytrain,Ytest)
#add Labels column to Xvariables data frame
UCIHAR=Xcomplete
UCIHAR$activity.label=Ycomplete$activity.label

Finish project task #2 by creating a new data subset with only mean and stdev variables
#create subset which contains only the mean and stdev for each measurement
#sort output so that each variables mean and std are grouped together
UCIHAR.MeanStdev=UCIHAR[sort(c(CMean,CStd))]

Project task 5:"Creates a second, independent tidy data set which contains the average of each variable in the for each activity and each subject."
#I take this instruction to mean that we create a new data set which contains the mean of each of the variables
#   over all the rows in the original data set
UCIHAR.avg.data=lapply(UCIHAR,mean)

#write data set to file
write.table(UCIHAR.avg.data,"UCIHAR_avg_data.txt")
