##IMPORTING FILES AND SETTING UP THE DATA TABLE
#We begin by importing the necessary data files into R
library(data.table)
X_test<-read.table('./test/X_test.txt')
X_train<-read.table('./train/X_train.txt')
Y_train<-read.table('./train/y_train.txt')
Y_test<-read.table('./test/y_test.txt')
subject_test<-read.table('./test/subject_test.txt')
subject_train<-read.table('./train/subject_train.txt')
#We now append the row labels and subject IDs for both the training and test sets
test_init<-cbind(Y_test,X_test)
train_init<-cbind(Y_train,X_train)
test_full<-cbind(subject_test,test_init)
train_full<-cbind(subject_train,train_init)
#Finally, we combine the test and training sets into one large data table
full_set<-rbind(test_full,train_full)
#And clean up our intermediate data
rm(X_train,X_test,Y_train,Y_test,test_full,train_full,test_init,train_init)
rm(subject_test,subject_train)

##Assigning appropriate column names
#We manually label the subject ID and activity columns
colnames(full_set)[1]<-"SubjectID"
colnames(full_set)[2]<-"Activity"
#And import the rest of the column names from the features file
measurement_labels<-read.table('features.txt')
names<-as.character(measurement_labels$V2)
#Now we assign the column names
colnames(full_set)[3:563]<-c(names)
#Clean up intermediate objects
rm(measurement_labels,names)

##Extracting mean and std info
#First we define our selection criteria, selecting only measurements with names containing "mean()" or "std()"
wantedcols<-c("SubjectID","Activity",grep("mean()",names(full_set),value=TRUE,fixed=TRUE),grep("std()",names(full_set),value=TRUE,fixed=TRUE))
#Now we actually perform the selection on the data
extracted<-subset(full_set,select=wantedcols)
#Clean up our intermediate objects
rm(wantedcols)

##Assigning activity labels
#We need to replace the activity IDs with character strings describing each activity
#First we extract a lookup table matching IDs with activity names
activity_labels<-read.table('activity_labels.txt')
#Do some name assignment to ensure our replacement goes smoothly
colnames(activity_labels)<-c("ActivityID","ActivityName")
colnames(extracted)[2]<-"ActivityID"
#Now we append a column with the appropriate activity names using a merge
withnames<-merge(extracted,activity_labels,by="ActivityID",all.x=TRUE)
#And rearrange our data to put this column in the appropriate place
withnames<-withnames[,c(2,69,3:68)]
#Clean up the variable names a bit, removing the ending parentheses
names(withnames)<-gsub("()","",names(withnames),fixed=TRUE)
#Clean up the workspace a bit
rm(activity_labels,extracted,full_set)

##Generate a new tidy data set with averages
#We need to group the data so that we have one row of observations for each subject-activity pair
library(dplyr)
grouped_subjactiv<-group_by(withnames,SubjectID,ActivityName)
#We will average all observations for each subject-activity pair to reduce the data
summarized<-summarize_all(grouped_subjactiv,mean)
#Finally, clean up the workspace to contain only our final output
rm(grouped_subjactiv,withnames)
#And output our final data
write.table(summarized,'accelerometer_data_summarized.txt',row.names=FALSE)