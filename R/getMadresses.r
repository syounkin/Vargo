
setwd("~/Desktop/MGE/")


library(shapefiles)
library(sp)
library(rgdal)
library(maptools)


DaneParcels <- readShapePoly("./Dane_Parcels_2014//Dane_Parcels_2014.shp")
DaneParcels@data$vargoID <- c(1:nrow(DaneParcels@data))

nrow(DaneParcels@data)

#hn,sd,sn,ss,au,c
data <- DaneParcels@data[,c("PropertySt", "PropertyPr", "Property_1","Property_2","Property_3","Property_5", "vargoID")]

nrow(data)


MadParcels <- subset(data, Property_5 == "Madison")
nrow(MadParcels)

head(MadParcels)

names(MadParcels) <- c("hn","sd","sn","ss","au","c", "GIS_ID")

test <- subset(MadParcels, sn == "WASHINGTON")

write.csv(MadParcels,"../../Dropbox/Vargo (1)/Maddresses.csv", row.names=F, na='', quote=FALSE) 


########################################################
###bring in Madison energy data and merge to GIS
########################################################


full <- read.csv("./results.csv", header=FALSE)

#add new fields once we have full results including gas usage
names(full) <- c("hn","sd","sn","ss","au","c", "GIS_ID","high_elec", "low_elec", "avg_elec")

new <- merge(DaneParcels@data, full, by.x="vargoID", by.y="GIS_ID",  all.x=T)

newproj <- "+proj=lcc +lat_1=43.0695160375 +lat_0=43.0695160375 +lon_0=-89.42222222222223 +k_0=1.0000384786 +x_0=247193.2943865888 +y_0=146591.9896367793 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=us-ft"
 
DaneParcels@proj4string <- CRS(newproj)
 
DaneParcels@data <- new
writeOGR(DaneParcels, "resultsGIS", "fullResults", driver="ESRI Shapefile", overwrite_layer=T)
 



