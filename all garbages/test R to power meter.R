#e.g.
#crimedat <- sqlFetch(myconn, "Crime")
#pundat <- sqlQuery(myconn, "select * from Punishment")

test.db <- function(){

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
where MIT..PowerMeterMaster.MeterName like 'MDB%' and MIT..PowerMeterData.AddDate between (GETDATE()-30) and (GETDATE())  
order by AddDate DESC "

query.3weeks <- " select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
from MIT..PowerMeterData (NOLOCK) 
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB%' and MIT..PowerMeterData.AddDate between (GETDATE()-21) and (GETDATE()) 
order by AddDate DESC "


query.2weeksfaster <- "SELECT TOP 1 WITH TIES MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
FROM MIT..PowerMeterData (NOLOCK)
join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
where MIT..PowerMeterMaster.MeterName like 'MDB7-1' and MIT..PowerMeterData.AddDate between (GETDATE()-14) and (GETDATE()) 
ORDER BY
  row_number()over 
    (partition by dateadd(hour, datediff(hour, 0, MIT..PowerMeterData.AddDate),0) ORDER BY MIT..PowerMeterData.AddDate)"


#data.mastermeter <- sqlQuery(conn, "select * from MIT..PowerMeterMaster where MeterName like 'MDB%'")
#data.mastermeter <- data.mastermeter[,c(1,3)]
#data.mastermeter$PMMID <- as.factor(data.mastermeter$PMMID)
#data.mastermeter$MeterName <- as.factor(data.mastermeter$MeterName)


data.test <- sqlQuery(conn, query.1month)
#=======================================#
meter1_1faster <- sqlQuery(conn, query.2weeksfaster)
#meter1_1faster <- data.test[data.test$MeterName == 'MDB1-1',]
meter1_1used <- meter1_1faster[order(meter1_1faster$AddDate,decreasing=TRUE),]
temp1_1 <- c(0 ,abs(diff(meter1_1used$kWh)))
meter1_1used$diffkWh <- temp1_1
meter1_1used <- meter1_1used[-1,]
meter1_1used <- meter1_1used[,4:5]
rownames(meter1_1used) <- NULL
#=======================================#
meter7_1faster <- sqlQuery(conn, query.2weeksfaster)
#meter7_1faster <- data.test[data.test$MeterName == 'MDB7-1',]
meter7_1used <- meter7_1faster[order(meter7_1faster$AddDate,decreasing=TRUE),]
temp7_1 <- c(0 ,abs(diff(meter7_1used$kWh)))
meter7_1used$diffkWh <- temp7_1
meter7_1used <- meter7_1used[-1,]
meter7_1used <- meter7_1used[,4:5]
rownames(meter7_1used) <- NULL






#########################################################################
data.test7_1 <- data.test[(data.test$PMMID==25),]
meter7_1 <- data.test7_1[,c(3,4)]
rownames(meter7_1) <- NULL
library(lubridate)
meter7_1used <- subset(meter7_1,minute(meter7_1$AddDate)==0)
rownames(meter7_1used) <- NULL
temp7_1 <- c(0 ,abs(diff(meter7_1used$kWh)))
meter7_1used$diffkWh <- temp7_1
#meter7_1used$weekday <- as.factor(weekdays(meter7_1used$AddDate))
meter7_1used <- meter7_1used[-1,]
colnames(meter7_1) <- NULL
meter7_1used <- meter7_1used[,-1]
#########################################################################
data.test1_1 <- data.test[(data.test$PMMID==28),]
meter1_1 <- data.test1_1[,c(3,4)]
rownames(meter1_1) <- NULL
library(lubridate)
meter1_1used <- subset(meter1_1,minute(meter1_1$AddDate)==0)
rownames(meter1_1used) <- NULL
temp1_1 <- c(0 ,abs(diff(meter1_1used$kWh)))
meter1_1used$diffkWh <- temp1_1
#meter1_1used$weekday <- as.factor(weekdays(meter1_1used$AddDate))
meter1_1used <- meter1_1used[-1,]
colnames(meter1_1) <- NULL
meter1_1used <- meter1_1used[,-1]
#########################################################################
library(xts)
library(zoo)
meter1_1used$AddDate <- align.time(meter1_1used$AddDate, n=60)
meter7_1used$AddDate <- align.time(meter7_1used$AddDate, n=60)

meter_all <- merge(meter1_1used, meter7_1used, by ="AddDate", all = FALSE, sort = TRUE)
colnames(meter_all) <- c("Date","diff1_1",'diff7_1')

meter_all$diffkWh.x <- ifelse((meter_all$diffkWh.x>1300|meter_all$diffkWh.x>1300), NA,meter_all$diffkWh.x)
meter_all$diffkWh.x <- na.approx(meter_all$diffkWh.x)
meter_all$diffkWh.x <- na.approx(meter_all$diffkWh.y)

odbcClose(conn)

}

test.plot <- function(){

library(ggplot2)
library(scales)
#meter7_1used_temp <- meter7_1used[(meter7_1used$diffkWh > 70),]
#meter7_1used_temp <- meter7_1used_temp[(meter7_1used_temp$diffkWh <800 ),]
rects <- data.frame(xstart = as.POSIXct('2017-06-04 00:00:00'), xend = as.POSIXct('2017-06-5 00:00:00'))
#geom_rect(data = meter7_1used, aes(xmin = rects$xstart, xmax = rects$xend, ymin = -Inf, ymax = Inf), alpha = 0.4)
}
#ggplot(meter7_1used, aes(x=meter7_1used$AddDate,y=meter7_1used$diffkWh, color=ifelse(((meter7_1used$diffkWh>520)),"bad", "good"))) + scale_color_manual(guide=FALSE, values=c("red", "black")) + geom_point() + scale_x_datetime(labels = date_format("%m-%d"), breaks = date_breaks("days")) + theme(axis.text.x = element_text(angle = 45)) + geom_rect(data = meter7_1used, aes(xmin = rects$xstart, xmax = rects$xend, ymin = -Inf, ymax = Inf), alpha = 0.4) + geom_line()
ggplot(meter1_1used, aes(x=meter1_1used$AddDate,y=meter1_1used$diffkWh)) + scale_x_datetime(labels = date_format("%m-%d"), breaks = date_breaks("days")) + theme(axis.text.x = element_text(angle = 45)) + geom_line()

weekday.partmean <- aggregate( meter7_1used$diffkWh ~ meter7_1used$weekday , meter7_1used , mean )
ggplot(meter7_1used, aes(x=meter7_1used$AddDate,y=meter7_1used$diffkWh, color=ifelse(((meter7_1used$diffkWh>560)),"bad", "good"))) + scale_color_manual(guide=FALSE, values=c("red", "black")) + geom_point() + scale_x_datetime(labels = date_format("%m-%d"), breaks = date_breaks("days")) + theme(axis.text.x = element_text(angle = 45))
