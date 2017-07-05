
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  observeEvent(input$do, {
    x <- as.character(input$daterange[1])
    y <- as.character(input$daterange[2])
    meter.all <- meter_all[(meter_all$DateTime>=x & meter_all$DateTime<=y),]
    
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
        geom_line(aes(x = DateTime,y=meter.all[,input$dataset]),lwd=0.8) +
        geom_vline(data = weeks, 
                   aes(xintercept = as.numeric(w)),
                   color = 'grey55', size = 1) +
        scale_x_datetime(labels = date_format("%m-%d"),
                         breaks = date_breaks("days"),
                         minor_breaks = date_breaks("2 hour"),
                         expand = c(0,0),limits = c(as.POSIXct(x,tz="Asia/Bangkok"),as.POSIXct(y,tz="Asia/Bangkok"))) +
        scale_y_continuous(expand = c(0, 0), limits = c(0, max(meter.all[,input$dataset])+1000)) +
        theme(text = element_text(size=10),
              axis.text.x = element_text(angle = 45, hjust = 1),
              legend.text = element_text(size=10),
              panel.background = element_rect(fill = "white", colour = "black"),
              panel.grid.major.x = element_line(color = 'grey75', size = 0.2),
              panel.grid.minor.x = element_line(color = 'grey95', size = .05))
    
      
    })
    
    
    
    output$plot <- renderPlotly(
      print(ggplotly(plotInput())) %>% config(displayModeBar = FALSE,xaxis = list(title="DateTime"))
    )
    output$summary <- renderPrint({
      
      summary(meter.all)
    })
    
    
  })
  
  output$ex2 <- renderDataTable(
      datatable(meter_show , options = list(pageLength = 25))
  )
  
})