#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)

ui <- fluidPage(
  titlePanel("Resource Map"),
  mainPanel(
    textInput("county", "Enter County Name:"),
    leafletOutput("map")
  )
)


server <- function(input, output) {
  # Read your data (replace 'your_data.csv' with your actual data file)
  resources <- read.csv("SD Resource Providers.csv")
  
  filteredData <- reactive({
    if (!is.null(input$county)) {
      resources %>%
        filter(grepl(input$county, COUNTIES_SERVED, ignore.case = TRUE))
    } else {
      resources
    }
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = filteredData(),
                 lat = ~LATITUDE,
                 lng = ~LONGITUDE,
                 label = ~RESOURCE)
  })
}

shinyApp(ui, server)
