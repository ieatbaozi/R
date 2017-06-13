library(RODBC)
library(lubridate)
conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn
query.all <- "select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
from MIT..PowerMeterData (NOLOCK) 
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB%' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
order by AddDate DESC "

data.all <- sqlQuery(conn, query.all)
odbcClose(conn)

data.all <- data.all[order(data.all$AddDate),]
colnames(data.all) <- c("PMMID","MeterName","kWh","DateTime")
second(data.all$DateTime) <- 0
name_meter <- data.frame()