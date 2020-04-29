## Loading the dplyr package
library(dplyr)

---------------------------------------------------------------------------------------------------


## Reading all the required files
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Code", "Activity"))
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("Number", "Functions"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$Functions)
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "Code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$Functions)
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "Code")

---------------------------------------------------------------------------------------------------

## STEP 1
        
## Merging the data sets

## Merging all the rows of x_test and x_train
x <- rbind(x_test, x_train)

## Merging all the rows of y_test and y_train
y <- rbind(y_test, y_train)

## Merging all the rows of subject_test and subject_train
subject <- rbind(subject_test, subject_train)

## Merging all the column of x, y and subject
Merged_data <- cbind(subject, x, y)

## Getting the names of all the columns of Merged_data df
names(Merged_data)

---------------------------------------------------------------------------------------------------

## Step 2
        
## Extracting only the measurements on the mean and standard deviation for each measurement.
extracted_data <- Merged_data %>% select(Subject, Code, contains("mean"), contains("std"))

---------------------------------------------------------------------------------------------------

## STEP 3
        
## Using descriptive activity names to name the activities in the data set.
extracted_data$Code <- activities[extracted_data$Code, 2]

---------------------------------------------------------------------------------------------------

## STEP 4
        
## Appropriately labelling the data set with descriptive variable names.
names(extracted_data)[2] <- "Activity"
names(extracted_data) <- gsub("Acc", "Accelerometer", names(extracted_data))
names(extracted_data) <- gsub("Gyro", "Gyroscope", names(extracted_data))
names(extracted_data) <- gsub("BodyBody", "Body", names(extracted_data))
names(extracted_data) <- gsub("Mag", "Magnitude", names(extracted_data))
names(extracted_data) <- gsub("^t", "Time", names(extracted_data))
names(extracted_data) <- gsub("^f", "Frequency", names(extracted_data))
names(extracted_data) <- gsub("tBody", "TimeBody", names(extracted_data))
names(extracted_data) <- gsub("-mean()", "Mean", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("-std()", "STD", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("-freq()", "Frequency", names(extracted_data), ignore.case = TRUE)
names(extracted_data) <- gsub("angle", "Angle", names(extracted_data))
names(extracted_data) <- gsub("gravity", "Gravity", names(extracted_data))

---------------------------------------------------------------------------------------------------

## STEP 5
        
## creating a second, independent tidy data set with the average of each variable for each activity 
## and each subject.
FinalData <- extracted_data %>%
        group_by(Subject, Activity) %>%
        summarise_all(funs(mean))

write.table(FinalData, "FinalData.txt", row.name=FALSE)