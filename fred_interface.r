# Purpose: access interface to FRED database to retrieve 'zoo' class time series.
# Database URL: https://research.stlouisfed.org/fred2.
# Code URL: https://github.com/pisanovav/fred_interface.
# Author(s): Evgeny Pogrebnyak, Alexander Pisanov.
#
# Entry points:
#   id = 'GDPCA'
#   get.zoo.fred(id)
#   write.csv.fred(id)
#
# Todo: function tests.

#############################
# FRED CONNECTION INTERFACE #
#############################

library(RCurl) # 'RCulr' library is required.
library(zoo) # 'zoo' library is required.

get.data.url.fred <- function(id)
  #' Returns an URL string. Syntax: get.data.url.fred("CPIAUCSL").
  #' id (required) - time series id.
{
  data.url <- paste0("https://research.stlouisfed.org/fred2/data/",id,".txt")
  
  if (!url.exists(data.url)) stop("The URL doesn't exist. Check time series' id.")
  
  return(data.url)
}

get.data.lines.fred <- function(id)
  #' Returns a character vector containing .txt file data. Syntax: get.data.url.fred("CPIAUCSL").
  #' id (required) - time series id.
{
  data.content <- getURL(get.data.url.fred(id),ssl.verifypeer=0L,followlocation=1L)
  data.lines <- strsplit(data.content,'\r\n')[[1]]
  
  return(data.lines)
}

get.data.id.fred <- function(data.lines)
  #' Returns a character element containing time series id from get.data.lines.fred(id). Syntax: get.data.id.fred(data.lines).
  #' data.lines(required) - character vector containing FRED time series .txt file data.
{
  data.id <- sub("Series ID:\\s+","",data.lines[2])
  
  if (!(data.id)==id) stop ("Data id doesn't match URL id. Report to the developer.")
  
  return(data.id)
}

get.data.range.fred <- function(data.lines)
  #' Returns a date vector containing time series start and end dates from get.data.lines.fred(id). Syntax: get.data.range.fred(data.lines).
  #' data.lines(required) - character vector containing FRED time series .txt file data.
{
  string <- data.lines[8]
  pattern <- "\\d{4}-\\d{2}-\\d{2}"
  data.range <- as.Date(regmatches(string,gregexpr(pattern,string))[[1]])
  
  return(data.range)
}

get.data.components.fred <- function(id)
  #' Returns a 'list' object containing formatted parts of the .txt file data. Syntax: get.data.components.fred("CPIAUCSL").
  #' id(required) - time series id (look up here: https://research.stlouisfed.org/fred2/).
{
  data.lines <- get.data.lines.fred(id)
  cut <- charmatch("DATE",data.lines)
  
  return(list("start"=get.data.range.fred(data.lines)[1],
              "end"=get.data.range.fred(data.lines)[2],
              "desc"=data.lines[1:(cut-1)],
              "data"=data.lines[-(1:cut)]))
}  

get.zoo.fred <- function(id,start.date=NULL,end.date=NULL)
  #' Returns an object of class 'zoo' with a time series of a selected id and date range. Syntax: get.zoo.fred("CPIAUCSL","1999-01-01","2000-01-01").
  #' id(required) - time series id (look up here: https://research.stlouisfed.org/fred2/), start/end.date(optional) - date range.
{
  data.table <- read.table(text=get.data.components.fred(id)$data,stringsAsFactors=FALSE)
  data.zoo <- zoo(data.table[,2],order.by=data.table[,1])
  
  return(window(data.zoo,start=start.date,end=end.date))
}

write.csv.fred <- function(id,start.date=NULL,end.date=NULL)
  #' Writes a .csv file to current working directory. Syntax: write.csv.fred("CPIAUCSL",1999-01-01","2000-01-01").
  #' id(required) - time series id (look up here: https://research.stlouisfed.org/fred2/), start/end.date(optional) - date range.
{
  data.filename <- paste0(id,".csv")
  write.csv(get.zoo.fred(id,start.date,end.date),file=data.filename,row.names=TRUE,dec=",")
  
  warning(paste("Wrote ",data.filename," to current working directory: ",getwd()))
  
  return(file.path(getwd(),data.filename)) 
}

#############
# YOUR CODE #
#############

source("fred_interface.R") # File with the interface code should be saved in your current working directory.

# ...
