#Power Meter
library(RODBC)
conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn
query.2weeks1_1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB1-1' and MIT..PowerMeterData.AddDate between (GETDATE()-14) and (GETDATE()) 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate)"
query.2weeks7_1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB7-1' and MIT..PowerMeterData.AddDate between (GETDATE()-14) and (GETDATE()) 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate)"

meter1_1faster <- sqlQuery(conn, query.2weeks1_1)
meter1_1used <- meter1_1faster[order(meter1_1faster$AddDate,decreasing=TRUE),]
temp1_1 <- c(0 ,abs(diff(meter1_1used$kWh)))
meter1_1used$diffkWh <- temp1_1
meter1_1used <- meter1_1used[-1,]
meter1_1used <- meter1_1used[,4:5]
rownames(meter1_1used) <- NULL
#=======================================#
meter7_1faster <- sqlQuery(conn, query.2weeks7_1)
meter7_1used <- meter7_1faster[order(meter7_1faster$AddDate,decreasing=TRUE),]
temp7_1 <- c(0 ,abs(diff(meter7_1used$kWh)))
meter7_1used$diffkWh <- temp7_1
meter7_1used <- meter7_1used[-1,]
meter7_1used <- meter7_1used[,4:5]
rownames(meter7_1used) <- NULL

library(xts)
library(zoo)
meter1_1used$AddDate <- align.time(meter1_1used$AddDate, n=60)
meter7_1used$AddDate <- align.time(meter7_1used$AddDate, n=60)
meter_all <- merge(meter1_1used, meter7_1used, by ="AddDate", all = TRUE, sort = TRUE)





#a new work : just report data
