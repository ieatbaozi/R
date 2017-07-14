
library(shiny)

source('/srv/shiny-server/powermeterreport/query.R')

shinyUI(fluidPage(
  
  
  titlePanel("Power Meter Report"),
  
 # wellPanel(
 #  helpText(   a("Click Here to Download Survey",target="_blank",     href="http://www.dfcm.utoronto.ca/Assets/DFCM2+Digital+Assets/Family+and+Community+Medicine/DFCM+Digital+Assets/Faculty+$!26+Staff/DFCM+Faculty+Work+$!26+Leadership+Survey+Poster.pdf")
 #   )
 # ),
  
  mainPanel(
    
    dateRangeInput("daterange", "Date range for diff-kWh:",
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
      tabPanel('All of Table',  dataTableOutput('ex2')),
      tabPanel('Input Curr-Volt/Daily diff kWh',column(7, wellPanel(
        selectInput("pickmeter","Meter Name:",choices = all.metername$MeterName),
        dateInput('date', 'Date input:', value = Sys.Date(),min = Sys.Date()-90 , max = Sys.Date()),
        timeInput("time_input1", "from", value = strptime("00:00:00", "%T")),
        timeInput("time_input2", "to", value = strptime("23:59:59", "%T"))
      )),
      actionButton("dospec", "Get Data")),
      tabPanel('Curr-Volt',plotlyOutput("plotspec"), verbatimTextOutput("summaryspec")),
      tabPanel('Split Curr-Volt',plotlyOutput("plotspecCurr"),plotlyOutput("plotspecVolt")),
      tabPanel('Export',downloadButton('downloadDataDaily','Download Daily diffkWh subemeter'),downloadButton('downloadDataspec', 'Download Volt-Curr Data'),downloadButton('downloadPlotspec', 'Download Volt-Curr Plot'))
      )
    
  )
))
