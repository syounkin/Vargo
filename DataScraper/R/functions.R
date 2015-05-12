#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Retrieves data from MGE by pulling it off of an interactive
#' website.
#' @name DataScraper
#' @docType package
#' @author Samuel G. Younkin \email{samuel.younkin@@gmail.com}, Tedward Erker, Jason Vargo
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
  Address_Num=as.character(sub(rexp,"\\1",AddressList))
  Address_StreetDirection=as.character(sub(rexp,"\\2",AddressList))
  Address_StreetName=as.character(sub(rexp,"\\3",AddressList))
  Address_StreetName<-gsub(" ","+",Address_StreetName)
  Address_StreetType=as.character(sub(rexp,"\\4",AddressList))
  Address_Unit=as.character(sub(rexp,"\\5",AddressList))
  Address_UnitNum=as.character(sub(rexp,"\\6",AddressList))
  return (data.frame(Address_Num,Address_StreetDirection,Address_StreetName,Address_StreetType,Address_Unit,Address_UnitNum, stringsAsFactors = FALSE))
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Reshape energy use table. (Deprecated)
#'
#' @param EnergyUseTable deprecated
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Parses the energy tables
#'
#' @param energyTable a list of vectors as returned by readHTMLTable
#' and the MGE web page.
#' @return a list with five numeric vectors; therms, kWh, therms.dollar,
#' kWh.dollar, therms.days, kWh.days
#' @author Samuel Younkin
#' @export
parseEnergyTable<- function (energyTable) {

    if( length(energyTable) != 1 ){

        energyTable <- as.data.frame(energyTable)
    
        if( all(dim(energyTable) == c(7,6)) ){
            therms <- energyTable[1:3,2]
            kWh <- energyTable[5:7,2]
            therms.dollar <- energyTable[1:3,3]
            kWh.dollar <- energyTable[5:7,3]
            therms.days <- energyTable[1:2,4]
            kWh.days <- energyTable[5:6,4]
            
            therms <- as.numeric(unlist(strsplit(as.character(therms), ".therms", perl = TRUE)))
            kWh <- as.numeric(unlist(strsplit(as.character(kWh), ".kWh", perl = TRUE)))
            therms.dollar <- as.numeric(gsub("\\$","", therms.dollar))
            kWh.dollar <- as.numeric(gsub("\\$","", kWh.dollar))
            therms.days <- as.numeric(gsub(" days","", therms.days))
            kWh.days <- as.numeric(gsub(" days","", kWh.days))
            
            energyData <- list(therms=therms,kWh=kWh,therms.dollar=therms.dollar,kWh.dollar=kWh.dollar,therms.days=therms.days,kWh.days=kWh.days)
        
        } else if(all(dim(energyTable) == c(3,5))){ # Either only therms or only kWh

            
            if( all(grepl("therms",energyTable[,2])) ){ # therms
                therms <- energyTable[1:3,2]
                therms.dollar <- energyTable[1:3,3]
                therms.days <- energyTable[1:2,4]

                therms <- as.numeric(unlist(strsplit(as.character(therms), ".therms", perl = TRUE)))
                therms.dollar <- as.numeric(gsub("\\$","", therms.dollar))
                therms.days <- as.numeric(gsub(" days","", therms.days))

                energyData <- list(therms=therms,kWh=rep(NA,3),therms.dollar=therms.dollar,kWh.dollar=rep(NA,3),therms.days=therms.days,kWh.days=rep(NA,2))

            }else if( all(grepl("kWh",energyTable[,2])) ){ # kWh
                kWh <- energyTable[1:3,2]
                kWh.dollar <- energyTable[1:3,3]
                kWh.days <- energyTable[1:2,4]

                kWh <- as.numeric(unlist(strsplit(as.character(kWh), ".kWh", perl = TRUE)))
                kWh.dollar <- as.numeric(gsub("\\$","", kWh.dollar))
                kWh.days <- as.numeric(gsub(" days","", kWh.days))

                energyData <- list(therms=rep(NA,3),kWh=kWh,therms.dollar=rep(NA,3),kWh.dollar=kWh.dollar,therms.days=rep(NA,2),kWh.days=kWh.days)

            }else{
                energyData <- list("")
            }

        }else{

            energyData <- list()
        }

    } else{

        energyData <- list()

    }

    return( energyData )

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Writes data to a file
#'
#' @param energyTableList a list of lists as returned by the function
#' parseEnergyTable
#' @param filename character string giving the file name for the data file
#' @return A data frame containing the data in the energyTableList
#' with rows as properties and 16 colums.
#' @author Samuel Younkin
#' @export
reshapeEnergyTableList <- function (energyTableList, filename) {

    foo <- lapply(energyTableList, function(energyTable) {
        if(length(energyTable) != 0){
            return(c( energyTable$therms, energyTable$kWh, energyTable$therms.dollar, energyTable$kWh.dollar,energyTable$therms.days, energyTable$kWh.days))
        }else{
            return(rep(NA,16))
        }
    })
    foobar <- data.frame(parcel = as.character(names(energyTableList)), t(as.data.frame(foo)),stringsAsFactors=FALSE)
    
    colnames(foobar) <- c("parcel","therms.1","therms.2","therms.3","kWh.1","kWh.2","kWh.3","therms.dollar.1","therms.dollar.2","therms.dollar.3","kWh.dollar.1","kWh.dollar.2","kWh.dollar.3","therms.days.1","therms.days.2","kWh.days.1","kWh.days.2")


    write.table(foobar, file = filename, sep = ",", quote = FALSE, row.names=FALSE, col.names = TRUE)
    
    return(foobar)
}
