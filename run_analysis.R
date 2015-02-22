require(data.table)
require(reshape2)
#######################################################################################################################
# Step 1: Merge training and test sets to create one data set
# Load Test Data

# Before running statments below: set working directory to download samsung data directory 

x_test <- read.table("UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

# Load Training Data
x_train <- read.table("UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt")
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

# Combine the columns from x_test and y_test to make one test data set
test <- cbind(x_test, subject_test, y_test)

# Combine the columns from x_train and y_train to make one train data set
train <- cbind(x_train, subject_train, y_train)

# Load features.txt for naming variables in combined test + train data set
features <- read.table("UCI HAR Dataset\\features.txt")

# Load Activity lables
activitylabels <- read.table("UCI HAR Dataset\\activity_labels.txt")

# Combing test + train data set into one data set
combined <- rbind(test, train)

#######################################################################################################################
# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

# create column vector of with column indicies representing mean variables
meancolvector <- features[grep("mean", features$V2, ignore.case=T),]$V1
# create column vector of with column indicies representing std deviation variables
stdcolvector <- features[grep("std", features$V2, ignore.case=T),]$V1
## combine mean and std column indicies vector into one column index vector 
## with the last 2 indicies (562,563) added for the subject and activity columns
## 562 = Subject | 563 = Activity
columnIndicies <- sort(c(meancolvector, stdcolvector, 562, 563))

# Create data set with mean and std deviation columns extracted
extracted <- combined[,columnIndicies]


#######################################################################################################################
# Step 3: Uses descriptive activity names to name the activities in the data set

# Rename activity label columns
colnames(activitylabels) <- c("ActivityValue", "ActivityName")

# Use merge to match activitylabels values to activity values in extracted measurements data set
# This will add a descriptive activity name to the extracted data set
extractedActivityName = merge(extracted, activitylabels, by.x="V1.2", by.y="ActivityValue",all=T)

#######################################################################################################################
# Step 4: Appropriately labels the data set with descriptive variable names. 

# Create data set for looping columns to rename from features data set
rows <- features[sort(c(meancolvector, stdcolvector)),]

for(i in seq_len(nrow(rows))){
  # newname = new column name to be set in extracted data set
  newname <- make.names(as.character(rows[i,2]))
  # Set column name in data set to newname retrieved from features data set
  colnames(extractedActivityName)[i+1] <- newname
}

# Rename column with subject value to "Subject"
colnames(extractedActivityName)[colnames(extractedActivityName)=="V1.1"] <- "Subject"
colnames(extractedActivityName)[colnames(extractedActivityName)=="V1.2"] <- "ActivityValue"

#######################################################################################################################
# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Column names for measurments into vector for melting
columnnames <- colnames(extractedActivityName)[1:nrow(rows)+1]

# Use 'melt' to create tall, skinny data set for calculating mean for each variable by Subject and Activity
melted <- melt(extractedActivityName, id=c("Subject","ActivityName"),measure.vars=columnnames)

# Calculate mean for each variable by Subject and Activity
tidymean <- dcast(melted, Subject + ActivityName ~ variable, mean)
tidymean

## Tidy Data Set output
# write.table(tidymean, "TidyDataSet.txt", row.names=F)
