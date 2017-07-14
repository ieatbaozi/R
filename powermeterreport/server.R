library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  observeEvent(input$do, {
    x <- as.character(input$daterange[1])
    y <- as.character(input$daterange[2])
    meter.all <- meter_all[(meter_all$DateTime>=x & meter_all$DateTime<=y),]
    #meter.all$showTime <- as.character(as.POSIXct(meter.all$DateTime,format = "%Y-%m-%d %H:%M"))
    
    meter.show <- meter.all
    meter.show$DateTime  <- as.POSIXct(as.character(meter.all$DateTime), tz="UTC")
    output$ex1 <- renderDataTable( datatable(meter.show , options = list(pageLength = 25), rownames = FALSE )  )
     
    
    output$downloadData <- downloadHandler(
      filename = function() { paste0('report',x,'to',y,'.csv') },
      content = function(file) {
        write.csv(meter.all, file,row.names = FALSE)
      }
    )
    
    output$downloadPlot <- downloadHandler(
      filename = function() { paste0('report',x,'to',y,'.png') },
      content = function(file) {
        device <- function(..., width, height) grDevices::png(..., width = 1280 , height = 680, res = 100 , units = "px")
        ggsave(file, plot = plotInput(), device = device)
      }
    )
    
    
    
    plotInput <- reactive({
    
      ggplot(meter.all,main = input$dataset) + ggtitle(input$dataset) + ylab(input$dataset) +
        geom_line(aes(x = DateTime ,y=meter.all[,input$dataset] ,text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.8) +
        geom_vline(data = weeks, 
                   aes(xintercept = as.numeric(w)),
                   color = 'grey55', size = 1) +
        scale_x_datetime(labels = date_format("%m-%d"),
                         breaks = date_breaks("days"),
                         minor_breaks = date_breaks("2 hour"),
                         expand = c(0,0),limits = c(as.POSIXct(x,tz="Asia/Bangkok"),as.POSIXct(y,tz="Asia/Bangkok"))) +
        expand_limits( y = 0) +
        theme(text = element_text(size=9),
              axis.text.x = element_text(angle = 45, hjust = 1),
              legend.text = element_text(size=10),
              panel.background = element_rect(fill = "white", colour = "black"),
              panel.grid.major.x = element_line(color = 'grey75', size = 0.2),
              panel.grid.minor.x = element_line(color = 'grey85', size = 0.1))
    
      
    })
    
    
    
    output$plot <- renderPlotly(
      print(ggplotly(plotInput(), tooltip = c("y","text"))) %>% config(displayModeBar = FALSE) %>% layout(xaxis=list(fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE))
      
    )
    output$summary <- renderPrint({
      
      summary(meter.all)
    })
    
    
  })
  
  #========== part Curr-Volt
  
  observeEvent(input$dospec,{
    #can't use source file to react
    
    
    a <-  as.character(paste0(input$date," ",strftime(input$time_input1, "%T")))
    b <-  as.character(paste0(input$date," ",strftime(input$time_input2, "%T")))
    m <- input$pickmeter
    l <- input$date
    o <- paste0(as.Date(input$date)+days(1)," 01:59:59")
    
    conn <- odbcDriverConnect('Driver={ODBC Driver 13 for SQL Server};Server=10.17.127.17;Database=MIT;Uid=sqlreader;Pwd=sqlReader')
    conn
    #ODBC Driver 13 for SQL Server
    query.voltcurr <- paste0("select MIT..PowerMeterData.PMMID,MIT..PowerMeterMaster.MeterName,Voltage_L1_L2,Voltage_L2_L3,Voltage_L3_L1,Current_L1,Current_L2,Current_L3,MIT..PowerMeterData.AddDate,((kWh_import_H+kWh_import_L)/1000) as 'kWh'
                             from MIT..PowerMeterData (NOLOCK) 
                             join MIT..PowerMeterMaster (NOLOCK) on MIT..PowerMeterData.PMMID = MIT..PowerMeterMaster.PMMID 
                             where MIT..PowerMeterMaster.MeterName like '",m,"' and MIT..PowerMeterData.AddDate between ('",l,"') and ('",o,"') 
                             order by AddDate DESC ")
    data_voltcurr <- sqlQuery(conn, query.voltcurr)
    odbcClose(conn)
    temp_data_voltcurr <- data_voltcurr
    data_voltcurr <- data_voltcurr[,-10]
    ################
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
    
    ################
    data.voltcurr <- data_voltcurr[,c(9,3:8)]
    colnames(data.voltcurr) <- c("DateTime","VoltL1_2","VoltL2_3","VoltL3_1","CurrL1","CurrL2","CurrL3")
    data.voltcurr <- data.voltcurr[(data.voltcurr$DateTime>=a & data.voltcurr$DateTime<=b),]
    second(data.voltcurr$DateTime) <- 0
   
    #_______________
    
    plotInputspec <- reactive({
      
      ggplot(data.voltcurr, aes(DateTime)) + ylab(m) + ggtitle(m)+
        geom_line(aes(y = CurrL1, col = "CurrL1",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.7) + 
        geom_line(aes(y = CurrL2, col = "CurrL2",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.7) +
        geom_line(aes(y = CurrL3, col = "CurrL3",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.7) +
        geom_line(aes(y = VoltL1_2, col = "VoltL1_2",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.5) + 
        geom_line(aes(y = VoltL2_3, col = "VoltL2_3",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.5) +
        geom_line(aes(y = VoltL3_1, col = "VoltL3_1",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.5) +
        scale_x_datetime(labels = date_format("%m-%d %H:%M",tz="Asia/Bangkok"),breaks = date_breaks("2 hour"),expand = c(0,0),limits = c(as.POSIXct(a,tz="Asia/Bangkok"),as.POSIXct(b,tz="Asia/Bangkok"))) +
        scale_y_continuous(expand = c(0,10))  +
       # expand_limits( y = 0) +
        theme(text = element_text(size=9),
              axis.text.x = element_text(angle = 90, hjust = 1),
              legend.text = element_text(size=10),
              panel.background = element_rect(fill = "white", colour = "black"),
              panel.grid.major.x = element_line(color = 'grey75', size = 0.2))
    })
    plotInputspecCurr <- reactive({
      
      ggplot(data.voltcurr, aes(DateTime)) + ylab("Current") + ggtitle(m)+
        geom_line(aes(y = CurrL1, col = "CurrL1",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.7) + 
        geom_line(aes(y = CurrL2, col = "CurrL2",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.7) +
        geom_line(aes(y = CurrL3, col = "CurrL3",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.7) +
        scale_x_datetime(labels = date_format("%m-%d %H:%M",tz="Asia/Bangkok"),breaks = date_breaks("2 hour"),expand = c(0,0),limits = c(as.POSIXct(a,tz="Asia/Bangkok"),as.POSIXct(b,tz="Asia/Bangkok"))) +
        scale_y_continuous(expand = c(0,10))  +
        # expand_limits( y = 0) +
        theme(text = element_text(size=9),
              axis.text.x = element_text(angle = 90, hjust = 1),
              legend.text = element_text(size=10),
              panel.background = element_rect(fill = "white", colour = "black"),
              panel.grid.major.x = element_line(color = 'grey75', size = 0.2))
    })
    plotInputspecVolt <- reactive({
      
      ggplot(data.voltcurr, aes(DateTime)) + ylab("Voltage") + ggtitle(m)+
        geom_line(aes(y = VoltL1_2, col = "VoltL1_2",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.5) + 
        geom_line(aes(y = VoltL2_3, col = "VoltL2_3",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.5) +
        geom_line(aes(y = VoltL3_1, col = "VoltL3_1",text = paste("DateTime:", format(DateTime, "%b-%d %A  %T")), group = 1),lwd=0.5) +
        scale_x_datetime(labels = date_format("%m-%d %H:%M",tz="Asia/Bangkok"),breaks = date_breaks("2 hour"),expand = c(0,0),limits = c(as.POSIXct(a,tz="Asia/Bangkok"),as.POSIXct(b,tz="Asia/Bangkok"))) +
        scale_y_continuous(expand = c(0,10))  +
        # expand_limits( y = 0) +
        theme(text = element_text(size=9),
              axis.text.x = element_text(angle = 90, hjust = 1),
              legend.text = element_text(size=10),
              panel.background = element_rect(fill = "white", colour = "black"),
              panel.grid.major.x = element_line(color = 'grey75', size = 0.2))
    })
    
    
    
    
    
    
    output$plotspec <- renderPlotly(
     print(ggplotly(plotInputspec(), tooltip = c("y","text")) %>% config(displayModeBar = FALSE) %>% layout(xaxis=list(fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE)))
       )
    
    output$plotspecCurr <- renderPlotly(
      print(ggplotly(plotInputspecCurr(), tooltip = c("y","text")) %>% config(displayModeBar = FALSE) %>% layout(xaxis=list(fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE)))
    )
    
    output$plotspecVolt <- renderPlotly(
      print(ggplotly(plotInputspecVolt(), tooltip = c("y","text")) %>% config(displayModeBar = FALSE) %>% layout(xaxis=list(fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE)))
    )
    
    output$summaryspec <- renderPrint({
      summary(data.voltcurr)
    })
    
    output$downloadDataspec <- downloadHandler(
      filename = function() { paste0("V-C ",m," ",n,".csv") },
      content = function(file) {
        write.csv(data.voltcurr, file,row.names = FALSE)
      }
    )
    
    output$downloadPlotspec <- downloadHandler(
      filename = function() { paste0("V-C ",m," ",n,".png") },
      content = function(file) {
        device <- function(..., width, height) grDevices::png(..., width = 1280 , height = 680, res = 100 , units = "px")
        ggsave(file, plot = plotInputspec(), device = device)
      }
    )
    
    output$downloadDataDaily <- downloadHandler(
      filename = function() { paste0("submeter diffkWh ",input$date,".csv") },
      content = function(file) {
        write.csv(data.daily, file,row.names = FALSE)
      }
    )
    
  })

  #==========
  
  output$ex2 <- renderDataTable(
      datatable(meter_show , options = list(pageLength = 25))
  )
  
})
