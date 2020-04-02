library(shiny)
library(tidyverse)
library(shinydashboard)
library(leaflet)
library(readxl)
library(httr)
library(jsonlite)
library(config)

config<- config::get(file = "config/config.yml")
dwtoken <- paste("Bearer ", config$dw_token, sep = "")

dw <- httr::GET("https://api.data.world/v0/queries/398a764e-b7fc-4d0c-a2aa-77e9c1cb7ecf/results",
                add_headers(
                  accept= "text/csv",
                  authorization = dwtoken
                ))

content_raw <-content(dw, as = 'text')

resources <- fromJSON(content_raw)

names(resources) <-str_to_title(names(resources))














#Old code left in for troubleshooting data upload problems

# resources <- read_excel("resourcesGeocoded2.xlsx", 
#                         col_types = c("text", "text", "text", 
#                                       "text", "text", "text", "text", "text", 
#                                       "text", "text", "text", "text", "text", 
#                                       "text", "text", "text", "text", "text", 
#                                       "text", "text", "text", "text", "numeric", 
#                                       "numeric", "text"))




