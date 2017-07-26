##Load Data
library(data.table)
unzip(zipfile="activity.zip")
data <- data.table::fread(input="activity.csv")

##Summarize Data

head(data)
dim(data)
summary(data)

##Total steps per day
library(ggplot2)
Total_Steps <- data[, c(lapply(.SD, sum, na.rm = FALSE)), .SDcols = c("steps"), by = .(date)]

##Histogram of Total Steps 
ggplot(Total_Steps, aes(x = steps)) + 
         geom_histogram(col="red", 
                      fill="blue", 
                      alpha = .2, 
                      binwidth = 1000) +
         labs(title = "Daily Steps", x = "Steps", y = "Frequency")

##Mean & Median of Daily Steps
Total_Steps[, .(Mean_Steps = mean(steps, na.rm = TRUE), Median_Steps = median(steps, na.rm = TRUE))]

##Avg Daily Activity Pattern

IntervalDT <- data[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps"), by = .(interval)] 

ggplot(IntervalDT, aes(x = interval , y = steps)) + geom_line(color="blue", alpha = .2, size=1) + labs(title = "Avg. Daily Steps", x = "Interval", y = "Avg. Steps per day")


IntervalDT[steps == max(steps), .(max_interval = interval)]

##No. of Missing Rows

data[is.na(steps), .N ]

##Fill in missing values
data[is.na(steps), "steps"] <- data[, c(lapply(.SD, median, na.rm = TRUE)), .SDcols = c("steps")]

##rewrite the data table
data.table::fwrite(x = data, file = "Z:/Documents/Coursera/tidydata.csv", quote = FALSE)

##Daily Steps
Total_Steps <- data[, c(lapply(.SD, sum)), .SDcols = c("steps"), by = .(date)] 

##Mean and Median of Daily steps

Total_Steps[, .(Mean_Steps = mean(steps), Median_Steps = median(steps))]

##Histogram
ggplot(Total_Steps, aes(x = steps)) + 
  geom_histogram(col="red", 
                 fill="blue", 
                 alpha = .2, 
                 binwidth = 1000) +
  labs(title = "Daily Steps", x = "Steps", y = "Frequency")

##Weekday and Weekend

data <- data.table::fread(input = "Z:/Documents/Coursera/activity.csv")
data[, date := as.POSIXct(date, format = "%Y-%m-%d")]
data[, `Day of Week`:= weekdays(x = date)]
data[grepl(pattern = "Monday|Tuesday|Wednesday|Thursday|Friday", x = `Day of Week`), "weekday or weekend"] <- "weekday"
data[grepl(pattern = "Saturday|Sunday", x = `Day of Week`), "weekday or weekend"] <- "weekend"
data[, `weekday or weekend` := as.factor(`weekday or weekend`)]
head(data, 10)

##panelplot

data[is.na(steps), "steps"] <- data[, c(lapply(.SD, median, na.rm = TRUE)), .SDcols = c("steps")]
IntervalDT <- data[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps"), by = .(interval, `weekday or weekend`)] 

ggplot(IntervalDT , aes(x = interval , y = steps, color=`weekday or weekend`)) + geom_line() + labs(title = "Avg. Daily Steps by Weektype", x = "Interval", y = "No. of Steps") + facet_wrap(~`weekday or weekend` , ncol = 1, nrow=2)
