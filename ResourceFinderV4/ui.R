# Load packages
library(shiny)
library(shinydashboard)





# Define UI for shiny app
dashboardPage(
    
    dashboardHeader(title = "COVID-19 Resource Finder"),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Help Video", tabName = "helpVideo", icon = icon("play-circle")),
            menuItem("Resources", tabName = "resources", icon = icon("th-list")),
            selectInput(inputId = "category",
                        label = "Start by selecting a category:",
                        choices = unique(resources$Category),
                        multiple = TRUE,
                        selectize = TRUE
            ),
            selectInput(inputId = "cities",
                        label = "Next, selection location(s):",
                        choices = c("All Cities" = ''),
                        multiple = TRUE,
                        selectize = TRUE,
                        selected = "All Cities"),
            selectInput(inputId = "programs",
                        label = "Finally, select program(s):",
                        choices = c("All Programs" = ''),
                        multiple = TRUE,
                        selectize = TRUE) #,
            #addressInputUI("address_input")
        ) #end sidebar menu
        
    ), # end sidebar
    
    dashboardBody(
        tags$head(includeHTML(("google-analytics.html"))),
        tabItems(
            tabItem(tabName = "helpVideo",
                    fluidRow(
                        box(
                            width = 8, status = "info", solidHeader = TRUE,
                            title = "Click on 'Resources' Tab to the left to jump to resources"
                      
                        ),
                    ),# end fluidRow
                    fluidRow(
                        column(width = 3),
                        box(width = NULL,
                            title = "Quick Start Video ",
                            HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                        ),
                        column(width = 3)
                    ) # closing fluidRow
            ), # Closing helpVideo tabItem
            tabItem(tabName = "resources",
                    # fluidRow(
                    #     column(width = 3),
                    #     box(width = NULL,
                    #         title = "YT Video Here",
                    #         HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                    #     ),
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