library(shiny)
source('~/R/work/testsplit/query.R')
source('ui.R', local = TRUE)
source('server.R')


shinyApp(
  ui = ui,
  server = server
)