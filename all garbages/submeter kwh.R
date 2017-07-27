

conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn
query.all <- paste0("select MIT..PowerMeterMaster.MeterName,((kWh_import_H+kWh_import_L)/1000) as 'kWh',MIT..PowerMeterData.AddDate
                    from MIT..PowerMeterData (NOLOCK) 
                    join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                    where (MIT..PowerMeterMaster.MeterName like '",input$pickmeter,"' and MIT..PowerMeterData.AddDate between ('",input$date,"') and ('",paste0(as.Date(input$date)+days(1)," 01:59:59"),"') 
                    order by AddDate DESC")

data.all <- sqlQuery(conn, query.all)
odbcClose(conn)


colnames(data.daily) <- c("MeterName","kWh","DateTime")
data.daily <- data.daily[,2:3]

data.sub <- function(x){
  x %>% 
    mutate(DateTime = ymd_hms(DateTime), dt = as_date(DateTime), hr = hour(DateTime)) %>% 
    group_by(dt, hr) %>% 
    filter(DateTime == min(DateTime)) %>% 
    ungroup() %>% 
    select(DateTime, kWh)
}

data.daily <- as.data.frame(data.sub(data.daily))

second(data.daily$DateTime) <- 0
minute(data.daily$DateTime) <- 0

temp1 <- c(0 ,abs(diff(data.daily$kWh)))
data.daily$diffkWh <- temp1
data.daily <- data.daily[,-2]
colnames(data.daily)<- c("DateTime",input$pickmeter)
data.daily <- data.daily[-1,]

data.daily[input$pickmeter] <-
  lapply(data.daily[input$pickmeter], function(x){
    g <- cumsum(!is.na(x))
    ave(x, g, FUN = function(y) y[1] / length(y))
  })

write.csv(data.daily, file = paste0("submeter diffkWh ",input$date,".csv"),row.names=FALSE)


#############=============================================================================

m <- "MDB6-2"
l <- "2017-06-28"
o <- paste0(as.Date("2017-06-28")+days(1)," 01:59:59")

conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn

query.voltcurr <- paste0("select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,Voltage_L1_L2,Voltage_L2_L3,Voltage_L3_L1,Current_L1,Current_L2,Current_L3,MIT..PowerMeterData.AddDate,((kWh_import_H+kWh_import_L)/1000) as 'kWh'
                         from MIT..PowerMeterData (NOLOCK) 
                         join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                         where MIT..PowerMeterMaster.MeterName like '",m,"' and MIT..PowerMeterData.AddDate between ('",l,"') and ('",o,"') 
                         order by AddDate DESC ")
data_voltcurr <- sqlQuery(conn, query.voltcurr)
odbcClose(conn)
temp_data_voltcurr <- data_voltcurr
data_voltcurr <- data_voltcurr[,-10]

data.daily <- temp_data_voltcurr[,9:10]
colnames(data.daily) <- c("DateTime","kWh")
data.sub <- function(x){
  x %>% 
    mutate(DateTime = ymd_hms(DateTime), dt = as_date(DateTime), hr = hour(DateTime)) %>% 
    group_by(dt, hr) %>% 
    filter(DateTime == min(DateTime)) %>% 
    ungroup() %>% 
    select(DateTime, kWh)
}

data.daily <- as.data.frame(data.sub(data.daily))

second(data.daily$DateTime) <- 0
minute(data.daily$DateTime) <- 0

temp1 <- c(0 ,abs(diff(data.daily$kWh)))
data.daily$diffkWh <- temp1
data.daily <- data.daily[,-2]
colnames(data.daily)<- c("DateTime",m)
data.daily <- data.daily[-1,]

data.daily[m] <-
  lapply(data.daily[m], function(x){
    g <- cumsum(!is.na(x))
    ave(x, g, FUN = function(y) y[1] / length(y))
  })

