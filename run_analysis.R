library(dplyr)
library(plyr)

### A function for merging test and train files
### SeqIds are added to both files to preserve the order for joining later
mergeWithOrder <- function(testfile,trainfile) {
  testdata <- read.table(testfile)
  testdataseq <- 1:nrow(testdata)
  testdata$seqId <- testdataseq
  traindata <- read.table(trainfile)
  traindataseq <- seq(nrow(testdata)+1,nrow(testdata)+nrow(traindata),1)
  traindata$seqId <- traindataseq
  completedata <- rbind.data.frame(testdata,traindata)
  return(completedata)
  rm(traindata)
  rm(testdata)
}

##filedir <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/"

### merging y_train and y_test
ycomplete<-mergeWithOrder("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt","./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

### merging X_train and X_test
xcomplete<-mergeWithOrder("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt","./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")

### merging subject_test and subject_train
subjcomplete<-mergeWithOrder("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt","./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

### read activity file
activity<- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

### read features file
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

### adding column names for y set
names(ycomplete)[1]<-"activityCd"
names(ycomplete)[2]<-"yseqId"

## adding column names for x set after reading column names for features file
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
names(xcomplete) <- features[,2]
names(xcomplete)[ncol(xcomplete)] <- "xseqId"

### adding column names for activity
names(activity) <- c("activityCd","activityDesc")

### adding column names for subject
names(subjcomplete)[1]<-"subject"
names(subjcomplete)[2]<-"subjseqId"

### identifying mean and standard columns
meancol <- grep("mean",features[,2],ignore.case=TRUE,value=TRUE)
stdcol <- grep("std",features[,2],ignore.case=TRUE,value=TRUE)
meanstdcol <- c(meancol,stdcol)
requiredcol <- c("subject","activityDesc",meancol,stdcol)

### merging y to acitvity to get activity desc
ycompleteDesc <- merge(x=ycomplete,y=activity,by="activityCd",x.all=TRUE)

### merging X and y & activity to get all detaails in a file
xycomplete <- merge(x=xcomplete,y=ycompleteDesc,by.x="xseqId",by.y="yseqId",x.all=FALSE)

### meging subject to previous file
xysubjcomplete <- merge(x=xycomplete,y=subjcomplete,by.x="xseqId",by.y="subjseqId",x.all=FALSE)

### extracting mean,std, subject and activity columns 
xyrequired<-xysubjcomplete[,requiredcol]

### finding mean of all mean and std variables for each subject and activity
grp <- group_by(xyrequired,subject,activityDesc)
result <- summarise_each(grp,funs(mean))
write.table(result,"Avg_variable_activity.txt",row.name=FALSE)





