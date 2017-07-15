library(ggplot2) 
library(plotly)
library(colorspace) 
library(vcd) #mosaic
library(productplots) #geom_mosaic
library(data.table) # trabspose
library(formattable) # formattable
#########
testcluster <- meter_all[,15:21]
species_testcol <- rainbow_hcl(7)
pairs(testcluster,lower.panel = NULL,cex.labels = 2,pch=19,cex=1.2)


transposetest <- transpose(testcluster)
colnames(transposetest) <- rownames(testcluster)
rownames(transposetest) <- colnames(testcluster)

 res <- data.frame(rownames(transposetest),rowMeans(transposetest),apply(transposetest, 1, FUN=max),apply(transposetest, 1, FUN=sd))
 res1 <- data.frame(rowMeans(transposetest),apply(transposetest, 1, FUN=max),apply(transposetest, 1, FUN=sd))

 
 colnames(res) <- c("building","mean","max","sd")
 res$se <- res$sd/sqrt(n)
 colnames(res1) <- c("mean","max","sd")
 
 rownames(res) <- NULL
 #mosaic(as.matrix(res1))
 
 ######################################################
 library(plyr)
 library(ggthemes)

 
 res$building <- reorder(res$building , res$mean)
 
 q <- ggplot(res, aes(x = mean, xmin = mean-se, xmax = mean+se, y = building  )) +
   geom_point(aes(text=paste0("value: ",mean))) + 
   geom_segment( aes(x = mean-se, xend = mean+se,
                     y = building, yend=building)) +
   theme(axis.text=element_text(size=8)) +
   xlab("Mean Usage") + ylab("Building") 
 
 ggplotly(q, tooltip = "text") %>% config(displayModeBar = FALSE) %>% layout(xaxis=list(fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE))
 