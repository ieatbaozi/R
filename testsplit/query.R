library(RODBC)
library(lubridate)
library(dplyr)
library(ggplot2)
library(plotly)
library(scales)
library(DT)
library(shiny)

start.date <- "2017-03-01"

conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn
query.all <- paste0("select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
                    from MIT..PowerMeterData (NOLOCK) 
                    join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                    where MIT..PowerMeterMaster.MeterName like 'MDB%' and MIT..PowerMeterData.AddDate between ('",start.date,"') and (GETDATE()) 
                    order by AddDate DESC ")

data.all <- sqlQuery(conn, query.all)
odbcClose(conn)


colnames(data.all) <- c("PMMID","MeterName","kWh","DateTime")

#data.all <- data.all[order(data.all$AddDate),]
meter.name <- c("MDB1-1", "MDB2-1", "MDB2-2", "MDB2-3", "MDB3-1", "MDB3-2", "MDB4-1", "MDB4-2", "MDB5-1", "MDB6-1", "MDB6-2", "MDB7-1", "MDB7-2")
meter.name <- as.data.frame(meter.name)
colnames(meter.name) <- "MeterName"
n <- 13

#data1 <- data.all[(data.all$MeterName=="MDB1-1"),]
for(i in 1:n){
  assign(paste0("data",i),data.all[(data.all$MeterName==meter.name$MeterName[i]),])
  
}

data1 <- data1[,3:4]
data2 <- data2[,3:4]
data3 <- data3[,3:4]
data4 <- data4[,3:4]
data5 <- data5[,3:4]
data6 <- data6[,3:4]
data7 <- data7[,3:4]
data8 <- data8[,3:4]
data9 <- data9[,3:4]
data10 <- data10[,3:4]
data11 <- data11[,3:4]
data12 <- data12[,3:4]
data13 <- data13[,3:4]

data.sub <- function(x){
  x %>% 
    mutate(DateTime = ymd_hms(DateTime), dt = as_date(DateTime), hr = hour(DateTime)) %>% 
    group_by(dt, hr) %>% 
    filter(DateTime == min(DateTime)) %>% 
    ungroup() %>% 
    select(DateTime, kWh)
}

data1 <- as.data.frame(data.sub(data1))
data2 <- as.data.frame(data.sub(data2))
data3 <- as.data.frame(data.sub(data3))
data4 <- as.data.frame(data.sub(data4))
data5 <- as.data.frame(data.sub(data5))
data6 <- as.data.frame(data.sub(data6))
data7 <- as.data.frame(data.sub(data7))
data8 <- as.data.frame(data.sub(data8))
data9 <- as.data.frame(data.sub(data9))
data10 <- as.data.frame(data.sub(data10))
data11 <- as.data.frame(data.sub(data11))
data12 <- as.data.frame(data.sub(data12))
data13 <- as.data.frame(data.sub(data13))

second(data1$DateTime) <- 0
second(data2$DateTime) <- 0
second(data3$DateTime) <- 0
second(data4$DateTime) <- 0
second(data5$DateTime) <- 0
second(data6$DateTime) <- 0
second(data7$DateTime) <- 0
second(data8$DateTime) <- 0
second(data9$DateTime) <- 0
second(data10$DateTime) <- 0
second(data11$DateTime) <- 0
second(data12$DateTime) <- 0
second(data13$DateTime) <- 0
minute(data1$DateTime) <- 0
minute(data2$DateTime) <- 0
minute(data3$DateTime) <- 0
minute(data4$DateTime) <- 0
minute(data5$DateTime) <- 0
minute(data6$DateTime) <- 0
minute(data7$DateTime) <- 0
minute(data8$DateTime) <- 0
minute(data9$DateTime) <- 0
minute(data10$DateTime) <- 0
minute(data11$DateTime) <- 0
minute(data12$DateTime) <- 0
minute(data13$DateTime) <- 0

temp1 <- c(0 ,abs(diff(data1$kWh)))
data1$diffkWh <- temp1
data1 <- data1[,-2]
temp2 <- c(0 ,abs(diff(data2$kWh)))
data2$diffkWh <- temp2
data2 <- data2[,-2]
temp3 <- c(0 ,abs(diff(data3$kWh)))
data3$diffkWh <- temp3
data3 <- data3[,-2]
temp4 <- c(0 ,abs(diff(data4$kWh)))
data4$diffkWh <- temp4
data4 <- data4[,-2]
temp5 <- c(0 ,abs(diff(data5$kWh)))
data5$diffkWh <- temp5
data5 <- data5[,-2]
temp6 <- c(0 ,abs(diff(data6$kWh)))
data6$diffkWh <- temp6
data6 <- data6[,-2]
temp7 <- c(0 ,abs(diff(data7$kWh)))
data7$diffkWh <- temp7
data7 <- data7[,-2]
temp8 <- c(0 ,abs(diff(data8$kWh)))
data8$diffkWh <- temp8
data8 <- data8[,-2]
temp9 <- c(0 ,abs(diff(data9$kWh)))
data9$diffkWh <- temp9
data9 <- data9[,-2]
temp10 <- c(0 ,abs(diff(data10$kWh)))
data10$diffkWh <- temp10
data10 <- data10[,-2]
temp11 <- c(0 ,abs(diff(data11$kWh)))
data11$diffkWh <- temp11
data11 <- data11[,-2]
temp12 <- c(0 ,abs(diff(data12$kWh)))
data12$diffkWh <- temp12
data12 <- data12[,-2]
temp13 <- c(0 ,abs(diff(data13$kWh)))
data13$diffkWh <- temp13
data13 <- data13[,-2]



colnames(data1)<- c("DateTime","MDB1-1")
colnames(data2)<- c("DateTime","MDB2-1")
colnames(data3)<- c("DateTime","MDB2-2")
colnames(data4)<- c("DateTime","MDB2-3")
colnames(data5)<- c("DateTime","MDB3-1")
colnames(data6)<- c("DateTime","MDB3-2")
colnames(data7)<- c("DateTime","MDB4-1")
colnames(data8)<- c("DateTime","MDB4-2")
colnames(data9)<- c("DateTime","MDB5-1")
colnames(data10)<- c("DateTime","MDB6-1")
colnames(data11)<- c("DateTime","MDB6-2")
colnames(data12)<- c("DateTime","MDB7-1")
colnames(data13)<- c("DateTime","MDB7-2")

meter_all <- merge(data1, data2, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data3, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data4, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data5, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data6, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data7, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data8, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data9, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data10, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data11, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data12, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data13, by ="DateTime", all = TRUE, sort = TRUE)

c_meter <- c('MDB1-1','MDB2-1','MDB2-2','MDB2-3','MDB3-1','MDB3-2','MDB4-1','MDB4-2','MDB5-1','MDB6-1','MDB6-2','MDB7-1','MDB7-2')
meter_all[c_meter] <-
  lapply(meter_all[c_meter], function(x){
    g <- cumsum(!is.na(x))
    ave(x, g, FUN = function(y) y[1] / length(y))
  })

building_meter <-  c('Building1','Building2','Building3','Building4','Building5','Building6','Building7')

meter_all$Building1 <- meter_all[,'MDB1-1']
meter_all$Building2 <- rowSums(meter_all[,c('MDB2-1','MDB2-2')], na.rm = TRUE, dims = 1)
meter_all$Building3 <- rowSums(meter_all[,c('MDB3-1','MDB3-2')], na.rm = TRUE, dims = 1)
meter_all$Building4 <- rowSums(meter_all[,c('MDB4-1','MDB4-2')], na.rm = TRUE, dims = 1)
meter_all$Building5 <- meter_all[,'MDB5-1']
meter_all$Building6 <- rowSums(meter_all[,c('MDB6-1','MDB6-2')], na.rm = TRUE, dims = 1)
meter_all$Building7 <- rowSums(meter_all[,c('MDB7-1','MDB7-2')], na.rm = TRUE, dims = 1)
meter_all$TotalPower <- rowSums(meter_all[,building_meter], na.rm = TRUE, dims = 1)
tz(meter_all$DateTime) <- "Asia/Bangkok"
weeks <- data.frame(w = seq(min(meter_all$DateTime[weekdays(meter_all$DateTime)=='Monday']), max(meter_all$DateTime[weekdays(meter_all$DateTime)=='Monday']), 'week'))

