##### Google Data Analytics Certificate Case Study - Bellabeat - Data Cleaning/Analysis #####

### Data Cleaning with Excel

### Across all three tables 
  # Checked for any blank cells
  # Checked for any duplicates, removed 3 rows from sleepDay table 
  # Find min/max date for all data. 
    # StartDate: 2016-04-12, endDate: 2016-05-1
  # Identify standard character length for user ID (10) and verified uniformity using the length function (LEN). 


### dailyActivity_merged 
  # Filtered out rows with TotalSteps = 0 (Records show that participants with zero total steps also have 24 hours of sedentary activity, reflecting days that participants did not use their Fitbit, which can be misleading.
  
  
### sleepDay_merged
  # Subtracted column "TotalMinutesAsleep" from "TotalTimeinBed" and created a new column, "TimeToFallAsleep."
  # Remove column "SleepRecords."
 
 
### hourlyIntensities_merged 
  # Changed "ActivityHour" into two separate columns, "ActivityDate" and "ActivityHour" using the text to columns function. 
  # Reformatted data in "ActivityHour" to HH:MM XM from HH:MM:SS XM.
  # Reformatted data in "ActivityDate" to MM/DD/YY (short date). 

### Uploaded all three tables onto Google Cloud's BigQuery SQL console to continue any further cleaning and begin data analysis. 
