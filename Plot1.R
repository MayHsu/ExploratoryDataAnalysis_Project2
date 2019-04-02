

##declare url and zip file name
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipFile <- "exdata_data_NEI_data.zip"

##download file
if(!file.exists(zipFile)){
        download.file(url,zipFile,method = "curl")
}

##unzip file
dataPath <- "exdata_data_NEI_data"
if(!file.exists(dataPath)){
        unzip(zipFile)
}

##read NEI summary data
NEI <- readRDS("summarySCC_PM25.rds")

##prepare summary data
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI, sum)

##create plot
png("plot1.png")
plot(aggregatedTotalByYear$year, aggregatedTotalByYear$Emissions, type = "l", lwd = 2,
     xlab = "Year", 
     ylab = expression("Total Tons of PM2.5 Emissions"), 
     main = expression("Total Tons of PM2.5 Emissions in the United States"))
dev.off()


