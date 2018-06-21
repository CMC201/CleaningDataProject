README

OVERVIEW

The run_analysis.R script will take the raw data from the UCI HAR accelerometer dataset and reduce it down to tidy data, ultimately producing a single data table ("accelerometer_data_summarized.txt") containing average accelerometer measurements for six different activities performed by 30 different subjects in the experiment.

NOTES

The run_analysis.R script must be run from the top level directory containing the entire accelerometer dataset (i.e. ~/UCI HAR Dataset/)
Ensure that the data.table, dplyr, and plyr packages are all installed in order to properly run the analysis.

IMPORTING FILES AND SETTING UP THE DATA TABLE

We begin by importing the necessary data files into R
We now append the row labels and subject IDs for both the training and test sets
Finally, we combine the test and training sets into one large data table
And clean up our intermediate data

ASSIGNING APPROPRIATE COLUMN NAMES

We manually label the subject ID and activity columns
And import the rest of the column names from the features file
Now we assign the column names
Clean up intermediate objects

EXTRACTING MEAN AND STD INFO

First we define our selection criteria, selecting only measurements with names containing "mean()" or "std()"
Now we actually perform the selection on the data.
Again, we clean up our intermediate objects.

ASSIGNING ACTIVITY LABELS

We need to replace the activity IDs with character strings describing each activity.
First we extract a lookup table matching IDs with activity names (from the supplied activity list file).
Do some name assignment to match the column names in the main file and lookup table.
Now we append a column with the appropriate activity names using a merge.
And rearrange our data to put this column in the appropriate place.
Clean up the variable names a bit, removing the ending parentheses. 
Further simplification of the variable names could lead to a loss of information/difficulty relating these variables back to the raw data, so we will stop here.
Again, we remove intermediate objects to clean up the workspace a bit.

GENERATE A NEW TIDY DATA SET WITH AVERAGES

We need to group the data so that we have one row of observations for each subject-activity pair. We'll group first by activity, then by subject.
We will average all observations for each subject-activity pair to reduce the data.
Finally, clean up the workspace to contain only our final output.
And output our final data.
