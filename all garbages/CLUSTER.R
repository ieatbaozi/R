library(ggplot2) 
library(plotly)
library(colorspace) 
library(vcd) #mosaic
library(productplots) #geom_mosaic
library(data.table) # trabspose
library(formattable) # formattable
#########
source('~/R/work/testsplit/query.R')
x <- '2017-06-01'
y <- '2017-07-01'
x <- Sys.Date()-7
y <- Sys.Date() 

meter.all <- meter_all[(meter_all$DateTime>=x & meter_all$DateTime<=y),]
testcluster <- meter.all[,c(1,15:21)]
species_testcol <- rainbow_hcl(7)
pairs(testcluster, lower.panel = panel.smooth ,upper.panel = NULL ,cex.labels = 2,pch=19,cex=1.2)
todo <- testcluster[-1]
sumtopie <- colSums(todo)
gg <-  as.character( building_meter$building_meter)

colnames(topie) <- 'Sum'

pct <- round(sumtopie/sum(sumtopie)*100,digits = 2)
lbls <- paste(building_meter$building_meter, " : ",pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels
pie(sumtopie,labels = lbls, col=rainbow(length(lbls)))



 
#============


transposetest <- transpose(todo)
colnames(transposetest) <- rownames(testcluster)
rownames(transposetest) <- colnames(testcluster[-1])

 res <- data.frame(rownames(transposetest),rowMeans(transposetest),apply(transposetest, 1, FUN=max),apply(transposetest, 1, FUN=sd))
 res1 <- data.frame(rowMeans(transposetest),apply(transposetest, 1, FUN=max),apply(transposetest, 1, FUN=sd))
res2 <- data.frame(rowSums(transposetest))
 
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
 
 
 #######################################################
 

 
 summary(meter.all)
 
 vars.to.use <- colnames(testcluster)[-1]
 vars.to.use
 pmatrix <- scale(res2)
 pmatrix
 # keep some attr for later use
 #pcenter <- attr(pmatrix, "scaled:center")
 #pcenter
 #pscale <- attr(pmatrix, "scaled:scale")
 #pscale
 d <- dist(pmatrix, method = "euclidean")
 d
 print(d,digits=2)
 # note: name method name change
 pfit <- hclust(d, method = "ward.D2")
 pfit
 plot(pfit)
 rect.hclust(pfit, k=4)

 groups <- cutree(pfit, k=5)
 groups
 groups2 <- cutree(pfit, k=4)
 groups2
 print_clusters <- function(labels,k) {
   for(i in 1:k) {
     print(paste("cluster",i))
     print(protein[labels==i,c("Country","RedMeat","Fish","Fr.Veg")])
   }
 } 
 print_clusters(groups, 5)
 library(ggplot2)
 princ <- prcomp(pmatrix)
 nComp <- 2
 project <- predict(princ, newdata=pmatrix)[,1:nComp]
 project
 project.plus <- cbind(as.data.frame(project),
                       cluster=as.factor(groups),
                       country=protein$Country)
 project.plus
 ggplot(project.plus, aes(x=PC1,y=PC2)) +
   geom_point(aes(shape=cluster)) +
   geom_text(aes(label=country),
             hjust=0, vjust=1)
 library(fpc)
 kbest.p <- 5
 cboot.hclust <- clusterboot(pmatrix,clustermethod = hclustCBI,
                             method = "ward.D2", k=kbest.p)
 summary(cboot.hclust$result)
 groups <- cboot.hclust$result$partition
 print_clusters(groups, kbest.p)
 cboot.hclust$bootmean
 cboot.hclust$bootbrd
 