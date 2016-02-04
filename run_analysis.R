library(data.table)
#read X_test.txt file

x<-read.table("./test/X_test.txt")

#change the column names of X_test.txt data frame
names(x)<-read.table("features.txt")[,2]

#read y_test.txt 
y<-read.table("./test/y_test.txt")
#change its column name
names(y)<-"activity_lables"
#read subject_test
z<-read.table("./test/subject_test.txt")
#change its name
names(z)<-"volunteer"

#bind x,y,z to form test data frame
test<-cbind(x,y,z)

#Repeat above steps to create train data frame
x_train <-read.table("./train/X_train.txt")

names(x_train) <- read.table("features.txt")[,2]

y_train <- read.table("./train/y_train.txt")

names(y_train)<-"activity_lables"

z_train <- read.table("./train/subject_train.txt")

names(z_train)<-"volunteer"

train<-cbind(x_train,y_train,z_train)

#merge test and train data frame.
merged_data <- rbind(test,train)

#Extracts only the measurements on the mean and standard deviation for each measurement
req_col<-grepl("mean|std",names(merged_data))
req_col[562:563]<-c(TRUE,TRUE)

req_data<-as.data.table(merged_data[ ,req_col])

#Uses descriptive activity names to name the activities in the data set
req_data$activity_lables[req_data$activity_lables==1]<-"Walking"
req_data$activity_lables[req_data$activity_lables==2]<-"Walking Upstairs"
req_data$activity_lables[req_data$activity_lables==3]<-"Walking Downstairs"
req_data$activity_lables[req_data$activity_lables==4]<-"Sitting"
req_data$activity_lables[req_data$activity_lables==5]<-"Standing"
req_data$activity_lables[req_data$activity_lables==6]<-"Laying"

#Appropriately labels the data set with descriptive variable names.
names(req_data) <- gsub("Acc", "Accelerator", names(req_data))
names(req_data) <- gsub("Mag", "Magnitude", names(req_data))

tidy_data <- req_data[,lapply(.SD,mean),.(volunteer,activity_lables)]

# write data to text file
write.table(tidy_data,row.name=FALSE, file = "./tidy_data.txt")


