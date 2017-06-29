building_meter <-  c('Building1','Building2','Building3','Building4','Building5','Building6','Building7')

meter_all$Building1 <- meter_all[,'MDB1-1']
meter_all$Building2 <- rowSums(meter_all[,c('MDB2-1','MDB2-2')], na.rm = TRUE, dims = 1)
meter_all$Building3 <- rowSums(meter_all[,c('MDB3-1','MDB3-2')], na.rm = TRUE, dims = 1)
meter_all$Building4 <- rowSums(meter_all[,c('MDB4-1','MDB4-2')], na.rm = TRUE, dims = 1)
meter_all$Building5 <- meter_all[,'MDB5-1']
meter_all$Building6 <- rowSums(meter_all[,c('MDB6-1','MDB6-2')], na.rm = TRUE, dims = 1)
meter_all$Building7 <- rowSums(meter_all[,c('MDB7-1','MDB7-2')], na.rm = TRUE, dims = 1)
meter_all$TotalPower <- rowSums(meter_all[,building_meter], na.rm = TRUE, dims = 1)
