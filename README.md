run_analisys.R
========================================================
run_analysis.R in a R script to produce a table summarizing data collected from the accelerometers from the Samsung Galaxy S smartphone.
ach activity and each subject"
The output is a data set with the average of each variable for each activity and each subject
A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#How run_analysis.R works
Downloads data from link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

If folder "Input"" exists in working directory zip file is saved within it. If it doesn't exist the folder is created and the folder is saved inside accordingly

Unzips the downloaded file in working directory. All folders in zip file are reproduced within working directory (folders with same name will be overwritten)

Uploads in R tables both for Training and Test sets+
Includes in data sets the names of the columns, labels describing activity performed and subject+
Merges data sets adjusted in previous step in one single data frame including both Training and Test data+
From complete data set, selects columns including within their names the words mean and std since these are the indicators to denote the columns containing the mean and standard deviation respectivey (see README.txt file within unziped folder "UCI HAR Dataset" )

For the resulting reduced data frame produced in previous step it calculates the average by column grouping by activity and by subject

Saves a csv and a txt (tab separated values) of data frame generated in step above within working directory

Name of the csv file is TidyData.csv while name of the txt file is TidyData.txt

Please note you may need to open csv and txt file with appropriate software (r, excel, libreOffice, etc.) in order to see the data ordered in columns

