# GettingCleaningData

### Step 1: Merge training and test sets to create one data set
Load Test Data:
Before running statements in run_analysis.R, set working directory to the downloaded Samsung data directory 

The data are loaded in this order
1) Load Test data, which includes the following files: x_test.txt, y_test.txt and subject_test.txt.
2) Load Training Data, which includes the following files: x_train.txt, y_train.txt and subject_train.txt.
3) Features data is loaded originating from one file: features.txt. This is used for naming variables in combined test and train data set.
4) Activity labels are loaded from activity_labels.txt. This data describes the activity each test subject performed for a given observation in either the Test or Train data sets.
5) Lastly, all the data from both the Test data set and the Train data set are combined into one data set for analysis.

### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
All the Standard Deviation and Mean variables along with the Subject and Activity variable are extracted into one data set (named extracted in R code).

### Step 3: Uses descriptive activity names to name the activities in the data set
Using merge, the Activity values (1 through 6) are replaced with more descriptive names to identify the activity performed by a test or train subject.

### Step 4: Appropriately labels the data set with descriptive variable names. 
All the mean and standard deviation variable names are given the variable names found in the features.txt data set. Also, the Subject and Activity value column is renamed.

### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
The resultant data set from the steps above is 'melted' to create a tall, skinny data set that separates the the variable into rows so that the mean (average) can be calculated by Subject, ActivityName and Variable value. 

Finally, the data is outputed to a text file.