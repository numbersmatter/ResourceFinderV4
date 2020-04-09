library(shiny)
library(tidyverse)
library(sf)
library(httr)
library(jsonify)

addressInputUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    textInput(inputId = ns("address"), label = "Input an address:",
              placeholder = "Format like: 301 West Market Street, Greensboro, NC"),
    actionButton(inputId = ns("lookup"), label = "Submit Address")
  )
  
}

addressInputServer <- function(input, output, session) {
  
  url <- eventReactive(input$lookup, {
    paste0("https://nominatim.openstreetmap.org/search?q=", str_replace_all(input$address, " ", "+"), "&format=json")
  })
  
  search_url <- reactive ({ url() })
  
  res <- reactive({
    api_call <- GET(url = search_url()) %>%
      .$content %>%
      rawToChar() %>%
      from_json()
    
    if (is.list(api_call)) {
      api_call %>%
        map_df(.x = ., .f = as_tibble) %>%
        distinct(place_id,.keep_all = T) %>%
        st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
        st_transform(crs = 3488) %>%
        st_buffer(2000) %>%
        st_transform(crs = 4326)
    } else {
      api_call %>%
        st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
        st_transform(crs = 3488) %>%
        st_buffer(2000) %>%
        st_transform(crs = 4326)
    }
    
    
  })
  
  return(reactive({ res() }))
  
}