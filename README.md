#Description of the procedures for data preparing stored in run_analysis.R file

##MERGING TRAIN AND TEST DATASETS
The product of this section is one dataset containing all raw measurement variables, subject variable, activity variable and all observations from train and test subsets. This section is split into three subsections:
###Reading data into R
Using *read.table* funcion data is loaded into R. The data is loaded into six variables:

      * trainX \- stores all original variables from the measurements from train dataset
      * trainY \- stores all activities (labels) from train dataset
      * trainS \- stores all subject ids from train dataset
      * testX \- stores all original variables from the measurements from test dataset
      * testY \- stores all activities (labels) from test dataset
      * testS \- stores all subject ids from test dataset      

###Merging data by column
Using *cbind* function subject and activity columns are added to the measurement dataset. The function is used for train set and test set separately. The results are stored in *train* and *test* variables respectively.

###Merging data by row
Using *rbind* function train set and test set are merged. The result is stored in *UCI_HAR_Dataset*.


## FITERING ALL VARIABLES EXCEPT MEANS AND STANDARD DEVIATIONS
Product of this section is a dataset with reduced number of dimentions. Of course Subject and Activity variables are kept. Apart from them all variables containing mean signals and standard deviations of the signals are kept. This section is split into three subsections:

###Reading feature names from file
Using *read.table* function feature names are loaded into R. The feature names are stored in the *features* variable.

###Assigning column names
To the feature names *Subject* and *Activity* are added. The full vector of feature names is assigned to column names of the *UCI_HAR_Dataset* data.frame.

###Selecting variables
Using *grep* function all variables containing *mean\(\)* and *std\(\)* as well as *Subject* and *Activity* variables are selected. If the parenthesis were skipped also the variables averaged on window samples would be included in the dataset and we want to avoid that.

##INSERTING DESCRIPTIVE ACTIVITY NAMES
The product of this section is a datset with strig activity labels. The data produced in the previous sections had the Activity variable coded with numbers from 1 to 6. In this section it is decoded to six activities: LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS. This section is split into two subsections:

###Reading activity labels from file
Using *read.table* function map of activity labels is loaded into R. The activity labels map is stored in *activity_labels* data.frame. The first column V1 contains number codes of the actvity and the second column V2 contains the activity names.

###Assigning Activity descriptions to Activity column in the dataset
Using combination of *sapply* and *which* functions for each observation in the dataset the activity number code is mapped to the activity name and the name is set as the new value of the variable.


##INSERTING DESCRIPTIVE VARIABLE NAMES
The product of this section is the dataset with descriptive variable names explaining adequatly what is the signal in the variable.
Using combination of *grep* function and regular expressions informative variable names with certain patterns coded are identified. Basing on the identified patterns using *sapply* descriptive strings decoding the pattern from original names are stored in *newnames* vector. The combination of *grep* and *sapply* is used multiple times to decode different types of information from the original variables. So created *newnames* vector is assigned as column names vector of the data set. \(In case of axis loop *for* is used in stead of *sapply* function.\) The patterns to be decoded are: statistic type, magnitude, jerk, acceleration type, sensor type, axis and domain.

##CALCULATING MEANS PER SUBJECT PER ACTIVITY
The product of this section is a new clean dataset containing means calculated for each signal variable from the previous dateset calculated by subject and activity. The section is split into three subsections:

###Converting dataset to data.table
Using *data.table* the data is converted to data.table type. The result is stored in *dtdataset* variable.


###Calculating means
Using *data.table* properties means of all variables by Subject and Activity are calculated. The result is stored in *aggdata*.

###Writing clean data to a text file
Using *write.table* function the *aggdata* is saved to a .txt file.





