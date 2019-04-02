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

#Filter Motor vehicle related source
NEI_vehicle_chk <- grepl("Veh", mergeNEI$Short.Name, ignore.case=TRUE)
NEI_Vehicle <- mergeNEI[NEI_vehicle_chk,]

#Data subset for Baltimore and Los Angeles
NEI_Veh <- subset(NEI_Vehicle,fips=="24510" | fips=="06037")

##prepare summary data for Baltimore and Los Angeles
aggregatedTotalByYear <- aggregate(Emissions ~ year + fips, NEI_Veh, sum)
aggregatedTotalByYear[aggregatedTotalByYear$fips == "24510",]$fips <- "Baltimore"
aggregatedTotalByYear[aggregatedTotalByYear$fips == "06037",]$fips <- "Los Angeles"

##create plot
png("plot6.png")
par(mfrow = c(1, 2))

#Create line graph for Baltimore and Los Angeles
g <- ggplot(aggregatedTotalByYear, aes(year, Emissions))
g <- g + facet_grid(. ~ fips)
g <- g + geom_line() +
        xlab("year") +
        ylab(expression("Total PM2.5 Emissions")) +
        ggtitle('Comparism Baltimore and Los-Angeles Vehicle-Emissions from 1999-2008')
print(g)
dev.off()


