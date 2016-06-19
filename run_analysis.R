##STEP 1 #reading training and test data sets to create a single dataframe
x_train <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/train/X_train.txt");
x_test <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/test/X_test.txt");
y_train <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/train/y_train.txt");
y_test <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/test/y_test.txt");
subject_train <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/train/subject_train.txt");
subject_test <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/test/subject_test.txt");

##merging training and test dataframes on basis of X, Y and subject observations
merged_xdata <- rbind (x_train,x_test);
merged_ydata <- rbind (y_train,y_test);
merged_sbjct_data <- rbind (subject_train,subject_test);

#STEP2#Extracting only measurement on mean and SD for each measurement
features <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/features.txt");
## using concoction of grep and regular expressions to extract observations with string
## mean and std
mean_std_features <- grep("-(mean|std)\\(\\)", features$V2);
## subsetting the rows from merged_xdata
merged_xdata <- merged_xdata[, mean_std_features];
## correct the column names
names(merged_xdata) <- features[mean_std_features, 2];


#STEP3#Use descriptive activity names to name the activities in the data set
activities <- read.table("C:/Users/seescircle/Desktop/Swirl/Swirl/data/activity_labels.txt")
##update values with correct activity names
merged_ydata$V1 <- activities[merged_ydata[, 1], 2]
## correctly naming the columns of merged_ydata
names(merged_ydata) <- "activity";


#STEP4#Appropriately labels the data set with descriptive variable names.
names(merged_sbjct_data) <- "subject";
##bind all the data in a single dataset
tidy_set <- cbind(merged_xdata,merged_ydata,merged_sbjct_data);


#STEP5# Create a second, independent tidy data set with the average of each variable
## for each activity and each subject
averaged_data <- ddply(tidy_set, .(subject, activity), function(x) colMeans(x[, 1:66]));
write.table(averaged_data, "averagedftns_data.txt", row.name=FALSE)