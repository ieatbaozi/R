
library(shiny)

test.db()

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Testing Power Meter Displaying"),
    

      
      # Show a plot of the generated distribution
      mainPanel(
       
        navbarPage(
          title = 'DataTable Options',
          tabPanel('Display length',     DT::dataTableOutput('ex1')),
          tabPanel('Test plot', plotOutput("plot"))
        )
      )
   
)

test.plot()

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$ex1 <- DT::renderDataTable(
    DT::datatable(meter7_1used , options = list(pageLength = 10))
  )
  
  output$plot <- renderPlot({
    p + scale_x_datetime(labels = date_format("%m-%d"), breaks = date_breaks("days")) + theme(axis.text.x = element_text(angle = 45)) + geom_rect(data = meter7_1used, aes(xmin = rects$xstart, xmax = rects$xend, ymin = -Inf, ymax = Inf), alpha = 0.4) + geom_line()
    
  })

  
}

# Run the application 
shinyApp(ui = ui, server = server)

