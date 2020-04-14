# Load packages ----
library(httr)
library(readxl)
library(tidyverse)
library(leaflet)


api_key<-"PLACE API KEY HERE"

set_key(key = api_key)


# Copied script directly from Data.World documentation ----
GET("https://query.data.world/s/q3tyzwg4ik44vvnsakvuzoxdfqdg6y", write_disk(tf <- tempfile(fileext = ".xlsx")))

resources <- read_excel(tf)

# Changing variable names ----
names(resources) <-str_to_title(names(resources))

# Converting Lon & Lat to numeric
resources <- resources %>%
  mutate(Lon = as.numeric(Lon), Lat = as.numeric(Lat))

