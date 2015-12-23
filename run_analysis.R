temp <- "project_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

library(plyr)

# set the working directory
setwd("C:/Users/11855/Documents/0_FCS/R/Coursera/GCD Project")

# read each csv file
feat <- read.table(unz("project_data.zip", "UCI HAR Dataset/features.txt"), header=F, sep="")
actlab <- read.table(unz("project_data.zip", "UCI HAR Dataset/activity_labels.txt"), header=F, sep="")
test <- read.table(unz("project_data.zip", "UCI HAR Dataset/test/X_test.txt"), header=F, sep="")
train <- read.table(unz("project_data.zip", "UCI HAR Dataset/train/X_train.txt"), header=F, sep="")
testlab <- read.table(unz("project_data.zip", "UCI HAR Dataset/test/y_test.txt"), header=F, sep="")
trainlab <- read.table(unz("project_data.zip", "UCI HAR Dataset/train/y_train.txt"), header=F, sep="")
testsub <- read.table(unz("project_data.zip", "UCI HAR Dataset/test/subject_test.txt"), header=F, sep="")
trainsub <- read.table(unz("project_data.zip", "UCI HAR Dataset/train/subject_train.txt"), header=F, sep="")

## Uses descriptive activity names to name the activities in the data set
actlab[,2] <- as.character(actlab[,2])
actlab[1,2] <- "WALKING - LEVEL"
actlab[2,2] <- "WALKING - UPSTAIRS"
actlab[3,2] <- "WALKING - DOWNSTAIRS"
actlab[4,2] <- "STATIC - SITTING"
actlab[5,2] <- "STATIC - STANDING"
actlab[6,2] <- "STATIC - LAYING"


# Add the column label to the integer in both testlab and trainlab
colnames(actlab) <- c("Label Integer", "Activity_Label")
colnames(testlab) <- "Label Integer"
colnames(trainlab) <- "Label Integer"
testlab <- join(testlab,actlab,by="Label Integer")
trainlab <- join(trainlab,actlab,by="Label Integer")

# add names to test and train data frames, add a "test" or "training" identifier to each data set
# and then cbind with the correct labels.  Lastly, rbind test and train to get one large data frame with results.
names(test) <- feat[,2]
names(train) <- feat[,2]

# add "Training" or "Testing" and subject Integer to corresponding dataset
train <- cbind("Training",trainsub,train)
test <- cbind("Testing",testsub,test)

# Update names for 1st two columns so they are descriptive and match before combining datasets
names(train)[1] ="Training_or_Testing"
names(test)[1] ="Training_or_Testing"
names(train)[2] ="Subject_Integer"
names(test)[2] ="Subject_Integer"

# add activity labels to each dataset
train <- cbind(trainlab,train)
test <- cbind(testlab,test)

##
## Merge the training and the test sets to create one data set.
##
alldata <- rbind(train,test)
# remove the first row - it is just the integer corresponding to the activity label
alldata <- alldata[,2:565]

## Extracts only the measurements on the mean and standard deviation for each measurement. 

# pull out only the mean and std data columns
# create a logical vector with TRUE for names with mean or std
meanstdboolean <- ifelse(grepl("mean", feat$V2), TRUE, ifelse(grepl("std", feat$V2), TRUE, FALSE))
# create dataframe with 1st three columns and only mean and std columns
allmeanstddata <- subset(alldata[,c(TRUE, TRUE, TRUE, meanstdboolean)])

## Appropriately labels the data set with descriptive variable names. 
names(allmeanstddata) <- gsub("-mean()"," Average ",names(allmeanstddata), fixed = TRUE, useBytes = FALSE)
names(allmeanstddata) <- gsub("-std()"," Standard Deviation ",names(allmeanstddata), fixed = TRUE, useBytes = FALSE)
names(allmeanstddata) <- gsub("-meanFreq()"," Average Frequency ",names(allmeanstddata), fixed = TRUE, useBytes = FALSE)
names(allmeanstddata) <- gsub("-X"," X Direction",names(allmeanstddata), fixed = TRUE, useBytes = FALSE)
names(allmeanstddata) <- gsub("-Y"," Y Direction",names(allmeanstddata), fixed = TRUE, useBytes = FALSE)
names(allmeanstddata) <- gsub("-Z"," Z Direction",names(allmeanstddata), fixed = TRUE, useBytes = FALSE)

## From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.


## Need to calculate the column means by subject and activity next.
allmeanstddata <- aggregate(allmeanstddata,by=list(allmeanstddata$Activity_Label, allmeanstddata$Subject_Integer), FUN=mean, na.rm=TRUE)
allmeanstddata <- allmeanstddata[ , -which(names(allmeanstddata) %in% c("Activity_Label","Training_or_Testing","Subject_Integer"))] # drop the original columns not needed
# NOTE - Did not delineate between Test and Train....

# rename the "group by" columns
names(allmeanstddata)[1] <- "Activity Label"
names(allmeanstddata)[2] <- "Subject Integer"

# write the summary data table using the write.table() action
write.table(allmeanstddata, file = "run_analysis_data.txt", row.names = FALSE, sep = " ")

#as a test, read the table back into a df.  All looks good.
testread <- read.csv("run_analysis_data.txt",header=TRUE, sep = " ")