path_rf <- getwd()
files<-list.files(path_rf, recursive=TRUE)
activity_labels<-read.table("activity_labels.txt")

dataActivityTest  <- read.table(file.path(path_rf, "test" , "y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames[,2]

Data <- cbind(dataFeatures,dataSubject, dataActivity)

columnsToKeep <- grepl("subject|activity|mean|std", names(Data))

Data <- Data[, columnsToKeep]
Data$activity <- factor(Data$activity, levels = activity_labels[, 1], labels = activity_labels[, 2])

names(Data)<-gsub("[\\(\\)-]", "",names(Data))

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("mean","Mean", names(Data))
names(Data)<-gsub("std", "StandardDeviation", names(Data))

library(dplyr)
DataMeans <- Data %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(DataMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)

