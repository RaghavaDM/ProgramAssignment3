# ProgramAssignment3

Did not consider files in inertial signals
Function mergeWithOrder is created to join test and train file
SequenceIds are used to preserve order merge changes the row order when joining with other data sets
train and test are joined with rbind.data.frame
return value of this function is with test data appened with train data

read all input files
xcomplete,ycomplete,subjcomplete are merged file
activty file and feature file is read into variables activity and features respectively

added columnnames for all data sets

identified column names mean and standard deviation using gsub function
requiredcol variable is created for Subject,activity and required columns


ycompleteDesc is created joining y and activity data sets - left join
xycomplete is created joining ycompleteDesc and x data sets - Inner join
xysubjcomplete is created joining xycomplete and subjcomplete data sets - Inner join

xyrequired is required columns from xysubjcomplete

using group_by and summarise_each, mean of each variable by each activity and subject is calculated







