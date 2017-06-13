library(RODBC)
library(lubridate)
conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn
#csv task 5-12/06
query1.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB1-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query2.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB2-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query2.2 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB2-2' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query2.3 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB2-3' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query3.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB3-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query3.2 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB3-2' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query4.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB4-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query4.2 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB4-2' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query5.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB5-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query6.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB6-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query6.2 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB6-2' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query7.1 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB7-1' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "
query7.2 <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate as 'DateTime'
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB7-2' and MIT..PowerMeterData.AddDate between ('2017-06-05') and ('2017-06-12') 
ORDER BY
row_number()over 
(partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate ) "

data1.1 <- sqlQuery(conn, query1.1)
data2.1 <- sqlQuery(conn, query2.1)
data2.2 <- sqlQuery(conn, query2.2)
data2.3 <- sqlQuery(conn, query2.3)
data3.1 <- sqlQuery(conn, query3.1)
data3.2 <- sqlQuery(conn, query3.2)
data4.1 <- sqlQuery(conn, query4.1)
data4.2 <- sqlQuery(conn, query4.2)
data5.1 <- sqlQuery(conn, query5.1)
data6.1 <- sqlQuery(conn, query6.1)
data6.2 <- sqlQuery(conn, query6.2)
data7.1 <- sqlQuery(conn, query7.1)
data7.2 <- sqlQuery(conn, query7.2)

minute(data1.1$DateTime) <- 0
minute(data2.1$DateTime) <- 0
minute(data3.1$DateTime) <- 0
minute(data4.1$DateTime) <- 0
minute(data5.1$DateTime) <- 0
minute(data6.1$DateTime) <- 0
minute(data7.1$DateTime) <- 0
minute(data2.2$DateTime) <- 0
minute(data3.2$DateTime) <- 0
minute(data4.2$DateTime) <- 0
minute(data6.2$DateTime) <- 0
minute(data7.2$DateTime) <- 0
minute(data2.3$DateTime) <- 0
second(data1.1$DateTime) <- 0
second(data2.1$DateTime) <- 0
second(data3.1$DateTime) <- 0
second(data4.1$DateTime) <- 0
second(data5.1$DateTime) <- 0
second(data6.1$DateTime) <- 0
second(data7.1$DateTime) <- 0
second(data2.2$DateTime) <- 0
second(data3.2$DateTime) <- 0
second(data4.2$DateTime) <- 0
second(data6.2$DateTime) <- 0
second(data7.2$DateTime) <- 0
second(data2.3$DateTime) <- 0

temp1.1 <- c(0 ,abs(diff(data1.1$kWh)))
data1.1$diffkWh <- temp1.1
data1.1 <- data1.1[,4:5]
temp2.1 <- c(0 ,abs(diff(data2.1$kWh)))
data2.1$diffkWh <- temp2.1
data2.1 <- data2.1[,4:5]
temp2.2 <- c(0 ,abs(diff(data2.2$kWh)))
data2.2$diffkWh <- temp2.2
data2.2 <- data2.2[,4:5]
temp2.3 <- c(0 ,abs(diff(data2.3$kWh)))
data2.3$diffkWh <- temp2.3
data2.3 <- data2.3[,4:5]
temp3.1 <- c(0 ,abs(diff(data3.1$kWh)))
data3.1$diffkWh <- temp3.1
data3.1 <- data3.1[,4:5]
temp3.2 <- c(0 ,abs(diff(data3.2$kWh)))
data3.2$diffkWh <- temp3.2
data3.2 <- data3.2[,4:5]
temp4.1 <- c(0 ,abs(diff(data4.1$kWh)))
data4.1$diffkWh <- temp4.1
data4.1 <- data4.1[,4:5]
temp4.2 <- c(0 ,abs(diff(data4.2$kWh)))
data4.2$diffkWh <- temp4.2
data4.2 <- data4.2[,4:5]
temp5.1 <- c(0 ,abs(diff(data5.1$kWh)))
data5.1$diffkWh <- temp5.1
data5.1 <- data5.1[,4:5]
temp6.1 <- c(0 ,abs(diff(data6.1$kWh)))
data6.1$diffkWh <- temp6.1
data6.1 <- data6.1[,4:5]
temp6.2 <- c(0 ,abs(diff(data6.2$kWh)))
data6.2$diffkWh <- temp6.2
data6.2 <- data6.2[,4:5]
temp7.1 <- c(0 ,abs(diff(data7.1$kWh)))
data7.1$diffkWh <- temp7.1
data7.1 <- data7.1[,4:5]
temp7.2 <- c(0 ,abs(diff(data7.2$kWh)))
data7.2$diffkWh <- temp7.2
data7.2 <- data7.2[,4:5]

colnames(data1.1)<- c("DateTime","MDB1-1")
colnames(data2.1)<- c("DateTime","MDB2-1")
colnames(data2.2)<- c("DateTime","MDB2-2")
colnames(data2.3)<- c("DateTime","MDB2-3")
colnames(data3.1)<- c("DateTime","MDB3-1")
colnames(data3.2)<- c("DateTime","MDB3-2")
colnames(data4.1)<- c("DateTime","MDB4-1")
colnames(data4.2)<- c("DateTime","MDB4-2")
colnames(data5.1)<- c("DateTime","MDB5-1")
colnames(data6.1)<- c("DateTime","MDB6-1")
colnames(data6.2)<- c("DateTime","MDB6-2")
colnames(data7.1)<- c("DateTime","MDB7-1")
colnames(data7.2)<- c("DateTime","MDB7-2")
meter_all <- merge(data1.1, data2.1, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data2.2, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data2.3, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data3.1, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data3.2, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data4.1, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data4.2, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data5.1, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data6.1, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data6.2, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data7.1, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data7.2, by ="DateTime", all = TRUE, sort = TRUE)

meter_all_temp <- meter_all[,-1]
meter_all$TotalPower <- rowSums(meter_all_temp, na.rm = TRUE, dims = 1)
write.csv(meter_all, file = "Report_5to12_06.csv",row.names=FALSE)
