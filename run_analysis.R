#GACD - Course Project

#### Downloading data 

install.packages("downloader")
library(downloader)

#setwd() AS NEEDED

#Download and unzip the file containing training & test datasets
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest = "GACD_2.zip", mode = "wb")

unzip("GACD_2.zip", exdir = "./")

#Looking at contents
file_list <- list.files("~/UCI HAR Dataset")
file_list_test <- list.files("~/UCI HAR Dataset/test")
file_list_train <- list.files("~/UCI HAR Dataset/train")

#load all data from the test and train datasets, as well as the subject IDs, activity labels, and features
#- A 561-feature vector with time and frequency domain variables, for the test set
test.x<-read.table("./UCI HAR Dataset/test/X_test.txt")
	dim(test.x)
	#head(test.x)
test.y<-read.table("./UCI HAR Dataset/test/y_test.txt")
	dim(test.y)
	head(test.y)
Subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
	dim(Subject_test)
#- A 561-feature vector with time and frequency domain variables, for the training set
train.x<-read.table("./UCI HAR Dataset/train/X_train.txt")
	dim(train.x)
train.y<-read.table("./UCI HAR Dataset/train/y_train.txt")
	dim(train.y)
Subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
	dim(Subject_train)

activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
	dim(activity_labels)
features<-read.table("./UCI HAR Dataset/features.txt")
	dim(features)
	head(features)
	table(features[,2]) # long list of means, sd's max's and min's



#### Tasks for run_analysis.R

#	1	Merges the training and the test sets to create one data set.

All_X <- rbind(train.x, test.x)

#	2	Extracts only the measurements on the mean and standard deviation for each measurement. 

#Name the columns of the new dataset based on the info from the features file
colnames(All_X) <- c(as.character(features[,2]))

#Find all the columns labeled as means
Mean <- grep("mean()", colnames(All_X), fixed = TRUE)

#Find all the columns labeled as standard deviations
SD <- grep("std()", colnames(All_X), fixed=TRUE)

#Create a new subset from all the columns that are Means or SDs
X_Mean_SD <- All_X[,c(Mean,SD)]
	#dim(X_Mean_SD) #Down to 66 columns, from 561

#	3	Uses descriptive activity names to name the activities in the data set

#Add the Y data to the subsetted DF - one new column to identify activities by number
All_Y <- rbind(train.y, test.y)
	#dim(All_Y)
	#head(All_Y)
	
XY_DF <- cbind(All_Y, X_Mean_SD)	
colnames(XY_DF)[1] <- "Activity"

#Replace number labels with word labels
	#dim(activity_labels)
	#activity_labels

XY_DF$Activity <- gsub(1, "WALKING",  XY_DF$Activity)
XY_DF$Activity <- gsub(2, "WALKING_UPSTAIRS",  XY_DF$Activity)
XY_DF$Activity <- gsub(3, "WALKING_DOWNSTAIRS",  XY_DF$Activity)
XY_DF$Activity <- gsub(4, "SITTING",  XY_DF$Activity)
XY_DF$Activity <- gsub(5, "STANDING",  XY_DF$Activity)
XY_DF$Activity <- gsub(6, "LAYING",  XY_DF$Activity)
	
	#Check replacement
table(XY_DF$Activity)

#	4	Appropriately labels the data set with descriptive variable names. 

	#I take this to mean the columns, 
colnames(XY_DF)
	#but I think they're fairly descriptive for headers, so I'm not editing these further. 
	
#	5	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Need to incorproate the Subject train & test info
Subject_All <- rbind(Subject_train, Subject_test)


#Bind the Subject data to the XY dataframe	
XY_DF <- cbind(Subject_All, XY_DF)

#Name that column
colnames(XY_DF)[1] <- "Subject_ID"

#Aggregate to get mean by Subject and Activity

#Create a framework for Tidy_DF
Tidy_DF <- aggregate( XY_DF[ , 3 ] ~ Subject_ID + Activity, data = XY_DF, FUN= "mean" )

#Run the rest of the columns
for(i in 4:ncol(XY_DF)) {
	Tidy_DF[ , i ] <- aggregate( XY_DF[ , i ] ~ Subject_ID + Activity, data = XY_DF, FUN = "mean")[ , 3 ]
}


#Rename columns
colnames(Tidy_DF) [3:ncol(Tidy_DF) ] <- colnames(X_Mean_SD)

#Write table
write.table(Tidy_DF, file = "TidyData.txt", row.name=FALSE)
