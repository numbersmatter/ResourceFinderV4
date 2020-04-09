# Load packages
library(tidyverse)
library(httr)
library(jsonify)
library(sf)
library(leaflet)

# make API  call and interpret response
res <- GET(url = "https://nominatim.openstreetmap.org/search?q=373+umstead+drive,chapel+hill,nc&format=json") %>%
  .$content %>%
  rawToChar() %>%
  from_json()

# convert to spatial object, transform projection as necessary, and buffer ~3 miles
x <- if (class(res) == "list") {
  res %>%
    map_df(.x = ., .f = as_tibble) %>%
    distinct(place_id,.keep_all = T) %>%
    st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    st_transform(crs = 3488) %>%
    st_buffer(2000) %>%
    st_transform(crs = 4326)
} else {
  res %>%
    st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    st_transform(crs = 3488) %>%
    st_buffer(2000) %>%
    st_transform(crs = 4326)
}

# including just to validate for you
leaflet() %>%
  addProviderTiles(provider = providers$OpenStreetMap) %>%
  addPolygons(data = x, fillColor = "red", stroke = F, opacity = 0.7)

# This would be how I would implement with a text input in Shiny maybe?
url <- paste0("https://nominatim.openstreetmap.org/search?q=", str_replace_all(input$text, " ", "+"), "&format=json")

# Possible way to combine everything into one piped chain
GET(url = url) %>%
  .$content %>%
  rawToChar() %>%
  from_json() %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(crs = 3488) %>%
  st_buffer(2000) %>%
  st_transform(crs = 4326)








