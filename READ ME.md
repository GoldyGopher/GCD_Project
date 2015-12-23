run_analysis.R script explanation

Define the working directory

Download "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" as "project_data.zip" to the working directory.

Read the following files into the defined dataframe:
feat <- "CI HAR Dataset/features.txt 			561x2	Col2 contains labels of 561 data columns
actlab <- UCI HAR Dataset/activity_labels.txt		6x2	Col1 is an INT 1-6; Col2 is the label description
test <- UCI HAR Dataset/test/X_test.txt			2947x561 Test set data
train <- UCI HAR Dataset/train/X_train.txt		7352x561 Training set data
testlab <- UCI HAR Dataset/test/y_test.txt		2947x1	INT 1-6 coresponding to the actLab for the Test set 
trainlab <- UCI HAR Dataset/train/y_train.txt		7352x1	INT 1-6 coresponding to the actLab for the Training set
testsub <- UCI HAR Dataset/test/subject_test.txt	2947x1	INT coresponding to the subject
trainsub <- UCI HAR Dataset/train/subject_train.txt	7352x1	INT coresponding to the subject

** update activity label files with actual label description
1. Change column headings on actlab - "Label_Int" and "Activity_Label"
2. Change column heading on testlab and trainlab to "Label_Int"
3. perform a join on testlab and trainlab.  In both cases for the mathing Label_Int, add the corresponding Activity_Label.

** change column headers for test and train dataframes.
In both cases set the names of each to the 2nd column in the "feat" data frame

Before using rbind to append the test df to the train df, add a column used to specify whether the row is from the test or train dataframe.
using cbind, add a column filled with "training" to the train df
using cbind, add a column filled with "testing" to the test df
Name the first column in both test and train to "Test or Train"

Using cbind, add the activity labels to the corresponding test or train data frames.
Finally, using rbind, append the test data onto the train data frame.

alldata is 10299x564 data frame.
Column 1 is the activity integer (1-6)
Column 2 is the corresponding activity label
Column 3 is either "testing" or "training"
columns 4-564 are the data measurements
The first 7352 rows are from the training data set
The last 2947 rows are from the testing data set

** next step is to subset the mean and std data into a new data frame
Create a logical vector called "meanstdboolean" that is TRUE if the column name contains "mean" or "std"
I used the "grepl" function to pull these out.
Next we subset alldata where meanstdboolean is TRUE.
NOTE - add three TRUE logical entries to meanstdboolean to keep 1st three columns

** the allmeanstddata data frame is a subset of alldata, but only for data columns that contain the mean or std data.

Next appropriately labels the data set with descriptive variable names.  This involves using the gsub action to replace......
"-mean()" with " Average ", "-std()" with " Standard Deviation ", "-meanFreq()" with " Average Frequency ", "-X" with " X Direction",
"-Y" with " Y Direction" and "-Z" with " Z Direction".

## Need to calculate the column means by subject and activity next.
Use the aggregate function to calculate the mean by Activity and Subject.  Remove columns that can't have a mean calculated and rename the columns that were used to group by.

using the write.table() function, write the summary data file to the wd() with the filename run_analysis_data.txt.

End

