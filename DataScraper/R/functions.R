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
#' Parses the energy tables
#'
#' @param energyTable a list of vectors as returned by readHTMLTable
#' and the MGE web page.
#' @return a list with five numeric vectors; therms, kWh, therms.dollar,
#' kWh.dollar, therms.days, kWh.days
#' @author Samuel Younkin
#' @export
parseEnergyTable<- function (energyTable) {

    if( class(energyTable) != "try-error" ){

        energyTable <- as.data.frame(energyTable)
    
        if( all(dim(energyTable) == c(7,6)) ){

            if( any(names(energyTable)=="Kilowatt.Hours")  & any(energyTable[4,]=="Kilowatt Hours")){

                energyData <- list()

                message("Two electric meters, no heat. This property will not included in results.")

            }else if( any(names(energyTable)=="Therms")  & any(energyTable[4,]=="Therms")){

                energyData <- list()

                message("Two heat meters, no electric. This property will not included in results.")


            }else{

                if( names(energyTable)[3] == "Therms" & energyTable[4,3] == "Kilowatt Hours"){
            
                therms <- energyTable[1:3,2]
                kWh <- energyTable[5:7,2]
                therms.dollar <- energyTable[1:3,3]
                kWh.dollar <- energyTable[5:7,3]
                therms.days <- energyTable[1:2,4]
                kWh.days <- energyTable[5:6,4]
            
                therms <- as.numeric(unlist(strsplit(as.character(therms), ".therms", perl = TRUE)))
                kWh <- as.numeric(unlist(strsplit(as.character(kWh), ".kWh", perl = TRUE)))
                therms.dollar <- as.numeric(gsub("\\$|\\,","", therms.dollar))
                kWh.dollar <- as.numeric(gsub("\\$|\\,","", kWh.dollar))
                therms.days <- as.numeric(gsub(" days","", therms.days))
                kWh.days <- as.numeric(gsub(" days","", kWh.days))
            
                energyData <- list(therms=therms,kWh=kWh,therms.dollar=therms.dollar,kWh.dollar=kWh.dollar,therms.days=therms.days,kWh.days=kWh.days)

            }else{

                cat("Error number SGY-1")

                energyData <- list()

            }
          }

        }else if(all(dim(energyTable) == c(3,5))){ # Either only therms or only kWh

            
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
                energyData <- list()
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Identifies outliers
#'
#' @param vec
#' @return a logical vector
#' @author Samuel Younkin
#' @export
isOutlier <- function(vec){
    vec <- as.numeric(vec)
    iqr <- c(-1,1)%*%quantile(vec,c(0.25,0.75),na.rm=TRUE)
    thresh <- quantile(vec,c(0.25,0.75), na.rm=TRUE)+c(-1,1)*1.5*iqr
    return((vec < thresh[1] | vec > thresh[2]) & !is.na(vec))
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' retrieveEnergyTable
#'
#' @param house_number
#' @param street_direction
#' @param street_name
#' @param street_suffix
#' @param apartment_unit
#' @param city
#' @return A list with on element (or a try.error)
#' @author Samuel Younkin
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
retrieveEnergyTable <- function(house_number, street_direction, street_name, street_suffix, apartment_unit, city){
    full_mge_url<-paste( "http://www.mge.com/customer-service/home/average-use-cost/results.htm?",
                        "hn=", house_number,
                        "&sd=", street_direction,
                        "&sn=", street_name,
                        "&ss=", street_suffix,
                        "&au=", apartment_unit,
                        "&c=", city,
                        sep=""
                        )
    energy_table <- try(readHTMLTable(full_mge_url,as.data.frame=F), silent = TRUE)

    return(energy_table)

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' retrieveEnergyList
#'
#' @param Active_Address_List
#' @return A list??
#' @author Samuel Younkin
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
retrieveEnergyList <- function(Active_Address_List, mc.cores = 6){
  with(Active_Address_List,{
    house_number<-Address_Num
    street_direction<-Address_StreetDirection
    street_name<-Address_StreetName
    street_suffix<-Address_StreetType
    apartment_unit<-Address_UnitNum
    city<-"Madison"
    obj <- mcmapply(retrieveEnergyTable, house_number, street_direction, street_name, street_suffix, apartment_unit, city, mc.cores = mc.cores)
    names(obj) <- Parcel
    return(obj)
  })
}
