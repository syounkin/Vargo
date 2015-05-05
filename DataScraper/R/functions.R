#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Retrieves data from MGE by pulling it off of an interactive
#' website.
#' @name DataScraper
#' @docType package
#' @author Samuel G. Younkin \email{syounkin@@stat.wisc.edu}, Tedward Erker, Jason Vargo
NULL
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Expand Address function
#'
#' @param AddressList A character vector where each element is of the
#' form "form Number StreetDirection StreetName StreetType AddressUnit
#' AddressUnitNum". This format is found in the file
#' "Assessor_Property_Information.csv" available at
#' \code{https://data.cityofmadison.com/api/views/u7ns-6d4x/rows.csv?accessType=DOWNLOAD}
#' @note Take a list of addresses in the form Number
#' StreetDirection StreetName StreetType AddressUnit AddressUnitNum,
#' and output a dataframe of the items of the address separated into
#' new fields Also replace spaces in street names with "+".
#' @return A dataframe with the following character? vectors
#' 
#' \item{Address_Num}{}
#' 
#' \item{Address_StreetDirection}{}
#'
#' \item{Address_StreetName}{}
#'
#' \item{Address_StreetType}{}
#'
#' \item{Address_Unit}{}
#'
#' \item{Address_UnitNum}{}
#'
#' @author Tedward Erker
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Reshape energy use table.
#'
#' @param EnergyUseTable ???
#' @note Reshape the html energy use data table to be one row.
#' EnergyUseTable<-gas_energy_table EnergyUseTable<-ele_energy_table
#' EnergyUseTable<-full_energy_table str(EnergyUseTable)
#' str(unlist(ele_energy_table)) View(EnergyUseTable)
#' @return A dataframe with re-ordered columns.
#' @author Tedward Erker
#' @export
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
