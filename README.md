Interface to FRED economic statistics in R 
==========================================

St. Louis Fed [FRED economic statistics](https://research.stlouisfed.org/fred2/) is a key source on economic data about the US and international economy. This database also has an [API](https://research.stlouisfed.org/docs/api/fred/) that allows convenient data retrieval for further analysis/plotting in R.

[fred_interface.r](fred_interface.r) is simple access script to get time series by names from FRED into ```zoo``` type time series:

```R
example <- fred.data.parser("GDPCA")
example$descriptor

example <- fred.data.retriever("GDPCA","1949-01-01","2010-01-01")
example

fred.csv.writer("GDPCA","1949-01-01","2010-01-01",";",",","C:/Users/Alexander Pisanov/Desktop/")
```

Other acces options via quantmod and others: ***Comment here*** 

```R
library("quantmod")

getSymbols("CPIAUCSL",src="FRED")
```

