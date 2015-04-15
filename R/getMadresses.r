
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

write.csv(MadParcels,"./Maddresses.csv", row.names=F) 

