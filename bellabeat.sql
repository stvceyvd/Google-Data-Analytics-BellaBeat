##### Google Data Analytics Certificate Case Study - Bellabeat - Data Cleaning/Analysis #####

### Data Cleaning with Excel

### Across all four tables 
  # Checked for any blank cells
  # Checked for any duplicates, removed 3 rows from sleepDay table 
  # Find min/max date for all data. 
    # StartDate: 2016-04-12, endDate: 2016-05-1
  # Identify standard character length for user ID (10) and verified uniformity using the length function (LEN). 
;

### dailyActivity_merged 
  # Removed rows with TotalSteps = 0 (Records show that participants with zero total steps also have 24 hours of sedentary activity, reflecting days that participants did not use their Fitbit, which can be misleading.
;
                                           
### sleepDay_merged
  # Subtracted column "TotalMinutesAsleep" from "TotalTimeinBed" and created a new column, "TimeToFallAsleep."
  # Remove column "SleepRecords."
;

### hourlySteps_merged
  # Changed "ActivityHour" into two separate columns, "ActivityDate" and "ActivityHour" using the text to columns function. 
  # Reformatted data in "ActivityHour" to HH:MM XM from HH:MM:SS XM.
  # Reformatted data in "ActivityDate" to MM/DD/YY (short date).                                        
 ;
                                           
### hourlyIntensities_merged 
  # Changed "ActivityHour" into two separate columns, "ActivityDate" and "ActivityHour" using the text to columns function. 
  # Reformatted data in "ActivityHour" to HH:MM XM from HH:MM:SS XM.
  # Reformatted data in "ActivityDate" to MM/DD/YY (short date). 
;
                                           
### Uploaded all four tables onto Google Cloud's BigQuery SQL console to continue any further cleaning and begin the data analysis. 
                                           
# Selecting distinct user IDs to find how many participants are in the survery
SELECT DISTINCT Id
FROM `cedar-amulet-326100.bellabeat.HourlyIntensities`
# Returns 33 unique IDs
;
                                           
# Selecting distinct user IDs to find how many participants are in the survery                                          
SELECT DISTINCT Id
FROM `cedar-amulet-326100.bellabeat.dailyActivity`
# Returns 33 unique IDs
;
                                           
# Selecting distinct user IDs to find how many participants are in the survery   
SELECT DISTINCT Id
`cedar-amulet-326100.bellabeat.sleepDay`
# Returns 24 unique IDs
;
                                           
# Doubling-checking if there any duplicates in the table SleepDay
SELECT *, COUNT(*) as number_of_rows
FROM cedar-amulet-326100.bellabeat.sleepDay
GROUP BY Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeinBed 
HAVING number_of_rows >1  
# Returns no duplicates 
;
                                           
# Double-checking if there any duplicates in the table dailyActivity
SELECT *, COUNT(*) as number_of_rows
FROM `cedar-amulet-326100.bellabeat.dailyActivity` 
GROUP BY Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories
HAVING number_of_rows > 1
# Returns no duplicates 
;
                                           
# Checking if there are any zero calories days 
SELECT Id, COUNT(*) as zeroCals
FROM  `cedar-amulet-326100.bellabeat.dailyActivity`
WHERE Calories = 0
group by Id, ActivityDate, Calories
ORDER BY zeroCals desc
## Returns no zero calorie days
;
                                           
# Double-checking if there are any zero total steps days 
SELECT Id, COUNT(*) as zeroSteps
FROM  `cedar-amulet-326100.bellabeat.dailyActivity`
WHERE TotalSteps = 0
group by Id, ActivityDate, TotalSteps 
## Returns no zero total step days 
;
                                           
### Analyze Data 

# Looking at average steps, average distance, and average calories per day of the week (filtering out zero-step day logs). 
SELECT EXTRACT(dayofweek from ActivityDate) as DayofWeek, AVG(TotalSteps) as AverageSteps, AVG(TotalDistance) as AverageDistance, AVG(Calories) as AverageCalories
FROM `cedar-amulet-326100.bellabeat.dailyActivity`
WHERE TotalSteps > 0
GROUP BY DayOfWeek
ORDER BY AverageSteps DESC
## Tuesday has the highest average step count and highest average distance.                                            
;
                                           
# Looking at average amount of hours asleep, average amount of hours in bed, and average amount of minutes to fall asleep per day of the week. 
SELECT EXTRACT(dayofweek from SleepDay) as DayofWeek, AVG(TotalMinutesAsleep/60) AS AverageHoursAsleep, AVG(TotalTimeInBed/60) as AverageHoursInBed, AVG(TotalTimeInBed-TotalMinutesAsleep) as AverageTimetoFallAsleep
FROM `cedar-amulet-326100.bellabeat.sleepDay`
GROUP BY DayofWeek
ORDER BY AverageHoursAsleep DESC
## Sunday has the highest average of sleep hours (7.5).                                          
;
                                           
# Looking at average amount of steps taken per hour of the day. 
SELECT ActivityHour, AVG(StepTotal) as AverageStepTotal
FROM `cedar-amulet-326100.bellabeat.HourlySteps`
GROUP BY ActivityHour
ORDER BY AverageStepTotal DESC 
## Highest average amount of steps taken is during 6-7 PM.                           
;                                           
                                           
# Left joining tables dailyActivity_merged and sleepDay_merged
SELECT *
FROM cedar-amulet-326100.bellabeat.dailyActivity as d
LEFT JOIN  cedar-amulet-326100.bellabeat.sleepDay as s
ON d.ActivityDate = s.sleepDay AND d.Id = s.Id
ORDER BY d.Id
;
                                          
# Looking at many users overlap in each of the table. 
SELECT COUNT (DISTINCT d.Id) as activityId, COUNT (DISTINCT s.Id) as sleepId, COUNT (DISTINCT h.Id)
FROM cedar-amulet-326100.bellabeat.dailyActivity as d
JOIN  cedar-amulet-326100.bellabeat.sleepDay as s
ON d.Id = s.Id
JOIN cedar-amulet-326100.bellabeat.HourlySteps as h
ON s.Id = h.Id 
;                                           

# Examining how many users are lacking logs across all three tables 
SELECT DISTINCT d.Id as activityId, s.Id as sleepId, h.Id as hourlyId
FROM cedar-amulet-326100.bellabeat.dailyActivity as d
FULL JOIN  cedar-amulet-326100.bellabeat.sleepDay as s
ON d.Id = s.Id
FULL JOIN cedar-amulet-326100.bellabeat.HourlySteps as h
ON s.Id = h.Id                                          
;
                                           
# Looking at unique IDs from the dailyActivity table that do not have logs in either sleepDay or hourlyIntensities table, or both. 
SELECT DISTINCT Id
FROM `cedar-amulet-326100.bellabeat.dailyActivity`
WHERE ID not in (
  SELECT d.Id 
  FROM `cedar-amulet-326100.bellabeat.dailyActivity` as d
  JOIN  `cedar-amulet-326100.bellabeat.sleepDay` as s 
  ON d.Id = s.Id 
  JOIN `cedar-amulet-326100.bellabeat.hourlyIntensities` as h
  On s.Id = h.Id
)
;

# Looking at how many unique IDs from the dailyActivity table that do not have logs in either sleepDay or hourlyIntensities table, or both.
SELECT COUNT (DISTINCT Id)
FROM `cedar-amulet-326100.bellabeat.dailyActivity`
WHERE ID not in (
  SELECT d.Id 
  FROM `cedar-amulet-326100.bellabeat.dailyActivity` as d
  JOIN  `cedar-amulet-326100.bellabeat.sleepDay` as s 
  ON d.Id = s.Id 
  JOIN `cedar-amulet-326100.bellabeat.hourlyIntensities` as h
  On s.Id = h.Id
)
## 9 participants from the dailyActivity table do not have logs in sleepDay or hourlyIntensities table, or both.
;

# Finding the average percentage of time users spent performing very active level of activity.
SELECT AVG(VeryActiveMinutes/(VeryActiveMinutes+FairlyActiveMinutes+ LightlyActiveMinutes+SedentaryMinutes)) * 100
FROM `cedar-amulet-326100.bellabeat.dailyActivity`
## On average, 1.99%, or 2% of the day is spent performing very active level of activity.
; 

# Finding the average percentage of time users spent in sendentary behavior. 
SELECT AVG(SedentaryMinutes/(VeryActiveMinutes+FairlyActiveMinutes+ LightlyActiveMinutes+SedentaryMinutes)) * 100
FROM `cedar-amulet-326100.bellabeat.dailyActivity`
## on average, 78.2% of the day is spent in sedentary behavior. 
; 

# Looking at how many TotalSteps records is greater than or equal to the CDC's recommendation of 10,000 steps/day
SELECT COUNT (TotalSteps)
from `cedar-amulet-326100.bellabeat.dailyActivity`
WHERE TotalSteps >= 10000                                          
## Returns 303 rows, or about 35% 



