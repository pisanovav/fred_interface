# todo: more sparse formatting of headers

## DOCSTRING HERE - short description what the script does, overall task 
## 
## Author: Alexander Pisanov (pisanov.alexander@gmail.com)

## Entry points:
## fred.data.description(id)
## fred.data.values(id,start,end,csv)

## Parameters: 
##    id - series id from FRED website (EXAMPLE: "GDPC1" еще какие-то? CPI?)
##    start, end - что это? опциональные или обязательные параметры?

## WARNING: correct work with submonthly frequencies is not guaranteed
## Alternatives: - ссылки на алтернативные пакеты как получить данные, кратко.

library(zoo) # Zoo library is required.


# Working folder, FRED endpoint and file format setup

my.working.folder <- setwd("C:/Users/Alexander Pisanov/Desktop")
fred.data.endpoint <- "https://research.stlouisfed.org/fred2/data/"
fred.data.format <- ".txt"


get_data_by_id <- fucntion(id)
{
  fred.data.file <- paste0(fred.data.endpoint,id,fred.data.format)
  data <- readLines(fred.data.file)
  data.id <- unlist(strsplit(gsub(" ","",data[2],fixed=TRUE),split=":"))[2]
  
  # в чем смысл происходящего здесь?
  # требуется разделить код, который выдает результат и его обратбоку, если что-то идет не так - issue #1
  if (!(data.id==id)) err <- err+1 else err
  if (!(data.id==id)) print("Error: 'fred.data.file' time series id doesn't match the id set by user. Please, report to the developer.")
  
  # TODO: вместо кода выше нужен exception
  # http://stackoverflow.com/questions/12723800/how-to-return-a-error-message-in-r
  # http://stackoverflow.com/questions/1608130/equivalent-of-throw-in-r#comment1473968_1608170
  
  # if (!(data.id==id)) + дальше код остановки программы с собщением ()
  
  return data
}




# DATA DESCRIPTION FUNCTION:
fred.data.description <- function(id)
# ЕП: добавить докстринг к функции, ее краткое описание
{
  data = get_data_by_id(id)
  
  # нужен комментарий, что строка делает  
  parse <- gsub(" ","",data,fixed=TRUE)
  
  # нужен комментарий, что строка делает 
  parse.index <- match("DATEVALUE",parse)-1
  
  # нужен комментарий, что строка делает 
  return(data[1:parse.index])
  
  # общий смысл происходящего: вместо кода, в котором переплетены и обработка ошибок и парсинг и повоторяющаяся в дргом месте функция
  # у вас есть лаконичный код, который делает одно понятное дело - парсит файл. ко всяким выражениям парсинга нужен комментарий, ктоорый поясняет что 
  # что эти стрки должны делать, какой результат. 
  
  # issue #1
  # идея с 0 был не очень удачной, извините, лучше убрать
  #if (err>0) output <-0 else output <- data.parse
  
  #{return(output)}
}

# DATA VALUES FUNCTION:


# TODO: необходимо разделить две функции - одна выдает zoo, другая пишет в csv, csv как флаг не очень красиво. 
# fred.data.to_csv <- function(id,start,end)
# fred.data.values <- function(id,start,end,csv)

# ЕП not todo: обычно values это просто вектор значений, поэтому назавание fred.data.values не совсем удачное т.к. фнкция\ возвращает объект типа zoo
fred.data.values <- function(id,start,end,csv)
{
  err <-0
  
  # This function block gets and parses the .txt file into a numeric vector "data.parse":
  
  data = get_data_by_id(id)
  
  data.start <- as.Date(substring(gsub(" ","",data[8],fixed=TRUE),11,20))
  data.end <- as.Date(substring(gsub(" ","",data[8],fixed=TRUE),23,32))
  # должно заканчиваться exception 
  #if (!((data.start<=start)&(data.end>=end))) {err <- err+1;print("Error: check dates (start/end) parameters. Start/end date should be in time-series' date range. Output is set to zero. You can use 'fred.data.description' function for date range info.")} else err <- err

  # эта ошибка орабатывается в get_data_by_id(id)
  #if (!(data.id==id)) {err <- err+1;print("Error: 'fred.data.file' time series' id doesn't match the id set by user. Report to the developer.")} else err
    
  # тоже повторяющийся код, нет?
  parse <- gsub(" ","",data,fixed=TRUE)
  parse.index <- match("DATEVALUE",parse)
  parse <- data[-(1:parse.index)]
  
  # комментарий
  date.parse <- as.Date(substring(gsub(" ","",parse,fixed=TRUE),1,10))
  data.parse <- as.numeric(substring(gsub(" ","",parse,fixed=TRUE),11,100))
  
  # This function block converts "data.parse" into a "zoo" object and trims out the window of a requested width, outputs the window and writes .csv file if csv=1.
  
  zoo.data <- zoo(data.parse,order.by=date.parse)
  
  
  if (err>0) output <-0 else {output <- as.matrix(window(zoo.data,start=start,end=end));colnames(output) <- id}
  
  # TODO: вынести в отедльную функцию 
  if (csv>0) {write.table(zoo(output,order.by=index(output)),file=paste0(id,".csv"),row.names=TRUE,sep=";",dec=",");print(paste0(id,".csv was written to ",my.working.folder,"."))} else print(".csv was not requested.")
  
  {return (output)}
}

# EXAMPLE:

# TODO: must add test - short hardcoded constant shoule be equal to result of function calls 

GDPC1 <- fred.data.description("GDPC1") # Series' id is set as a parameter.
GDPC1 # Data sescription should have been retrieved successfully.

GDPC1 <- fred.data.values("GDPC1","1947-01-01","2016-01-01",0) # Series' end date is set incorrectly, .csv disabled.
GDPC1 # Zero with an error message.

GDPC1 <- fred.data.values("GDPC1","1947-01-01","2015-09-01",1) # Retrying with a correct date range, .csv enabled.
GDPC1 # Data values should have been retrieved successfully.

####################
#YOUR CODE HERE:####
####################

## TODO: submonthly frequencies, aggregation.