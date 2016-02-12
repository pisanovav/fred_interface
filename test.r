library(RUnit)

source("fred_interface.r")

# WARNING: may fail on data revision, may need to use earlier dates for testing
checkEqualsNumeric(15961.7, get_fred_zoo('GDPCA', '2014-01-01'))
checkEqualsNumeric(237.847, get_fred_zoo('CPIAUCSL', '2015-11-01', '2015-12-01')[2])
checkTrue(class(fred_to_csv('GDPCA')) == "character")
