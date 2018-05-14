##Create variable which contains the data URL
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

##Download and unzip the data if the data have not been downloaded yet
if(!file.exists("./data/household_pow_con_data.zip")) {
  dir.create("data")
  download.file(fileURL, destfile = "./data/household_pow_con_data.zip", method = "curl")
  unzip("./data/household_pow_con_data.zip", exdir = "./data/")
  dateDownloaded <- date()
}

##Read all the data between 1/2/2007 and 2/2/2007
headers <- read.table("./data/household_power_consumption.txt", header = FALSE, sep = ";", nrows = 1, stringsAsFactors = FALSE)
headers <- as.character(headers[1,])
data <- read.table("./data/household_power_consumption.txt", header = FALSE, sep = ";", skip = 66637, nrows = 2880, col.names = headers)

##Merge the date and time and convert to date and time class
data$Date <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

##Loop through all columns and transform class from factor to numeric
for (i in 1:length(data)) {
  if (class(data[,i]) == "factor") {
    data[,i] <- as.numeric(levels(data[,i]))[data[,i]]
  }
}

##Open connection to PNG graphic device and set width and height
png("plot4.png", width = 480, height = 480)

##Create plots
par(mfrow = c(2,2))

##Create first plot
plot(data$Date, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

##Create 2nd plot
plot(data$Date, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

##Create 3rd plot
plot(data$Date, data$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
lines(data$Date, data$Sub_metering_2, type = "l", col = "red")
lines(data$Date, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("sub_metering_1", "sub_metering_2", "sub_metering_3"), bty = "n", lty = c(1,1,1), col = c("black", "red", "blue"))

##Create 4th plot
plot(data$Date, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

##Close graphic device
dev.off()