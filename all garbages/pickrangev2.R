library(RODBC)
library(lubridate)
library(dplyr)
library(ggplot2)
library(plotly)
library(scales)
conn <- odbcDriverConnect('Driver={SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
conn


x <- as.character("2017-06-01")
y <- as.character(Sys.time())
a <- as.character(as.POSIXct(x))
b <- as.character(as.POSIXct(y))
m <- "422DB-06"
query.voltcurr <- paste0("select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,Voltage_L1_L2,Voltage_L2_L3,Voltage_L3_L1,Current_L1,Current_L2,Current_L3,MIT..PowerMeterData.AddDate
                    from MIT..PowerMeterData (NOLOCK) 
                    join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                    where MIT..PowerMeterMaster.MeterName like '",m,"' and MIT..PowerMeterData.AddDate between ('",x,"') and ('",b,"') 
                    order by AddDate DESC ")
data_voltcurr <- sqlQuery(conn, query.voltcurr)
odbcClose(conn)

data.voltcurr <- data_voltcurr[,c(9,3:8)]
colnames(data.voltcurr) <- c("DateTime","VoltL1_2","VoltL2_3","VoltL3_1","CurrL1","CurrL2","CurrL3")
second(data.voltcurr$DateTime) <- 0

q <- ggplot(data.voltcurr, aes(DateTime)) + ylab(m) + ggtitle(m)+
  geom_line(aes(y = CurrL1, col = "CurrL1"),lwd=0.7) + 
  geom_line(aes(y = CurrL2, col = "CurrL2"),lwd=0.7) +
  geom_line(aes(y = CurrL3, col = "CurreL3"),lwd=0.7) +
  geom_line(aes(y = VoltL1_2, col = "VoltL1_2"),lwd=0.5) + 
  geom_line(aes(y = VoltL2_3, col = "VoltL2_3"),lwd=0.5) +
  geom_line(aes(y = VoltL3_1, col = "VoltL3_1"),lwd=0.5) +
  scale_x_datetime(labels = date_format("%m-%d %H:%M",tz="Asia/Bangkok"),expand = c(0,0)) +
  scale_y_continuous(expand = c(0,10))  +
  expand_limits( y = 0) +
  theme(text = element_text(size=9),
        axis.text.x = element_text(angle = 90, hjust = 1),
        legend.text = element_text(size=10),
        panel.background = element_rect(fill = "white", colour = "black"))
ggplotly(q) %>% config(displayModeBar = FALSE) %>% layout(xaxis=list(fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE))

write.csv(data.voltcurr, file = paste0("meter",m,".csv"),row.names=FALSE)
