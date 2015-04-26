## -----------------------------------------------------------------------------
## Author: Jake Ruttenberg
## Script: run_analysis.R
## -----------------------------------------------------------------------------

library(plyr)

## -----------------------------------------------------------------------------
## Step 1
## Merges the training and the test sets to create one data set
## -----------------------------------------------------------------------------

## Read train data
x_trainDf <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
y_trainDf <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject_trainDf <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

## Read test data
x_testDf <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_testDf <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_testDf <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

## Bind the test and train data frames
x_combinedDf <- rbind(x_trainDf,x_testDf)
y_combinedDf <- rbind(y_trainDf,y_testDf)
subject_combinedDf <- rbind(subject_trainDf,subject_testDf)

## -----------------------------------------------------------------------------
## Step 2
## Extracts only the measurements on the mean and standard deviation for each
## measurement
## -----------------------------------------------------------------------------

## Read the feature data
featuresDf<-read.table("./UCI HAR Dataset/features.txt")

## Pull out columns with mean() or std()
mean_stdDf<-grep("mean\\(\\)|std\\(\\)",featuresDf[,2])

## Extract only the desired measurements
x_combinedDf<-x_combinedDf[,mean_stdDf]

## Set the column names of the combined data frame
names(x_combinedDf)<-featuresDf[mean_stdDf,2]

## -----------------------------------------------------------------------------
## Step 3
## Uses descriptive activity names to name the activities in the data set
## -----------------------------------------------------------------------------

## Read the activity label data
activityDf<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)

## Merge activity description data frame with activity data frame
y_combinedDf[,1] <- activityDf[y_combinedDf[,1],2]

## -----------------------------------------------------------------------------
## Step 4
## Appropriately labels the data set with descriptive variable names
## -----------------------------------------------------------------------------

## Set the column name for activity data frame
names(y_combinedDf)[1] <- "activity"

## Set the column name for subject data frame
names(subject_combinedDf)[1] <- "subject"

## Bind columns together from Feature, Subject, and Activity data frames
total_combinedDf<-cbind(x_combinedDf,subject_combinedDf,y_combinedDf)

## -----------------------------------------------------------------------------
## Step 5
## From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject
## -----------------------------------------------------------------------------

## Calculate mean values for measures grouped by subject and activity
averagesDf<-ddply(total_combinedDf, .(subject, activity), function(x) colMeans(x[,1:66]))

## Write data to output file
write.table(averagesDf, "./UCI HAR Dataset/final_data.txt", sep="\t", row.names=FALSE)