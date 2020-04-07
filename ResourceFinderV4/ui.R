#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)


# Define UI for shiny app
ui <- dashboardPage(
    dashboardHeader(title = "Guilford COVID-19 Resource Finder"),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Help Video", tabName = "helpVideo", icon = icon("play-circle")),
            menuItem("Resources", tabName = "resources", icon = icon("th-list"))
        ),
#Filter inputs
        
        selectizeInput(
            "category",
            "Select Category:",
            choices = resources$Category,
            multiple = TRUE
        ),
        #filter City        
        selectizeInput(
            "city",
            "Select Cities:",
            choices = c("All Cities" = ''),
            multiple = TRUE
        ),
        
        selectizeInput(
            "program",
            "Select Programs:",
            choices = c("All Programs" = ''),
            multiple = TRUE
        )
    ),
    
    dashboardBody(
        fluidRow(
            column(12, 
                   box(
                       width = NULL, 
                       title = "YT Video Here", 
                       HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                   ))
            ),
        
        fluidRow(


            valueBoxOutput("programTotal"),
            valueBoxOutput("programValue")
            
        ),
        
        #leaflet map of resources
        fluidRow(
            box(
                title = 'Map of Resources',
                width = 12,
                leafletOutput("map")
            )
        ),
        
        
            uiOutput("programinfo")
        
        

            
        )
    )