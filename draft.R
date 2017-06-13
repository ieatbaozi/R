df <- read.table(text="Date; diffVal1; diffVal2
1;  2017-05-31 04:01:00;      718;      483
                 2;  2017-05-31 05:01:00;      704;      477
                 3;  2017-05-31 06:01:00;      741;      478
                 4;  2017-05-31 07:01:00;      874;      483
                 5;  2017-05-31 08:01:00;      907;      495
                 6;  2017-05-31 09:01:00;      887;      510
                 7;  2017-05-31 10:01:00;     2922;      514
                 8;  2017-05-31 13:01:00;     1012;      529
                 9;  2017-05-31 14:01:00;      979;      539
                 10; 2017-05-31 15:01:00;      886;      485
                 11; 2017-05-31 16:01:00;      818;      471",sep=";",header=TRUE,stringsAsFactors=FALSE)

meter_all$AddDate <- as.POSIXct(meter_all$AddDate)
all_dates <- data.frame(Date = seq(min(meter_all$AddDate),max(meter_all$AddDate),by=3600))

df <- meter_all
df <- df[order(df$Date,decreasing=TRUE),]
df$diff1_1_total <-  cumsum(df$diff1_1)
#df <- merge(df,all_dates,all.y = TRUE)

df$diff1_1_total[is.na(df$diff1_1_total)] <- approx(x = df$Date, y = df$diff1_1_total, xout = df$Date[is.na(df$diff1_1_total)])$y
df$diff1_1 <- c(-diff(df$diff1_1_total),tail(df$diff1_1,1))


