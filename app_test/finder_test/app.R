# Load packages for base app
library(shiny)
library(reactable)
library(bootstraplib)
library(shinycssloaders)

# Bootstrap styling
bs_theme_new(version = "4+3", bootswatch = "pulse")
bs_theme_add_variables(`font-family-base` = "Roboto")

# Source necessary files
source("global.R")
source("inputModule.R")
source("leaflet_module.R")

# Define UI for application
ui <- navbarPage(title = "Guilford COVID-19 Resource Finder",
                 collapsible = TRUE, windowTitle = "COVID-19 Resources",
                 tabPanel(title = "Home",
                          fluidPage(
                            bootstrap(),
                            sidebarLayout(
                              sidebarPanel = sidebarPanel(
                                filterDataInputsUI("selections",
                                                   categories = unique(resources$Category))
                              ), # Closing sidebarPanel
                              mainPanel = mainPanel(
                                withSpinner(leafletMapUI("main_map"), type = 6),
                                reactableOutput("table")
                              )
                            ) # Closing sidebarLayout
                          ) # Closing fluidPage
                          ) # Closing Home tabPael
                 ) # Closing main navbarPage

# Define server logic
server <- function(input, output, session) {
  
  # Coll Module for input selections and store as an object to reuse 
  selections <- callModule(filterDataServer, "selections", df = resources)
  
  # Create a filtered dataset based on user inputs from input module
  final_df <- reactive({
    resources %>%
      filter(if (is.null(selections$categories())) !(Category %in% selections$categories()) else Category %in% selections$categories()) %>%
      filter(if (is.null(selections$cities())) !(City %in% selections$cities()) else City %in% selections$cities()) %>%
      filter(if (is.null(selections$programs())) !(Program %in% selections$programs()) else Program %in% selections$programs())
  })
  
  # Create an observer for change in data and call module for main Leaflet map
  observe({
    map_dat <- final_df()
    
    callModule(leafletMapServer, "main_map", map_dat = map_dat)
  })
  
  output$table <- renderReactable({
    final_df() %>%
      select(Program, Category, Organization, Description) %>%
      reactable()
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
