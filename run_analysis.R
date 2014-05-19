#Uploade packages to be used in the script
library(plyr)
library(data.table)

#Download the file and save it Input folder in working directory

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("Input")){
  dir.create("Input")
}
download.file(url=fileUrl,destfile="./Input/Data.zip",method="curl")

#Unzip the dowloaded file in working directory
#the files will overwrite existing with similar names

unzip(zipfile="./Input/Data.zip",exdir="./")

ColFeatures <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
ActLabels<-read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")

#Include Column names for ActLabels
names(ActLabels)<-c("ActCode","ActLabel")

#Upload X Test set and includes column names
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
names(X_test)<-ColFeatures[,2]

#Upload Y Test labels, include column names and join with activity labels
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")
names(Y_test)<-c("ActCode")
Y_test_labeled<-join(Y_test,ActLabels,type="inner")

#Upload Test subjects, include column names
Subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")
names(Subject_test)<-c("Subject")

#Merges in on table all TestData frames
TestData<-cbind(Y_test_labeled,Subject_test,X_test)

#Clean tables used to create TestData
rm(Subject_test)
rm(X_test)
rm(Y_test)
rm(Y_test_labeled)

#Repeat steps above to create a TrainingData data frame 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
names(X_train)<-ColFeatures[,2]
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")
names(Y_train)<-c("ActCode")
Y_train_labeled<-join(Y_train,ActLabels,type="inner")
Subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
names(Subject_train)<-c("Subject")
TrainData<-cbind(Y_train_labeled,Subject_train,X_train)

#Clean tables used to create TrainData
rm(Subject_train)
rm(X_train)
rm(Y_train)
rm(Y_train_labeled)

#Merges TestData and TrainData
TotalData<-rbind(TrainData,TestData)

#Clean data frames used to create TotalData
rm(TestData)
rm(TrainData)

#We look in the names of the columns the ones that include "mean"
TotalNames=as.character(names(TotalData))
MeanNames<-grep(x=TotalNames,pattern="mean",value=TRUE)

#Exclude values for Freqmean
MeanNames<-grep(x=MeanNames,pattern="meanFreq",value=TRUE,invert=TRUE)

#We look in the names of the columns the ones that include "std"
StdNames<-grep(x=TotalNames,pattern="std",value=TRUE)

#Merge MeanNames & StdNames and order the results
SelectedNames<-c(MeanNames,StdNames)
SelectedNames<-sort(SelectedNames)

#Clean vectors used to create SelectedNames
rm(MeanNames)
rm(StdNames)
rm(TotalNames)

#Subset from TotaData Columns with names in SelectedNames
SelectedData<-TotalData[,SelectedNames]

#Add Columns with Subject and Activity Label
ExpSelectedData<-cbind("Activity"=TotalData$ActLabel
                       ,"Subject"=TotalData$Subject,SelectedData)

#Calculates means of the columns in the dataframe
FinalData<-aggregate(ExpSelectedData[,SelectedNames]
                        ,by=list(Activity=ExpSelectedData$Activity
                        ,Subject=ExpSelectedData$Subject),FUN="mean")
#Clean dataframes used to produce FinalData
rm(SelectedNames)
rm(SelectedData)
rm(ExpSelectedData)

#Saves the FinalData in csv & txt (space delimited) called TidyData
write.csv(x=FinalData,file="TidyData.csv",row.names=FALSE)
write.table(x=FinalData,file="TidyData.txt",sep="\t",append=FALSE
            ,row.names=FALSE)
