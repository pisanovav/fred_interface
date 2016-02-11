Interface to FRED economic statistics in R 
==========================================

St. Louis Fed [FRED economic statistics](https://research.stlouisfed.org/fred2/) is a key source on economic data about the US and international economy. This database also has an [API](https://research.stlouisfed.org/docs/api/fred/) that allows convenient data retrieval for further analysis/plotting in R.

[fred_interface.r](fred_interface.r) is a simple access script to get time series by names from FRED into ```zoo``` type time series. It also enables user to save data to a ```.csv``` file.

```R
# Using 'fred_interface.r' functions to get a data set description...:
example <- fred.data.parser("GDPCA")
example$descriptor
# ... to get 'zoo' type time series:
example <- fred.data.retriever("GDPCA","1949-01-01","2010-01-01")
example
# ... and to write a '.csv' file to a specified folder:
fred.csv.writer("GDPCA","1949-01-01","2010-01-01",";",",","C:/Users/Alexander Pisanov/Desktop/")
```

Alternative acces options via 'quantmod' library and others:

```R
# Getting 'zoo' type time series via 'quantmod' library:
library("quantmod")
getSymbols("CPIAUCSL",src="FRED")
```

