Interface to FRED economic statistics in R 
==========================================

St. Louis Fed [FRED economic statistics](https://research.stlouisfed.org/fred2/) is a key source on economic data about the US and international economy. 

```get_fred_zoo()``` in [fred_interface.r](fred_interface.r) is an access function to get ```zoo```-type time series by name from FRED. No API key is necessary. Can also write to local csv file by ```fred_to_csv()```

Example:

```R
gdp = get_fred_zoo('GDPCA')
cpi_base100 = get_fred_zoo('CPIAUCSL', '2015-01-01', '2015-12-01')
fred_to_csv('DEXUSEU')
```

Similar to access options by ```quantmod``` library:
```R
library("quantmod")
getSymbols("CPIAUCSL",src="FRED")
```

See also:
 - <https://github.com/sboysel/fredr>
 - [FRED API](https://research.stlouisfed.org/docs/api/fred/)
