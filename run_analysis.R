######################
# run_analysis will merge both test and train data set into one dataframe. Once 
# combine, it will remove columns that does not have either 'mean' or 'std' 
# in their column name.  It will combine with the activity label along with the subject
# that perform the test/train data. 
#
# The final data set will take the mean for each subject of activity resulting in
# a tidy data set with 180 observation with 79 variables.
#
# Assumption: The working directory contains test and train direcotry along with
#             activity_labels.txt, features.txt, etc.
#
# Author: Danny Tran
# Date: 2/22/15
######################

## Load all subject file and then combine by rows
subject_test  <-  read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
subject_train  <-  read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
subject_combo <- rbind(subject_test,subject_train)
colnames(subject_combo) <- "Subject"

## Load all y files and combine them by rows
ytest  <-  read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE) 
ytrain  <-  read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
y_merge <- rbind(ytest,ytrain)
colnames(y_merge) <- "Activity"

## Load all x files and combine them by rows
xtest  <-  read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE) 
xtrain  <-  read.table("./UCI HAR Dataset/train/x_train.txt", stringsAsFactors = FALSE)
x_merge <- rbind(xtest,xtrain)

## Load the column name file and assign the name of each column to the data set
col_name = read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE) 
colnames(x_merge) <- col_name[,2]

## Strip only columns with either 'mean' or 'std' and column bind them to merge_data df
merge_data <- x_merge[,grep("mean|std",names(x_merge))]
merge_data <- cbind(y_merge,subject_combo,merge_data)

## Change Activity column to a character and assign respective activity name
merge_data$Activity <- as.character(merge_data$Activity)
merge_data$Activity[merge_data$Activity %in% "1"] <- "WALKING"
merge_data$Activity[merge_data$Activity %in% "2"] <- "WALKING_UPSTAIRS"
merge_data$Activity[merge_data$Activity %in% "3"] <- "WALKING_DOWNSTAIRS"
merge_data$Activity[merge_data$Activity %in% "4"] <- "SITTING"
merge_data$Activity[merge_data$Activity %in% "5"] <- "STANDING"
merge_data$Activity[merge_data$Activity %in% "6"] <- "LAYING"

## Final data set providing mean for each subject along with the activity the subject performed
tidy_data <- merge_data %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))

