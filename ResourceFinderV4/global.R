# Load packages ----
library(httr)
library(readxl)
library(tidyverse)
library(leaflet)
library(googleway)
library(ggmap)
library(geosphere)




config <- config::get()

api_key<- config$googleKey


set_key(key = api_key)



# Copied script directly from Data.World documentation ----

GET("https://query.data.world/s/vsekujknpu3td7vruwuspq2isynz4c", write_disk(tf <- tempfile(fileext = ".xlsx")))


resources <- read_excel(tf)

# Changing variable names ----
names(resources) <-str_to_title(names(resources))

# Converting Lon & Lat to numeric
resources <- resources %>%
  mutate(Lon = as.numeric(Lon), Lat = as.numeric(Lat))

