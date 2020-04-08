# Load packages
library(shiny)
library(shinydashboard)

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
                        box(width = NULL,
                            title = "YT Video Here",
                            HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                            ),
                        column(width = 3)
                        ) # closing fluidRow
                    ), # Closing helpVideo tabItem
            tabItem(tabName = "resources",
                    fluidRow(
                        valueBoxOutput("programTotal"),
                        valueBoxOutput("programValue")
                        ), # closing fluidRow
                    fluidRow(
                        box(title = 'Map of Resources',
                            width = 12,
                            leafletOutput("map")),
                        uiOutput("programinfo")
                        ) # closing fluidRow
                    ) # Closing resources tabItem
            ) # Closing tabItems
        ) # Closing dashboardBody
    ) # Closing dashboardPage