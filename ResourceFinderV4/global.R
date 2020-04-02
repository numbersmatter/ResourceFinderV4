library(shiny)
library(tidyverse)
library(shinydashboard)
library(leaflet)
library(rmarkdown)
library(readxl)
library(httr)
library(jsonlite)
library(config)

# config<- config::get(file = "config/config.yml")
# dwtoken <- paste("Bearer ", config$dw_token, sep = "")
# 
# dw <- httr::GET("https://api.data.world/v0/queries/4c8d3c10-07d9-4788-921b-e4b9020cda50/results", 
#                 add_headers(
#                   accept= "text/csv",
#                   authorization = dwtoken
#                 ))
# 
# content_raw <-content(dw, as = 'text')





# resources <- read_excel("resourcesGeocoded2.xlsx", 
#                         col_types = c("text", "text", "text", 
#                                       "text", "text", "text", "text", "text", 
#                                       "text", "text", "text", "text", "text", 
#                                       "text", "text", "text", "text", "text", 
#                                       "text", "text", "text", "text", "numeric", 
#                                       "numeric", "text"))




