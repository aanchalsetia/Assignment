file <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "hello", method = "curl" )
data <- unzip("hello")

##Reading files 
subject_text <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("no." ,"features"))
activity_lables <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activities"))
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$features)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$features)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
## 1. To merge the training and the test data set
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_text)
Merged_data <- cbind(Subject, Y, X)
View(Merged_data)

## To extract only the measurements on the mean and standard deviation for each measurement.
Extracted_Data <- Merged_data %>% select(subject, code, contains("mean"), contains("std"))
View(Extracted_Data)

##Uses descriptive activity names to name the activities in the data set
Extracted_Data$activitynames <- activity_lables[Extracted_Data$code, 2]

##Appropriately labels the data set with descriptive variable names.
names(Extracted_Data[1]) <- "Subject"
names(Extracted_Data[2]) <- "Activity"
names(Extracted_Data)<-gsub("Acc", "Accelerometer", names(Extracted_Data))
names(Extracted_Data)<-gsub("Gyro", "Gyroscope", names(Extracted_Data))
names(Extracted_Data)<-gsub("BodyBody", "Body", names(Extracted_Data))
names(Extracted_Data)<-gsub("Mag", "Magnitude", names(Extracted_Data))
names(Extracted_Data)<-gsub("^t", "Time", names(Extracted_Data))
names(Extracted_Data)<-gsub("^f", "Frequency", names(Extracted_Data))
names(Extracted_Data)<-gsub("tBody", "TimeBody", names(Extracted_Data))
names(Extracted_Data)<-gsub("-mean()", "Mean", names(Extracted_Data), ignore.case = TRUE)
names(Extracted_Data)<-gsub("-std()", "STD", names(Extracted_Data), ignore.case = TRUE)
names(Extracted_Data)<-gsub("-freq()", "Frequency", names(Extracted_Data), ignore.case = TRUE)
names(Extracted_Data)<-gsub("angle", "Angle", names(Extracted_Data))
names(Extracted_Data)<-gsub("gravity", "Gravity", names(Extracted_Data))

##From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
Tidydataset <- Extracted_Data %>% group_by(Activity, Subject) %>% summarize_all(funs(mean)) 

write.table(Tidydataset, file = "./Tidydataset.txt", row.names = FALSE, col.names = TRUE)

             