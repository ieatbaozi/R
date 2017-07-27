

conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn
query.all <- paste0("select MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
                             from MIT..PowerMeterData (NOLOCK) 
                         join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                         where (MIT..PowerMeterMaster.MeterName like '111AC-01' or MIT..PowerMeterMaster.MeterName like '111AC-03' or MIT..PowerMeterMaster.MeterName like '121AC-05' or MIT..PowerMeterMaster.MeterName like '121AC-07') and MIT..PowerMeterData.AddDate between ('2017-06-28') and ('2017-06-30 01:059:59') 
                         order by AddDate DESC")

data.all <- sqlQuery(conn, query.all)
odbcClose(conn)


colnames(data.all) <- c("MeterName","kWh","DateTime")

#data.all <- data.all[order(data.all$AddDate),]
metername <- c("111AC-01", "111AC-03", "121AC-05" , "121AC-07")
meter.name <- as.data.frame(metername,stringsAsFactors =FALSE)
colnames(meter.name) <- "MeterName"
n <- 4

#data1 <- data.all[(data.all$MeterName=="MDB1-1"),]
for(i in 1:n){
  assign(paste0("data",i),data.all[(data.all$MeterName==meter.name$MeterName[i]),])
  
}

data1 <- data1[,2:3]
data2 <- data2[,2:3]
data3 <- data3[,2:3]
data4 <- data4[,2:3]


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

second(data1$DateTime) <- 0
second(data2$DateTime) <- 0
second(data3$DateTime) <- 0
second(data4$DateTime) <- 0

minute(data1$DateTime) <- 0
minute(data2$DateTime) <- 0
minute(data3$DateTime) <- 0
minute(data4$DateTime) <- 0


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




colnames(data1)<- c("DateTime",meter.name$MeterName[1])
colnames(data2)<- c("DateTime",meter.name$MeterName[2])
colnames(data3)<- c("DateTime",meter.name$MeterName[3])
colnames(data4)<- c("DateTime",meter.name$MeterName[4])

meter_all <- merge(data1, data2, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data3, by ="DateTime", all = TRUE, sort = TRUE)
meter_all <- merge(meter_all, data4, by ="DateTime", all = TRUE, sort = TRUE)

meter_all <- head(meter_all,-1)

meter_all[metername] <-
  lapply(meter_all[metername], function(x){
    g <- cumsum(!is.na(x))
    ave(x, g, FUN = function(y) y[1] / length(y))
  })

write.csv(meter_all, file = paste0("submeter_28_29_Jun.csv"),row.names=FALSE)
