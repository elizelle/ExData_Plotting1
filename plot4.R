##unzip zip file and assign fname to txt file
unzip("exdata-data-household_power_consumption.zip")
fname <- "household_power_consumption.txt"  

##I couldn't figure out how to read the data based on the dates, so I first read only the first 10 rows (I did not include that code here)
##Once I knew the start date and time, I calculated that the data for 2/1/2007 started on row 66637
##And that two days of data would be 2880 rows (60 minutes * 24 hours)
##read 2880 rows of data, skipping the first 66636 rows
dat <- read.table(fname, sep = ";", skip = 66636, nrows = 2880, na.strings="?", stringsAsFactors = FALSE)
##rename columns (skipping )
colnames(dat) <- c("Date", "Time", "Global_active_power", "Global_reactive_power",
                   "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
##replace Time column with merged Date and Time columns
dat$Time <- paste(dat$Date, dat$Time, sep = ":")
##Format Date column as a date
dat[, 1] <- as.Date(dat[, 1], format = "%d/%m/%Y")
##Format Time column as a time
dat[, 2] <- as.POSIXct(strptime(dat[,2], format = "%d/%m/%Y:%H:%M:%S"))

##open PNG device & create plot4 in working directory
png(file = "plot4.png")
##set parameter of plot4 to 2x2, adding figures by row 
par(mfrow = c(2, 2))
##create the four figures
with(dat, {
  plot(Time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
  plot(Time, Voltage, type = "l", xlab = "datetime")
  plot(dat$Time, dat$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(dat$Time, dat$Sub_metering_2, col = "red")
  lines(dat$Time, dat$Sub_metering_3, col = "blue")
  legend('topright', legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, col=c('black', 'red', 'blue'), bty = "n")
  plot(Time, Global_reactive_power, type = "l", xlab = "datetime")
})
dev.off() ##close the PNG device