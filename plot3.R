library(dplyr)

# if data are not present already, download and unzip data
if (!file.exists("household_power_consumption.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "household_power_consumption.zip")
    unzip(zipfile = "household_power_consumption.zip")
}

# read data and select relevant date

pow_cons_raw <- read.csv("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings = "?")
pow_cons_raw <- tbl_df(pow_cons_raw)
pow_cons_raw$Date <- as.Date(pow_cons_raw$Date, format = "%d/%m/%Y")
pow_cons <- filter(pow_cons_raw, Date == ("2007-02-01") | Date == ("2007-02-02"))

# create date_time vector, remove date and time variable from data frame and add date_time

date_time <- paste(pow_cons$Date, pow_cons$Time)
date_time <- as.POSIXct(strptime(date_time, format = "%Y-%m-%d %H:%M:%S"))
pow_cons <- mutate(pow_cons[,-(1:2)],"datetime" = date_time)

# Set sys locale for english labels in plot

Sys.setlocale("LC_TIME", "C")

# Plot 3

png("plot3.png", width = 480, height = 480)
with(pow_cons, plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(pow_cons, points(datetime, Sub_metering_2, type = "l", col = "red"))
with(pow_cons, points(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = rep(1,3), col = c("black", "red", "blue"))
dev.off()
