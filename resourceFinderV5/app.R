# Load packages
library(shiny)
library(shinydashboard)
library(shinycssloaders)

# Source necessary files
source("global.R")
source("inputModule.R")
source("leaflet_module.R")

# Define UI for shiny app
ui <- dashboardPage(
  dashboardHeader(title = "Guilford COVID-19 Resource Finder"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Help Video", tabName = "helpVideo", icon = icon("play-circle")),
      menuItem("Resources", tabName = "resources", icon = icon("th-list")),
      filterDataInputsUI("selections",
                         categories = unique(resources$Category))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "helpVideo",
              fluidRow(
                column(width = 3),
                column(width = 6,
                    title = "YT Video Here",
                    HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                ),
                column(width = 3)
              ), # closing fluidRow
      ), # Closing helpVideo tabItem
      tabItem(tabName = "resources",
              fluidRow(
                column(width = 2),
                valueBoxOutput(width = 4, "programTotal"),
                valueBoxOutput(width = 4, "programValue"),
                column(width = 2)
              ), # closing fluidRow
              fluidRow(
                box(title = 'Map of Resources',
                    width = 12,
                    withSpinner(leafletMapUI("main_map"), type = 6)),
                uiOutput("programinfo")
              ) # closing fluidRow
      ) # Closing resources tabItem
    ) # Closing tabItems
  ) # Closing dashboardBody
) # Closing dashboardPage


# Define server logic
server <- (function(input, output, session) {
  
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
 
  output$programTotal <- renderValueBox({
    valueBox(
      paste0(nrow(resources)), "Total Programs", icon = icon("list"),
      color = "blue"
    )
    
  })
  
  output$programValue <- renderValueBox({
    valueBox(
      paste0(nrow(final_df())), "# of filtered Programs", icon = icon("list"),
      color = "green"
    )
  })

  #programdata
  output$programinfo <- renderUI({
    lapply(1:nrow(final_df()), function(i){
      fluidRow(
        column(width = 12,
        box(
          width = 12,
          title = paste0("A Program of: ", final_df()[i, 'Organization']),
          h2(final_df()[i, 'Program']),
          p("Address: ", str_to_title(final_df()[i,'Geoaddress']),
            br(), 
            "Phone: ", final_df()[i,'Phone'], br(),
            "website: ", a(href= paste0(final_df()[i,'Website']), paste0(final_df()[i,'Website']) , target="_blank" )),
          h3("Description"),
          p(final_df()[i,'Description']),
          h3("Changes to the Program Due to COVID-19"),
          p(final_df()[i,'Notes']),
          h4("Hours Open:"),
          p("Monday: ", final_df()[i,'Mon'], br(), 
            "Tuesday: ", final_df()[i,'Tue'],br(),
            "Wednesday: ", final_df()[i,'Wed'],br(),
            "Thursday: ", final_df()[i,'Thu'],br(),
            "Friday: ", final_df()[i,'Fri'],br(),
            "Saturday: ", final_df()[i,'Sat'],br(),
            "Sunday: ", final_df()[i,'Sun'],br(),
          )
        )
      )
      )
    })
    
  })
  
})


# Run the application 
shinyApp(ui = ui, server = server)