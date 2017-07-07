library(shiny)
source('/srv/shiny-server/powermeterreport/query.R')
source('ui.R', local = TRUE)
source('server.R')


shinyApp(
  ui = ui,
  server = server
)
