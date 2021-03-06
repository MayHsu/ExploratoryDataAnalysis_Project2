

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
if(!exists("NEI")){
NEI <- readRDS("summarySCC_PM25.rds")
}

#Filter Baltimore data
NEI_Baltimore <- subset(NEI,fips=="24510")

##prepare summary data
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI_Baltimore, sum)

##create plot
png("plot2.png")
plot(aggregatedTotalByYear$year, aggregatedTotalByYear$Emissions, type = "l", lwd = 2,
     xlab = "Year", 
     ylab = expression("Total Tons of PM2.5 Emissions"), 
     main = expression("Total Tons of PM2.5 Emissions in Baltimore City-US from 1999-2008"))
dev.off()


