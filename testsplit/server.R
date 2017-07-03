
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  observeEvent(input$do, {
    x <- as.character(input$daterange[1])
    y <- as.character(input$daterange[2])

    meter.all <- meter_all[(meter_all$DateTime>=x & meter_all$DateTime<=y),]
    meter.all <- head(meter.all,-1)
    
    output$ex1 <- DT::renderDataTable(
      DT::datatable(meter.all , options = list(pageLength = 25),rownames=FALSE)
    )

    
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
      my_format <- function (format = "%m-%d") {
        function(x) format(x, format)
      }
      
  
      ggplot(meter.all,main = input$dataset) + ggtitle(input$dataset) + ylab(input$dataset) +
        geom_line(aes(x = DateTime,y=meter.all[,input$dataset]),lwd=0.8) +
        geom_vline(data = weeks, 
                   aes(xintercept = as.numeric(w)),
                   color = 'grey55', size = 1) +
        scale_x_datetime(labels = my_format("%m-%d"),
                         breaks = date_breaks("days"),
                         minor_breaks = date_breaks("2 hour"),
                         expand = c(0,0),limits = c(as.POSIXct(input$daterange[1]),as.POSIXct(input$daterange[2]))) +
        theme(text = element_text(size=10),
              legend.text = element_text(size=10),
              panel.background = element_rect(fill = "white", colour = "black"),
              panel.grid.major.x = element_line(color = 'grey75', size = 0.2),
              panel.grid.minor.x = element_line(color = 'grey95', size = .05))
      
    })
    
    
    
    output$plot <- renderPlotly(
      print(ggplotly(plotInput())) %>% config(displayModeBar = FALSE)
    )
    output$summary <- renderPrint({
      
      summary(meter.all)
    })
    
    
  })
  
  output$ex2 <- DT::renderDataTable(
    DT::datatable(meter_all , options = list(pageLength = 25))
  )
  
})