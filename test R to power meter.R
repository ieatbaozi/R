#e.g.
#crimedat <- sqlFetch(myconn, "Crime")
#pundat <- sqlQuery(myconn, "select * from Punishment")

library(RODBC)
conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn

#data.master <- sqlFetch(conn,"PowerMeterMaster")
#data.scan <- sqlFetch(conn,"PowerMeterScan")
#data.master$PMMID <- as.factor(data.master$PMMID)
#data.master$MeterName <- as.factor(data.master$MeterName)
#data.master <- data.master[,c(1,3)]

testquery <- "select top 100 MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
 from MIT..PowerMeterData (NOLOCK) 
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB%'
order by AddDate DESC "

query.1month <- " select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
from MIT..PowerMeterData (NOLOCK) 
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB%' and MIT..PowerMeterData.AddDate between (DATEADD(yyyy, -1, GETDATE())) and (GETDATE()) 
order by AddDate DESC "

query.2weeks <- " select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
from MIT..PowerMeterData (NOLOCK) 
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB%' and MIT..PowerMeterData.AddDate between (GETDATE()-14) and (GETDATE()) 
order by AddDate DESC "

data.mastermeter <- sqlQuery(conn, "select * from MIT..PowerMeterMaster where MeterName like 'MDB%'")
data.mastermeter <- data.mastermeter[,c(1,3)]
data.mastermeter$PMMID <- as.factor(data.mastermeter$PMMID)
data.mastermeter$MeterName <- as.factor(data.mastermeter$MeterName)

#data.test <- sqlQuery(conn, query.1month)
data.test <- sqlQuery(conn, query.2weeks)

data.test1 <- data.test[(data.test$PMMID==25),]
meter7_1 <- data.test1[,c(3,4)]
rownames(meter7_1) <- NULL
as.factor(weekdays(meter7_1$AddDate))
meter7_1used <- subset(meter7_1,minute(meter7_1$AddDate)==0)
rownames(meter7_1used) <- NULL
abs(diff(meter7_1used$kWh))
temp <- c(0 ,abs(diff(meter7_1used$kWh)))
meter7_1used$diffkWh <- temp



meter7_1used_temp <- meter7_1used[(meter7_1used$diffkWh > 70),]
meter7_1used_temp <- meter7_1used_temp[(meter7_1used_temp$diffkWh <800 ),]
plot(x=meter7_1used_temp$AddDate,y=meter7_1used_temp$diffkWh)
