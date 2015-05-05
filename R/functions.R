#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Simulate read data for RNA-seq Differential Expression Analysis
#' @name DataScraper
#' @docType package
#' @author Samuel G. Younkin \email{syounkin@@stat.wisc.edu}, Tedward Erker
NULL
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Expand Address function
#'
#' @param AddressList ??
#' @note Take a list of addresses in the form Number
#' StreetDirection StreetName StreetType AddressUnit AddressUnitNum,
#' and output a dataframe of the items of the address separated into
#' new fields Also replace spaces in street names with "+"

#' @return A dataframe with the following elements
#' 
#' \item{Address_Num}{}
#' 
#' \item{Address_StreetDirection}{}
#' 
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
