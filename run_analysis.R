#------ Loading libraries
library(reshape2)
library(data.table)

#------ Reading data
root <- ".\\COURSERA\\3. Getting and Cleaning Data\\Week 4\\Projeto Final\\UCI HAR Dataset\\"
test <- ".\\COURSERA\\3. Getting and Cleaning Data\\Week 4\\Projeto Final\\UCI HAR Dataset\\test\\"
train <- ".\\COURSERA\\3. Getting and Cleaning Data\\Week 4\\Projeto Final\\UCI HAR Dataset\\train\\"

# Root
activity_labels <- read.table(paste0(root,"activity_labels.txt"))
features <- read.table(paste0(root,"features.txt")); rm(root)

# Test
subject_test <- read.table(paste0(test,"subject_test.txt"))
X_test <- read.table(paste0(test,"X_test.txt"))
y_test <- read.table(paste0(test,"y_test.txt")); rm(test)

# Train
subject_train <- read.table(paste0(train,"subject_train.txt"))
X_train <- read.table(paste0(train,"X_train.txt"))
y_train <- read.table(paste0(train,"y_train.txt")); rm(train)

#------ Stacking
id <- rbind(subject_train, subject_test); rm(subject_train, subject_test)
activity <- rbind(y_train, y_test); rm(y_train, y_test)
data <- rbind(X_train, X_test); rm(X_train, X_test)

#------ Naming the columns
colnames(data) <- features[,2]; rm(features)
colnames(id) <- "id"
colnames(activity) <- "activity"

#------ Joining the data
new_data <- cbind(id,activity,data); rm(id,activity,data)
new_data$activity <- as.factor(new_data$activity)

#------ Factor labels
levels(new_data$activity) <- activity_labels[,2]; rm(activity_labels)

#------ Finding columns with mean() and std()
means <- grep("mean()",names(new_data))
dev <- grep("std()",names(new_data))

cols <- c(means,dev); rm(means,dev)

new_data <- new_data[,c(1,2,cols)]; rm(cols)

#------ Average of each variable for each activity and each subject
melt_data <- melt(new_data, id=c("id","activity"), measure.vars = names(new_data)[-c(1,2)])
tidy_data <- dcast(melt_data, id+activity~variable, mean)

#------ Saving tidy data
write.table(tidy_data, "tidy_data.txt")
