Interface to FRED economic statistics in R 
==========================================

St. Louis Fed [FRED economic statistics](https://research.stlouisfed.org/fred2/) is a key source on economic data about the US and international economy. 

```get.zoo.fred()``` in [fred_interface.r](fred_interface.r) is an access function to get ```zoo```-type time series by name from FRED. No API key is necessary. Can also write to local .csv file by ```write.csv.fred()```

Example:

```R
gdp = get.zoo.fred('GDPCA')
cpi_base100 = get.zoo.fred('CPIAUCSL','2015-01-01','2015-12-01')
write.csv.fred('DEXUSEU')
```

Similar to access options by ```quantmod``` library:
```R
library("quantmod")
getSymbols("CPIAUCSL",src="FRED")
```

See also:
 - <https://github.com/sboysel/fredr>
 - [FRED API](https://research.stlouisfed.org/docs/api/fred/)
