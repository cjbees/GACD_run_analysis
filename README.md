# GACD_run_analysis
Course project for Coursera GACD

- Information about the data is available in CodeBook.md
- Information about where to download the data from, and how to load it into R, is included in the first section of run_analysis.R
- Step-by-step explanations are included in comments in run_analysis.R. The basic strategy was to combine test and train datasets, identify subjects and activities, aggregate date by subject and activity into means for each variable collected, and export a text file of those means.

- The output of run_analysis.R is a text file called "TidyData.txt" which contains the average, by participant & activity, for each of the variables collected by the device.
