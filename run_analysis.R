srcUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(srcUrl, destfile = "sourceData.zip")
unzip("sourceData.zip")

strain <- read.table("UCI HAR Dataset/train/subject_train.txt")
stest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features$V2 <- as.character(features$V2)

# 1. Merges the training and the test sets to create one data set.
    xdataset <- rbind(xtrain, xtest)

# 2. Extracts only the measurements on the mean and standard deviation
#       for each measurement. 
    xsubdataset <- xdataset[, grep("mean\\(\\)|std\\(\\)", features$V2)]

# 3. Uses descriptive activity names to name the activities in the data
#       set
    xsubdataset$Activity.Name <- activity_labels$V2[rbind(ytrain, ytest)[, "V1"]]

# 4. Appropriately labels the data set with descriptive variable names. 
    names(xsubdataset)[-67] <- grep("mean\\(\\)|std\\(\\)", features$V2, value=TRUE)

# 5. From the data set in step 4, creates a second, independent tidy
#       data set with the average of each variable for each activity
#       and each subject.
    xsplit <- split(xsubdataset[-67], cbind(rbind(strain, stest), xsubdataset$Activity.Name))
    tidydataset <- as.data.frame(t(sapply(xsplit, colMeans)))

    #subj_actnm <- unlist(strsplit(names(xsplit), ".", fixed=TRUE))
    #tidydataset$Subject <- as.numeric(subj_actnm[seq(from=1, by=2, length.out=180)])
    #tidydataset$Activity.Name <- subj_actnm[seq(from=2, by=2, length.out=180)]

    write.table(tidydataset, file="tidydataset.txt", row.name=FALSE)
