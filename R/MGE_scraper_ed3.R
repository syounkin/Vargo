### Written by Tedward Erker
###  Scrap energy use data from MGE website



#############  Planning

# There are ~63,000 houses in Madison that I need to scrape data for.  I need to do the scraping every 15 days to make
# sure that I get all the changes (I'm guessing they update the website at different times for different addresses
# and the 'months' are realy billing periods).  I also don't want to overload their server so I should get access their
# site as little as possible.  63,000 X 20 seconds = 350 hours or 14.5 days.  10 seconds would be 175 hours or 6.75 days.
#  I will probably have to go the 10 second route.  Then I'll download the data over the course of a week, check it
# the next week, then repeat the cycle.
# 



rm(list=ls())
### install necesary packages
list.of.packages <- c("XML", "reshape2","dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(XML)
library(reshape2)
library(dplyr)

##### Functions #####

# Take a list of addresses in the form Number StreetDirection StreetName StreetType AddressUnit AddressUnitNum, and output a dataframe of 
# the items of the address separated into new fields
# Also replace spaces in street names with "+"
expand_address<-function (AddressList){
  rexp <- "^([0-9]+)\\s?(N\\s|S\\s|E\\s|W\\s)?(.*)\\s(Ln|Dr|Blvd|Ave|Ct|Cir|St|Rd|Pl|Pass|Trl|Ter|Pkwy|Way)\\s?(Unit)?\\s?(\\w*)"
  Address_Num=sub(rexp,"\\1",AddressList)
  Address_StreetDirection=sub(rexp,"\\2",AddressList)
  Address_StreetName=sub(rexp,"\\3",AddressList)
  Address_StreetName<-gsub(" ","+",Address_StreetName)
  Address_StreetType=sub(rexp,"\\4",AddressList)
  Address_Unit=sub(rexp,"\\5",AddressList)
  Address_UnitNum=sub(rexp,"\\6",AddressList)
  return (data.frame(Address_Num,Address_StreetDirection,Address_StreetName,Address_StreetType,Address_Unit,Address_UnitNum))
}


# Reshape the html energy use data table to be one row.

  #testing
#   EnergyUseTable<-gas_energy_table
#   EnergyUseTable<-ele_energy_table
#   EnergyUseTable<-full_energy_table
#   str(EnergyUseTable)
#   str(unlist(ele_energy_table))
#   View(EnergyUseTable)

reshape_EnergyUseTable<- function (EnergyUseTable) {
  output_EnergyUseTable<-data.frame(matrix(NA,nrow=1,ncol=107))
  EnergyUseTable<-unlist(EnergyUseTable)
  # EnergyUseTable[1,1:5]<-EnergyUseTable[1,2:6]
  #making adjustments to the energy table if it includes both gas and electric
  # pull values from the webpage table and put in formatted_EnergyUseTable.  Two different ways because some have gas and others don't
  if(length(EnergyUseTable)>24){
    values<-c(EnergyUseTable[c(8,15,22,9,16,23,10,17,24,29,12,19,26,13,20,27,14,21,28,33)])
    output_EnergyUseTable[1,1:20]<-values
  } else {
    values<-c(EnergyUseTable[c(4,7,10,5,8,11,6,9,12,13)])
    if (length(grep("therms",values[1]))>0){
      output_EnergyUseTable[1,1:10]<-values
    } else {
      output_EnergyUseTable[1,11:20]<-values
    }
  }
  return(data.frame(output_EnergyUseTable))
}





############################# Importing Assessor Property Information for Madison ##################

# import data
prop_info<-read.csv(file = "Assessor_Property_Information.csv",header=T,sep = ",",as.is=T)
prop_info[] <- lapply(prop_info, as.character)  # make variables characters, not factors
prop_info<-tbl_df(prop_info)

############################  Expand Address field to be multiple fields

prop_info_expandedAddress <- expand_address(prop_info$Address)
prop_info_expandedAddress<-cbind(prop_info,prop_info_expandedAddress)


###############################  Remove non residential property classes from the table    #############################################################
prop_info_expandedAddress<-prop_info_expandedAddress %>%
  filter(Property.Class=="Residential")

###############################  Remove  property with zero dwelling units    #############################################################
prop_info_expandedAddress<-prop_info_expandedAddress %>%
  filter(Dwelling.Units > 0)


# View(prop_info_expandedAddress)


#############################    setting base variables, data frames etc.  #############################
### set the root url
root_url<-"http://www.mge.com/customer-service/home/average-use-cost/results.htm?"


### create the output energy table comma separated file
energy_table_column_headers<-c("therms_in_highest_billing_period","gas_cost_in_highest_billing_period","number_days_in_highest_gas_billing_period","therms_in_lowest_billing_period","gas_cost_in_lowest_billing_period","number_days_in_lowest_gas_billing_period","therms_monthly_average","gas_cost_monthly_average","number_days_monthly_average","gas_used_for_heating","kilowatthours_in_highest_billing_period","electric_cost_in_highest_billing_period","number_days_in_highest_electric_billing_period","kilowatthours_in_lowest_billing_period","electric_cost_in_lowest_billing_period","number_days_in_lowest_electric_billing_period","kilowatthours_monthly_average","electric_cost_monthly_average","number_days_monthly_average","electric_used_for_heating","Date_Scraped","Time_Scraped",colnames(Active_Address_List))
energy_table<-formatted_energy_table<-data.frame(matrix(NA,nrow=0,ncol=length(energy_table_column_headers)))
colnames(energy_table)<-energy_table_column_headers
write.table(energy_table, file = "Energy_Table.csv", sep = ",")

### The loop to output a csv
for (i in 61135:63000) {
  ### prepping the URL
  house_number<-Active_Address_List$Address_Num[i]   # set house number
  street_direction<-Active_Address_List$Address_StreetDirection[i]   #set sd
  street_name<-Active_Address_List$Address_StreetName[i]   #set street name
  street_suffix<-Active_Address_List$Address_StreetType[i]   #set street suffix/Type
  apartment_unit<-Active_Address_List$Address_UnitNum[i]   #set au
  city<-"Madison"
  ###combine to create full url
  full_mge_url<-paste(sep="",root_url,"hn=",house_number,"&sd=",street_direction,"&sn=",street_name,"&ss=",street_suffix,"&au=",apartment_unit,"&c=",city)
  
  #test if the webpage exists
  energy_table <- try(readHTMLTable(full_mge_url,as.data.frame=F), silent=TRUE) 
    if ('try-error' %in% class(energy_table)) {
      energy_table<-data.frame(matrix(NA,nrow = 1,ncol = 107))
    } else {
    ### extracting the table from the webpage
    energy_table<-reshape_EnergyUseTable(energy_table)
    energy_table[1,21]<-as.Date(Sys.Date())
    energy_table[1,22]<-Sys.time()
    #### I should also extract the address as it is on their website to check if it is the same as the address I entered.
  }
  energy_table[1,23:(23+length(Active_Address_List[i,]))]<-Active_Address_List[i,]
  if (i == 1){
    write.table(energy_table, file = "Energy_Table.csv", sep = ",", col.names = FALSE, append=FALSE,row.names = F)
  } else {
    write.table(energy_table, file = "Energy_Table.csv", sep = ",", col.names = FALSE, append=TRUE,row.names = F)
  }
  print(i)
  flush.console()
  ##### suspend execution of for loop for seconds #####
  Sys.sleep(runif(1,min = 0,max=10))
}





#erase the energy csv
write.table(file = "Energy_Table.csv", sep = ",", col.names = FALSE, append=FALSE,row.names = F)






