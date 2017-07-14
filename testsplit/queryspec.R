
x <- as.character(Sys.Date())
y <- as.character(Sys.time())
a <- as.character(as.POSIXct(x))
b <- as.character(as.POSIXct(y))
m <- "412CP-02"

conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn

query.voltcurr <- paste0("select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,Voltage_L1_L2,Voltage_L2_L3,Voltage_L3_L1,Current_L1,Current_L2,Current_L3,MIT..PowerMeterData.AddDate
                    from MIT..PowerMeterData (NOLOCK) 
                         join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                         where MIT..PowerMeterMaster.MeterName like '",m,"' and MIT..PowerMeterData.AddDate between ('",x,"') and ('",b,"') 
                         order by AddDate DESC ")
data_voltcurr <- sqlQuery(conn, query.voltcurr)
odbcClose(conn)

data.voltcurr <- data_voltcurr[,c(9,3:8)]
colnames(data.voltcurr) <- c("DateTime","CurrL1","CurrL2","CurrL3","VoltL1_2","VoltL2_3","VoltL3_1")
second(data.voltcurr$DateTime) <- 0
