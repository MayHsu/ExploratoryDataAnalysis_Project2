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
if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}

#Conbine 2 files by using SCC as key
mergeNEI <- merge(NEI,SCC,by="SCC")

#Filter Vehicle data
NEI_vehicle_chk <- grepl("Veh", mergeNEI$Short.Name, ignore.case=TRUE)
NEI_Vehicle <- mergeNEI[NEI_vehicle_chk,]

#Filter Baltimore data
NEI_Veh_Baltimore <- subset(NEI_Vehicle,fips=="24510")

##prepare summary data
aggregatedTotalByYear_Type <- aggregate(Emissions ~ year, NEI_Veh_Baltimore, sum)

##create plot
png("plot5.png")
g <- ggplot(aggregatedTotalByYear_Type, aes(year, Emissions))
g <- g + geom_line() +
        xlab("year") +
        ylab(expression("Total PM2.5 Emissions")) +
        ggtitle('Total Motor-Vehicle Emissions of Baltimore from 1999-2008')
print(g)
dev.off()


