library(ggplot2)

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
aggregatedTotalByYear_Type <- aggregate(Emissions ~ year + type, NEI_Baltimore, sum)

##create plot
png("plot3.png")
g <- ggplot(aggregatedTotalByYear_Type, aes(year, Emissions, color = type))
g <- g + geom_line() +
        xlab("year") +
        ylab(expression("Total PM2.5 Emissions")) +
        ggtitle('Total Emissions in Baltimore City-US from 1999-2008')
print(g)
dev.off()


