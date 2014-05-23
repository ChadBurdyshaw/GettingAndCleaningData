#run_analysis.R
#getting and cleaning data project

#You should create one R script called run_analysis.R that does the following:

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each
#   measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive activity names. 
#5. Creates a second, independent tidy data set with the average of each variable 
#   for each activity and each subject.

#read labels and keep only second column
CLabels=read.table("features.txt",sep="",dec=".")[2]

#save col indices for labels with "mean()" and "std()" in text
#Do not include meanFreq as this should be counted as a mean of set of variables and it does not
#have a corresponding set of stdev values
CMean=grep("mean()",CLabels$V2,fixed=TRUE)#collect row indices with mean() in text string
CStd=grep("std()",CLabels$V2,fixed=TRUE)#collect row indices with std() in text string

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

#read in test data, using CLabels to provide names for the columns
Xtest=read.table("X_test.txt",sep="",dec=".",col.names=CLabels$V2)
#read in test data labels and name the column "activityLabel"
Ytest=read.table("y_test.txt",col.names=c("activityLabel"))

#read in training data
Xtrain=read.table("X_train.txt",sep="",dec=".",col.names=CLabels$V2)
#read in training data labels and name the column "activityLabel"
Ytrain=read.table("y_train.txt",col.names=c("activityLabel"))

#join training and test variable sets into single set
Xcomplete=rbind(Xtrain,Xtest)
#join training and test label sets into single set
Ycomplete=rbind(Ytrain,Ytest)

#add Labels column to Xvariables data frame
UCIHAR=Xcomplete
UCIHAR$activityLabel=Ycomplete$activityLabel

#create subset which contains only the mean and stdev for each measurement
#sort output so that each variables mean and std are grouped together
UCIHAR.MeanStdev=UCIHAR[sort(c(CMean,CStd))]
#the following two commented out commands are for debuggin/analysis purposes
#write data set to file (Don't actually do this. This is not the data set asked for in the instructions.)
#write.table(UCIHAR.MeanStdev,"UCIHAR_MeanStdev.txt")

#Creates a second, independent tidy data set which contains the average of each variable in the  
#   for each activity and each subject.
#I take this instruction to mean that we create a new data set which contains the mean of each of the variables
#   over all the rows in the original data set
UCIHAR.avg.data=lapply(UCIHAR,mean)

#write data set to file
write.table(UCIHAR.avg.data,"UCIHAR_avg_data.txt")
