library(shiny)
library(leaflet)

leafletMapUI <- function(id) {
  ns <- NS(id)
  
  leafletOutput(outputId = ns("resource_map"))
  
}

leafletMapServer <- function(input, output, session, map_dat) {
  
  output$resource_map <- renderLeaflet({
      leaflet() %>%
      addProviderTiles(provider = providers$CartoDB.Voyager) %>%
      setView(lng = -79.8297, lat = 36.0900, zoom = 9)
  })
  
  observe({
    leafletProxy("resource_map", data = map_dat) %>%
      clearMarkers() %>%
      addMarkers(lng = ~Lon, lat = ~Lat, popup = ~Organization)
  })

  }