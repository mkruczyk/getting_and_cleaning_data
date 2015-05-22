### MERGING TRAIN AND TEST DATASETS ###
#Set working directory
setwd("./Data_cleaning/UCI HAR Dataset")

#Reading data to R
trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/Y_train.txt")
trainS <- read.table("./train/subject_train.txt")
testX <- read.table("./test/X_test.txt")
testY <- read.table("./test/Y_test.txt")
testS <- read.table("./test/subject_test.txt")

#Checking if dimentions match in train dataset
dim(trainX)
dim(trainS)
dim(trainY)


#Merging data by column
#Merging variables, subject id and activity of train dataset into one table
train <- cbind(trainX, trainS, trainY)
dim(train)

#Checking if dimentions match in test dataset
dim(testX)
dim(testS)
dim(testY)

#Merging variables subjcet id and activity of test dataset into one table
test <- cbind(testX, testS, testY)
dim(test)

#Merging data by row
#Merging train and test dataset
UCI_HAR_Dataset <- rbind(train, test)
dim(UCI_HAR_Dataset)




### FITERING ALL VARIABLES EXCEPT MEANS AND STANDARD DEVIATIONS ###
#Reading feature names from file
features <- read.table("./features.txt")
dim(features)
head(features)

#Assigning column names of the dataset to the features read from file. 
#"Activity" must be added because beafore we added lable values as the last column in the table
colnames(UCI_HAR_Dataset) <- c(as.character(features$V2), "Subject", "Activity")

#Selecting only the variables with 'mean()' and 'std()' in the name.
#The brackets are needed to avoind including variables with the word 'mean' or 'std' in the name 
#but have nothing to do with the estimate of mean on the variables
#Example of the excluded components are:
#meanFreq() which refers to weighted average of the frequency components to obtain a mean frequency
#gravityMean obtained by averaging the signals in a signal window sample

mycols <- grep("mean\\(\\)|std\\(\\)|^Subject$|^Activity$", colnames(UCI_HAR_Dataset))
head(UCI_HAR_Dataset[, mycols])
mydataset <- UCI_HAR_Dataset[, mycols]

#INSERTING DESCRIPTIVE ACTIVITY NAMES
#Reading activity names from file
activity_labels <- read.table("./activity_labels.txt")


#Assigning Activity descriptions to Activity column in the dataset
mydataset$Activity <- sapply(mydataset$Activity, function(x){activity_labels$V2[which(activity_labels$V1 == x)]})
head(mydataset)


#INSERTING DESCRIPTIVE VARIABLE NAMES
#Decoding statistic type
newnames <- c(rep("", ncol(mydataset) - 2), "Subject", "Activity")
index <- grep("mean\\(\\)", colnames(mydataset))
newnames[index] <- rep("Mean of ", length(index))
index <- grep("std\\(\\)", colnames(mydataset))
newnames[index] <- rep("Standard deviation of ", length(index))
#Decoding magnitude
index <- grep("Mag", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "the magnitude of ", sep="")
#Decoding jerk
index <- grep("Jerk", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "the jerk of ", sep="")
#Decoding acceleration type
index <- grep("Body", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "the body ", sep="")
index <- grep("Gravity", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "the gravity ", sep="")
index <- grep("Acc", colnames(mydataset))
#Decoding sensor type
newnames[index] <- sapply(newnames[index], paste, "acceleration signal ", sep="")
index <- grep("Gyro", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "gyroscope signal ", sep="")
#Decoding axis
index <- grep("-[XYZ]", colnames(mydataset))
for(i in index){
      name <- colnames(mydataset)[i]
      last <- nchar(name)
      newnames[i] <- paste(newnames[i], "on ", substr(name, last, last) , " axis ", sep="")
}
#Decoding domain
index <- grep("^t", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "in the time domain.", sep="")
index <- grep("^f", colnames(mydataset))
newnames[index] <- sapply(newnames[index], paste, "in the frequency domain.", sep="")
colnames(mydataset) <- newnames




#CALCULATING MEANS PER SUBJECT PER ACTIVITY
library(data.table)
#Converting dataset to data.table
dtdataset <- data.table(cbind(Subject = mydataset$Subject, Activity = mydataset$Activity, mydataset[, -c(ncol(mydataset) - 1, ncol(mydataset))]))

#Calculating means
aggdata <- data.frame(dtdataset[, lapply(.SD, mean), by=list(Subject, Activity)])
colnames(aggdata) <- colnames(dtdataset)
aggdata <- aggdata[with(aggdata, order(Subject, Activity)), ]

#Writing clean data to a text file
write.table(aggdata, "./../means_of_variables.txt", row.name=FALSE)





