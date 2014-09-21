##Set working directory and make sure files exist
getwd()
setwd("C:/Users/knobbe/Documents/PTO, Time Sheets, etc/Coursera/Data Science Specialization/3. Data Cleaning/UCI HAR Dataset")
list.files(getwd())

###########################################
##Start data pull
activity <- read.csv("activity_labels.txt",header=F,sep=" ",stringsAsFactors=F)
str(activity)

train <- read.csv("train/subject_train.txt",header=F)
##link the activity code with the activity name
train <- cbind(train,merge(read.csv("train/y_train.txt",header=F),activity,by="V1"))
train <- cbind(train,read.csv("train/x_train.txt",header=F,sep=""))
str(train)

test <- read.csv("test/subject_test.txt",header=F)
##link the activity code with the activity name
test <- cbind(test,merge(read.csv("test/y_test.txt",header=F),activity,by="V1"))
test <- cbind(test,read.csv("test/x_test.txt",header=F,sep=""))
str(test)
#end data pull
#####################################################

##combine test and train data
data <- rbind(train,test)
str(data)

##pull in features of data, and then rename column headings accordingly
features <- read.csv("features.txt",header=F,sep="",stringsAsFactors=F)
colnames(data) <- c("SubjectID","ActivityID","Activity",features$V2)
str(data)

##determine columns that are a mean or std dev
meanstdcol <- grep("*-mean()*|*-std()*",features[,2],value=T)

##create new data with only the columns determined above
data2 <- data[,c("SubjectID","ActivityID","Activity",meanstdcol)]
str(data2)

##create tidy data
##mean of metric columns summarized by subject and activity
tidydata <- aggregate(data2[,4:82],by=data2[,1:3],FUN="mean")
str(tidydata)

write.table(tidydata,"tidydata.txt",row.names=F)
