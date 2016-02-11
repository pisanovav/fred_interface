## PURPOSE: The spript retrieves user-specified data sets from a FRED website and includes 3 functions and examples of their use.
## 
## DEVELOPER: Alexander Pisanov (pisanov.alexander@gmail.com).
## 
## WARNING: correct work with submonthly frequencies is not guaranteed.
##
## ALTERNATIVES: 'quantmod' library, 'getSymbol' function.
##
## TODO: submonthly frequencies, aggregation.

######################
#Connection interface#
######################

library(zoo) # 'zoo' library is required.

# Working folder, FRED endpoint and input file format setup.

fred.data.endpoint <- "https://research.stlouisfed.org/fred2/data/"
fred.data.format <- ".txt"

# Data parsing function.

fred.data.parser <- function(id)
#' DESCRIPTION: The function gets the .txt file with the series specified with 'id' from the FRED website, parses it and retrieves a number of objects: 'start' - series start date (Date), 'end" - end date (Date), 'descriptor' - data set description (Character), 'array' - data vector (Character).
#' PARAMETERS: 'id' (required) - time series id. Syntax is given in Examples.
{
  fred.data.file <- paste0(fred.data.endpoint,id,fred.data.format)
  data <- readLines(fred.data.file)
  data.id <- unlist(strsplit(gsub(" ","",data[2],fixed=TRUE),split=":"))[2]
  data.start <- as.Date(substring(gsub(" ","",data[8],fixed=TRUE),11,20))
  data.end <- as.Date(substring(gsub(" ","",data[8],fixed=TRUE),23,32))
  cut.index <- match("DATEVALUE",gsub(" ","",data,fixed=TRUE))
  data.descriptor <- data[1:(cut.index-1)]
  data.array <- data[-(1:cut.index)]
  data.parameters <- list("start"=data.start,"end"=data.end,"descriptor"=data.descriptor,"array"=data.array)
  
  if (!(data.id==id)) stop("Parsing error: 'fred.data.file' time series id doesn't match the id set by user. Report to the developer at pisanov.alexander@gmail.com.")
  
  return(data.parameters)
}

# Data retrieval function.

fred.data.retriever <- function(id,startdate,enddate)
#' DESCRIPTION: The function utilizes 'fred.data.parser' function to retrieve a 'zoo' class time series object, taken within a user-specified date range.
#' PARAMETERS: 'id' (required) - time series id; startdate(required) - time series start date; enddate(required) - time series end date. Syntax is given in Examples.
{
  data <- fred.data.parser(id)
  data.dates <- as.Date(substring(gsub(" ","",data$array,fixed=TRUE),1,10))
  data.values <- as.numeric(substring(gsub(" ","",data$array,fixed=TRUE),11,100))
  data.zoo <- zoo(data.values,order.by=data.dates)
  data.output <- as.matrix(window(data.zoo,start=startdate,end=enddate))
  colnames(data.output) <- id

  return(data.output)
}

# .csv writing function.

fred.csv.writer <- function(id,startdate,enddate,delim,decim,folder)
#' DESCRIPTION: The function utilizes 'fred.data.retriever' function to write a .csv file containing the result of the 'fred.data.retriever' function call to a user-specified folder.
#' PARAMETERS: 'id' (required) - time series id; startdate(required) - time series start date; enddate(required) - time series end date; delim(required) - column delimiter; decim(required) - decimal points delimiter. Syntax is given in Examples.
{
  data.output <- fred.data.retriever(id,startdate,enddate)
  write.table(data.output,file=paste0(folder,id,".csv"),row.names=TRUE,sep=delim,dec=decim)
  print(paste0(id,".csv has been written to ",my.working.folder,"."))
}

##########
#Examples#
##########

example <- fred.data.parser("GDPCA")
example$descriptor

example <- fred.data.retriever("GDPCA","1949-01-01","2010-01-01")
example

fred.csv.writer("GDPCA","1949-01-01","2010-01-01",";",",","C:/Users/Alexander Pisanov/Desktop/")

###########
#YOUR CODE#
###########
