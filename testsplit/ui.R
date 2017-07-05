
library(shiny)

source('~/R/work/testsplit/query.R')

shinyUI(fluidPage(
  
  
  titlePanel("Power Meter Report"),
  
 # wellPanel(
 #  helpText(   a("Click Here to Download Survey",target="_blank",     href="http://www.dfcm.utoronto.ca/Assets/DFCM2+Digital+Assets/Family+and+Community+Medicine/DFCM+Digital+Assets/Faculty+$!26+Staff/DFCM+Faculty+Work+$!26+Leadership+Survey+Poster.pdf")
 #   )
 # ),
  
  mainPanel(
    
    dateRangeInput("daterange", "Date range:",
                   start = Sys.Date()-7,
                   end = Sys.Date(),min=start.date,max=Sys.Date()+1),
    actionButton("do", "Submit"),
    navbarPage(
      title = 'Options',
     
      tabPanel('Display Plot',   plotlyOutput("plot"),
               selectInput("dataset", "Choose a dataset:", 
                           choices = c("TotalPower","MDB1-1", "MDB2-1", "MDB2-2","MDB2-3",
                                       "MDB3-1","MDB3-2","MDB4-1","MDB4-2",
                                       "MDB5-1","MDB6-1","MDB6-2","MDB7-1",
                                       "MDB7-2","Building1","Building2","Building3",
                                       "Building4","Building5","Building6","Building7"))
               , verbatimTextOutput("summary")),
      tabPanel('Export',  downloadButton('downloadData', 'Download Data'),downloadButton('downloadPlot', 'Download Plot')),
      tabPanel('Display Table', dataTableOutput('ex1')),
      tabPanel('All of Table',  dataTableOutput('ex2')))
    
  )
))